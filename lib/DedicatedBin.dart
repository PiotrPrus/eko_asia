class DedicatedBin {
  String name;
  String namePl;
  List<String> products;

  DedicatedBin({this.name, this.namePl, this.products});

  DedicatedBin.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    namePl = json['name_pl'];
    products = json['products'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_pl'] = this.namePl;
    data['products'] = this.products;
    return data;
  }
}

