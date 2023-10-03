import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/direction.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthFirebaseService extends ChangeNotifier {
  Stream<User?> checkAuthState() {
    return FirebaseAuth.instance.authStateChanges();
  }

  List<Address> _almacenes = [];

  List<Address> get almacenes => _almacenes;

  set almacenes(List<Address> value) {
    _almacenes = value;
  }

  Future<List<Address>> retrieveAlmacenes() async {
    almacenes = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('almacenes').get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      almacenes.add(
          Address.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }

    return almacenes;
  }

  Future<String?> createUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final String messagge;
      if (e.code == 'weak-password') {
        messagge = 'La contraseña es demadasiado corta';
      } else {
        messagge = 'Este correo electrónico ya se encuentra registrado';
      }
      return messagge;
    }
    return null;
  }

  String? createUserDB(UserApp userApp) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      userApp.id = uid;
      userApp.email = user.email!;

      if (user.photoURL != null) {
        userApp.profilePicture = user.photoURL;
      } else {
        userApp.profilePicture =
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
      }

      final FirebaseFirestore db = FirebaseFirestore.instance;

      db
          .collection("users")
          .doc(uid)
          .set(userApp.toJson())
          .onError((e, _) => 'Error');

      return null;
    }
    return 'Ha ocurrido un error';
  }

  Future<String?> signInUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        const String errorMessagge =
            'Correo electrónico y/o contraseña incorrecto(s)';
        return errorMessagge;
      }
    }
    return null;
  }

  Future signOutUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user!.providerData.isNotEmpty) {
      await GoogleSignIn().signOut();
    }
    await FirebaseAuth.instance.signOut();
  }

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  String sendEmailUserVerified() {
    final user = FirebaseAuth.instance.currentUser;
    final String message;

    if (user != null && !user.emailVerified) {
      user.sendEmailVerification();
      message = 'Se envió un correo de verifiación';
    } else {
      message = 'Usuario verificado';
    }

    return message;
  }

  String checkUserVerified() {
    User? user = FirebaseAuth.instance.currentUser;
    final String message;

    if (user != null && !user.emailVerified) {
      message = 'Usuario no verificado';
    } else {
      message = 'Usuario verificado';
    }
    return message;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  bool isUserLoggedWithProvider(User auth) {
    if (auth.providerData.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool isUserAdmin() {
    final user = FirebaseAuth.instance.currentUser;
    bool isUseradmin = false;

    if (isUserLoggedWithProvider(user!)) {
      for (final providerProfile in user.providerData) {
        if (providerProfile.email == 'admin_domas@adminapp.com') {
          isUseradmin = true;
        }
      }
    } else {
      if (user.email == 'admin_domas@adminapp.com') {
        isUseradmin = true;
      }
    }
    return isUseradmin;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final auth = FirebaseAuth.instance;
    try {
      // Verificar si el correo ya esta registrado en Firebase
      final signInMethods = await auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isEmpty) {
        NotificationsService.showSnackbar(
            'Este correo no se encuentra registrado', errorColor);
        return;
      }

      // Enviar correo electrónico de cambio de contraseña
      await auth.sendPasswordResetEmail(email: email);
      NotificationsService.showSnackbar(
          'Se envió un correo para cambiar tu contraseña', sucessColor);
    } catch (e) {
      NotificationsService.showSnackbar('Intente nuevamente', errorColor);
    }
  }

  Future<bool> checkUserExist() async {
    final user = FirebaseAuth.instance.currentUser;
    final docRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final docSnapshot = await docRef.get();

    return docSnapshot.exists;
  }

  Future<UserApp> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    final usersCollection = FirebaseFirestore.instance.collection('users');
    final userDocument = await usersCollection.doc(user!.uid).get();

    UserApp userAppData = UserApp.fromJson(userDocument.data()!);

    return userAppData;
  }

  Future<void> addAddressToUser(Address address) async {
    final user = FirebaseAuth.instance.currentUser;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    await userRef.update({
      'addresses': FieldValue.arrayUnion([address.toJson()])
    });
  }

  Future<void> updateAddressAtIndex(int index, Address newAddress) async {
    final user = FirebaseAuth.instance.currentUser;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final userData = await userRef.get();
    Map<String, dynamic> userDataMap = userData.data() as Map<String, dynamic>;
    List<dynamic> addresses = List.from(userDataMap['addresses']);

    if (index >= 0 && index < addresses.length) {
      addresses[index] = newAddress.toJson();
      await userRef.update({'addresses': addresses});
    } else {
      throw Exception('Invalid index');
    }
  }

Future<void> removeAddressAtIndex(int index) async {
  final user = FirebaseAuth.instance.currentUser;
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(user!.uid);

  final userData = await userRef.get();
  Map<String, dynamic> userDataMap = userData.data() as Map<String, dynamic>;
  List<dynamic> addresses = List.from(userDataMap['addresses']);

  if (index >= 0 && index < addresses.length) {
    addresses.removeAt(index);
    await userRef.update({'addresses': addresses});
  } else {
    throw Exception('Invalid index');
  }
}


  Future sendEmail(
      {required String paymentDetail,
      required String address,
      required double totalPrice}) async {
    const String serviceId = 'service_mtfniph';
    const String templateId = 'template_16e8xmm';
    const String userId = 'lcM9j77NDvvE0Dj3A';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final user = FirebaseAuth.instance.currentUser;
    final String email = user!.email!;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users') // Reemplaza 'users' por el nombre de tu colección
        .doc(user.uid)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String firstName = userData['name'];
      String lastName = userData['last_name'];

      final String name = '$firstName $lastName';

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('carts')
          .where('id', isEqualTo: user.uid)
          .get();

      List<Cart> cartItems = [];

      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        cartItems.add(
            Cart.fromJson(documentSnapshot.data() as Map<String, dynamic>));
      }

      String allProducts = '';

      for (int i = 0; i < cartItems.length; i++) {
        Cart product = cartItems[i];
        allProducts += 'Nombre del producto: ${product.productName}\n';
        allProducts += 'Cantidad: ${product.quantity}\n';
        allProducts += 'Precio unitario: \$${product.initialPrice}\n';
        allProducts += 'Precio total: \$${product.productPrice}\n';
        allProducts += '\n';
      }

      final response = await http.post(url,
          headers: {
            'origin': 'http://localhost',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'user_email': email,
              'reply_to': 'no-reply@no-reply.com',
              'from_name': 'Do Mas',
              'user_name': name,
              'products': allProducts,
              'payment_detail': paymentDetail,
              'total_price': '\$$totalPrice',
              'address': address
            }
          }));

      debugPrint('Resultado de correo${response.body}');
    }
  }
}
