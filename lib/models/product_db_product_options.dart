class ProductOptions {
  String? imagen;
  String? optionName;

  ProductOptions({this.imagen, this.optionName});

  ProductOptions.fromJson(Map<String, dynamic> json) {
    imagen = json['imagen'];
    optionName = json['option_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['imagen'] = this.imagen;
    data['option_name'] = this.optionName;
    return data;
  }
}