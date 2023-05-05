class Cloth {
  String? _id;
  String? get id => _id;
  String name;
  String description;
  List<String> images;
  double price;
  String sex;
  DateTime createdAt = DateTime.now();

  Cloth({
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.sex,
  });

  factory Cloth.fromMap(Map<String, dynamic> data) {
    print("DATA");
    print(data);
    var cloth = Cloth(
      name: data["name"],
      description: data["description"],
      images:
          (data["images"] as List<dynamic>).whereType<String>().toList(),
      price: data["price"],
      sex: data["sex"],
    );
    cloth.createdAt = DateTime.parse(data["createdAt"]);
    if (data["_id"] != null) {
      cloth._id = data["_id"];
    }
    return cloth;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (_id != null) "_id": _id,
      "name": name,
      "description": description,
      "images": images,
      "price": price,
      "sex": sex,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
