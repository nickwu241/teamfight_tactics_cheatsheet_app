import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'models/champion.dart';
import 'models/item.dart';
import 'models/trait.dart';
import 'utils.dart';

class Data {
  static Map<String, Item> items;
  static Map<String, Trait> classes;
  static Map<String, Trait> origins;
  static Map<String, Champion> champions;
  static List<Item> baseItems = [];
  static List<Item> combinedItems = [];
  static Map<String, List<Champion>> traitToChampionsMap = {};

  static Future<void> initialize() async {
    final itemsJson = await rootBundle.loadString('assets/data/items.json');
    final classesJson = await rootBundle.loadString('assets/data/classes.json');
    final originsJson = await rootBundle.loadString('assets/data/origins.json');
    final championsJson =
        await rootBundle.loadString('assets/data/champions.json');
    items = _parseItemMap(itemsJson);
    classes = _parseTraitMap(classesJson);
    origins = _parseTraitMap(originsJson);
    champions = _parseChampionMap(championsJson);

    // Partition items by base or combined.
    items.forEach((k, item) {
      if (item.depth == 1) {
        baseItems.add(item);
      } else {
        combinedItems.add(item);
      }
    });

    // Partition items by type.
    baseItems.sort(_compareItem);
    combinedItems.sort(_compareItem);

    // Group champions by traits.
    classes.forEach((k, v) => traitToChampionsMap[v.name] = []);
    origins.forEach((k, v) => traitToChampionsMap[v.name] = []);
    champions.forEach((k, v) {
      v.classes.followedBy(v.origins).forEach((trait) {
        traitToChampionsMap[trait].add(v);
      });
    });

    // Sort by tiers.
    traitToChampionsMap
        .forEach((k, v) => v.sort((c1, c2) => c1.cost.compareTo(c2.cost)));

    return Future.value(null);
  }

  static Future<String> fetchPatchMarkdown(String patch) {
    return rootBundle.loadString(AssetPath.forPatch(patch));
  }

  static Map<int, List<Champion>> getChampionsByCost() {
    Map<int, List<Champion>> championsByCost = {};
    champions.entries.forEach((entry) {
      final champion = entry.value;
      if (!championsByCost.containsKey(champion.cost)) {
        championsByCost[champion.cost] = [];
      }
      championsByCost[champion.cost].add(champion);
    });
    return championsByCost;
  }

  static List<Champion> getChampionList({
    SortType sortBy = SortType.cost,
    String keyword = '',
  }) {
    final result = _getChampionListByKeyword(keyword);
    print(result.map((c) => c.name));
    switch (sortBy) {
      case SortType.cost:
        return result..sort(_ChampionSort.byCost);
      case SortType.attackdamage:
        return result..sort(_ChampionSort.byAttackDamage);
      case SortType.attackspeed:
        return result..sort(_ChampionSort.byAttackSpeed);
      case SortType.armor:
        return result..sort(_ChampionSort.byArmor);
      case SortType.magicresist:
        return result..sort(_ChampionSort.byMagicResist);
      case SortType.health:
        return result..sort(_ChampionSort.byHealth);
    }
  }

  static List<Champion> _getChampionListByKeyword(String keyword) {
    if (keyword.isEmpty) {
      return champions.values.toList();
    }

    switch (getType(keyword)) {
      case StringType.champion:
        return [
          champions.values.firstWhere((c) => CaseIgnore.equals(c.name, keyword))
        ];
      case StringType.cls:
        return champions.values
            .where((c) => CaseIgnore.listContains(c.classes, keyword))
            .toList();
      case StringType.origin:
        return champions.values
            .where((c) => CaseIgnore.listContains(c.origins, keyword))
            .toList();
    }
  }

  static bool isClass(String traitKey) {
    return classes.keys.contains(traitKey);
  }

  static bool isOrigin(String traitKey) {
    return origins.keys.contains(traitKey);
  }

  static StringType getType(String keyword) {
    return isClass(keyword.toLowerCase())
        ? StringType.cls
        : isOrigin(keyword.toLowerCase())
            ? StringType.origin
            : StringType.champion;
  }

  static Map<String, Item> _parseItemMap(String jsonString) {
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    Map<String, Item> itemMap = {};
    jsonResponse.forEach((k, v) => itemMap[k] = Item.fromJson(v));
    return itemMap;
  }

  static Map<String, Trait> _parseTraitMap(String jsonString) {
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    Map<String, Trait> traitMap = {};
    jsonResponse.forEach((k, v) => traitMap[k] = Trait.fromJson(v));
    return traitMap;
  }

  static Map<String, Champion> _parseChampionMap(String jsonString) {
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    Map<String, Champion> championMap = {};
    jsonResponse.forEach((k, v) => championMap[k] = Champion.fromJson(v));
    return championMap;
  }

  static int _compareItem(item1, item2) {
    if (item1.type.compareTo(item2.type) != 0) {
      return item1.type.compareTo(item2.type);
    }
    return item1.key.compareTo(item2.key);
  }
}

enum StringType { champion, cls, origin }

enum SortType { cost, attackdamage, attackspeed, armor, magicresist, health }

class _ChampionSort {
  static int byCost(Champion c1, Champion c2) {
    if (c1.cost.compareTo(c2.cost) != 0) {
      return c1.cost.compareTo(c2.cost);
    }

    return c1.name.compareTo(c2.name);
  }

  static int byAttackDamage(Champion c1, Champion c2) {
    if (c1.stats.damage.compareTo(c2.stats.damage) != 0) {
      return c1.stats.damage.compareTo(c2.stats.damage);
    }

    return c1.name.compareTo(c2.name);
  }

  static int byAttackSpeed(Champion c1, Champion c2) {
    if (c1.stats.attackSpeed.compareTo(c2.stats.attackSpeed) != 0) {
      return c1.stats.attackSpeed.compareTo(c2.stats.attackSpeed);
    }

    return c1.name.compareTo(c2.name);
  }

  static int byArmor(Champion c1, Champion c2) {
    if (c1.stats.armor.compareTo(c2.stats.armor) != 0) {
      return c1.stats.armor.compareTo(c2.stats.armor);
    }

    return c1.name.compareTo(c2.name);
  }

  static int byMagicResist(Champion c1, Champion c2) {
    if (c1.stats.magicResist.compareTo(c2.stats.magicResist) != 0) {
      return c1.stats.magicResist.compareTo(c2.stats.magicResist);
    }

    return c1.name.compareTo(c2.name);
  }

  static int byHealth(Champion c1, Champion c2) {
    if (c1.stats.health.compareTo(c2.stats.health) != 0) {
      return c1.stats.health.compareTo(c2.stats.health);
    }

    return c1.name.compareTo(c2.name);
  }
}
