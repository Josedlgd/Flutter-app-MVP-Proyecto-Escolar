import 'package:domas_ecommerce/models/models.dart';
import 'package:intl/intl.dart';

class ProductDB {
  bool? available;
  List<String>? caseSearch;
  List<Category>? categories;
  List<Section>? sections;
  num? descount;
  late String description;
  String? id;
  List<String>? images;
  bool? isPopular;
  String? name;
  num? price;
  List<ProductOptions>? productOptions;
  List<ProductSizes>? productSize;
  String? productTypeId;
  int? stock;
  int? stockSold;
  String? titleOptions;
  String? titleSize;
  String? descountType;
  DateTime? createdAt;

  ProductDB(
      {this.available,
      this.caseSearch,
      this.categories,
      this.descount,
      required this.description,
      this.id,
      this.images,
      this.isPopular,
      this.name,
      this.price,
      this.productOptions,
      this.productSize,
      this.productTypeId,
      this.stock,
      this.stockSold,
      this.titleOptions,
      this.titleSize,
      this.descountType,
      this.createdAt,
      this.sections});

  ProductDB.fromJson(Map<String, dynamic> json) {
    available = json['available'];
    if (json['case_search'] != null) {
      caseSearch = <String>[];
      json['case_search'].forEach((v) {
        caseSearch!.add(v);
      });
    }
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
      });
    }

    if (json['sections'] != null) {
      sections = <Section>[];
      json['sections'].forEach((v) {
        sections!.add(Section.fromJson(v));
      });
    }
    descount = json['descount'];
    description = json['description'];
    id = json['id'];
    if (json['images'] != null) {
      images = <String>[];
      json['images'].forEach((v) {
        images!.add(v);
      });
    }
    isPopular = json['is_popular'];
    name = json['name'];
    price = json['price'];
    if (json['product_options'] != null) {
      productOptions = <ProductOptions>[];
      json['product_options'].forEach((v) {
        productOptions!.add(ProductOptions.fromJson(v));
      });
    }
    if (json['product_size'] != null) {
      productSize = <ProductSizes>[];
      json['product_size'].forEach((v) {
        productSize!.add(ProductSizes.fromJson(v));
      });
    }
    productTypeId = json['product_type_id'];
    stock = json['stock'];
    stockSold = json['stock_sold'];
    titleOptions = json['title_options'];
    titleSize = json['title_size'];
    descountType = json['descount_type'];
    createdAt = DateTime.parse(json['created_at'].toDate().toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['available'] = this.available;
    data['case_search'] = this.caseSearch;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.sections != null) {
      data['sections'] = this.sections!.map((v) => v.toJson()).toList();
    }
    data['descount_type'] = this.descountType;
    data['descount'] = this.descount;
    data['description'] = this.description;
    data['id'] = this.id;
    data['images'] = this.images;
    data['is_popular'] = this.isPopular;
    data['name'] = this.name;
    data['price'] = this.price;
    if (this.productOptions != null) {
      data['product_options'] =
          this.productOptions!.map((v) => v.toJson()).toList();
    }
    if (this.productSize != null) {
      data['product_size'] = this.productSize!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['product_type_id'] = this.productTypeId;
    data['stock'] = this.stock;
    data['stock_sold'] = this.stockSold;
    data['title_options'] = this.titleOptions;
    data['title_size'] = this.titleSize;
    return data;
  }
}
