class Champion {
  String key;
  List<String> classes;
  List<String> origins;
  int cost;
  Ability ability;
  Stats stats;

  Champion({
    this.key,
    this.classes,
    this.origins,
    this.cost,
    this.ability,
    this.stats,
  });

  factory Champion.fromJson(Map<String, dynamic> json) {
    return Champion(
      key: json['key'],
      classes: json['class']?.cast<String>(),
      origins: json['origin']?.cast<String>(),
      cost: json['cost'],
      ability: Ability.fromJson(json['ability']),
      stats: Stats.fromJson(json['stats']),
    );
  }
}

class Ability {
  String name;
  String description;
  String type;
  int manaCost;
  int manaStart;
  List<AbilityStat> stats;

  Ability({
    this.name,
    this.description,
    this.type,
    this.manaCost,
    this.manaStart,
    this.stats,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json['name'],
      description: json['description'],
      type: json['type'],
      manaCost: json['manaCost'],
      manaStart: json['manaStart'],
      stats:
          (json['stats'] as List).map((s) => AbilityStat.fromJson(s)).toList(),
    );
  }
}

class AbilityStat {
  String type;
  String value;

  AbilityStat({
    this.type,
    this.value,
  });

  factory AbilityStat.fromJson(Map<String, dynamic> json) {
    return AbilityStat(
      type: json['type'],
      value: json['value'].toString(),
    );
  }
}

class Stats {
  int damage;
  double attackSpeed;
  int dps;
  int range;
  int health;
  int armor;
  int magicResist;

  Stats({
    this.damage,
    this.attackSpeed,
    this.dps,
    this.range,
    this.health,
    this.armor,
    this.magicResist,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      damage: json['offense']['damage'],
      attackSpeed: json['offense']['attackSpeed'] + 0.0,
      dps: json['offense']['dps'],
      range: json['offense']['range'],
      health: json['defense']['health'],
      armor: json['defense']['armor'],
      magicResist: json['defense']['magicResist'],
    );
  }
}
