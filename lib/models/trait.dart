class Trait {
  String key;
  String name;
  String description;
  List<Bonus> bonuses;

  Trait({
    this.key,
    this.name,
    this.description,
    this.bonuses,
  });

  factory Trait.fromJson(Map<String, dynamic> json) {
    return Trait(
      key: json['key'],
      name: json['name'],
      description: json['description'],
      bonuses: (json['bonuses'] as List).map((b) => Bonus.fromJson(b)).toList(),
    );
  }
}

class Bonus {
  int needed;
  String effect;

  Bonus({
    this.needed,
    this.effect,
  });

  factory Bonus.fromJson(Map<String, dynamic> json) {
    return Bonus(
      needed: json['needed'],
      effect: json['effect'],
    );
  }
}
