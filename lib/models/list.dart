/// Dynamic Shop List
class ShopList {
  late String name = "";
  late List<ShopListObject> objects = [];

  ShopList(
    this.name, {
    required this.objects,
  });

  ShopList.fromJson(Map<String, dynamic> m) {
    name = m["name"];
    objects = List<ShopListObject>.generate(
      m['objects'].length,
      (index) => ShopListObject.fromJson(m['objects'][index]),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "objects": List.generate(
          objects.length,
          (index) => objects[index].toJson(),
        ),
      };
}

/// Shop List Object
class ShopListObject {
  late String name;

  ShopListObject(this.name);

  ShopListObject.fromJson(Map<String, dynamic> m) {
    name = m["name"];
  }

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
