class ZomatoLocation {
  final int id;
  final int cityId;
  final String type;
  final String title;
  final String country;

  ZomatoLocation({
    this.id,
    this.cityId,
    this.type,
    this.title,
    this.country,
  });

  ZomatoLocation.fromMap(Map map)
      : id = map['entity_id'],
        cityId = map['city_id'],
        type = map['entity_type'],
        title = map['title'],
        country = map['country_name'];

  Map toMap() => {
        'entity_id': id,
        'city_id': cityId,
        'entity_type': type,
        'title': title,
        'country_name': country
      };
}
