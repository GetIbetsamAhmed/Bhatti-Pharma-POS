class Categories {
  int? id;
  String? name;

  Categories({required this.id, required this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['CategoryID'];
    name = json['CategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['CategoryID'] = id;
    data['CategoryName'] = name;
    return data;
  }
}
