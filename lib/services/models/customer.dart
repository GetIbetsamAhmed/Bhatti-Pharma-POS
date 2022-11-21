class Customer {
  String? name;
  String? gmail;
  String? phno;
  String? address;

  Customer({
    this.name,
    this.gmail,
    this.phno,
    this.address,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    gmail = json['gmail'] ?? "";
    phno = json['phone'] ?? "";
    address = json['address'] ?? "";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['name'] = name;
    data['gmail'] = gmail;
    data['phone'] = phno;
    data['address'] = address;
    return data;
  }
}
