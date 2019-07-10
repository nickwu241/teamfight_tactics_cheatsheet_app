class Item {
  String name;
  String key;
  String bonus;
  String type;
  int depth;

  List<String> buildsInto;
  List<String> buildsFrom;

  Item({
    this.name,
    this.key,
    this.bonus,
    this.type,
    this.depth,
    this.buildsInto,
    this.buildsFrom,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      key: json['key'],
      bonus: json['bonus'],
      type: json['type'],
      depth: json['depth'],
      buildsInto: json['buildsInto']?.cast<String>(),
      buildsFrom: json['buildsFrom']?.cast<String>(),
    );
  }
}
