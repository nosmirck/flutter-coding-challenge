class Cuisine {
  final int id;
  final String name;

  Cuisine({
    this.id,
    this.name,
  });

  Cuisine.fromMap(Map map)
      : id = map['cuisine_id'],
        name = map['cuisine_name'];

  @override
  String toString() => name;
}
