class Cloth {
  String? _id;
  String name;
  String description;
  List<String> images;
  double price;
  String sex;

  Cloth({
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.sex,
  });

  factory Cloth.fromMap(Map<String, dynamic> data) {
    var cloth = Cloth(
      name: data["name"],
      description: data["description"],
      images: data["images"],
      price: data["price"],
      sex: data["sex"],
    );
    if (data["_id"]) {
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
    };
  }
}
