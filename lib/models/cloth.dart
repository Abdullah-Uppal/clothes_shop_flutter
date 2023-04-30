class Cloth {
  String? _id;
  String name;
  String description;
  String image;
  double price;
  String sex;

  Cloth({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.sex,
  });

  factory Cloth.fromMap(Map<String, dynamic> data) {
    var cloth = Cloth(
      name: data["name"],
      description: data["description"],
      image: data["image"],
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
      "image": image,
      "price": price,
      "sex": sex,
    };
  }
}
