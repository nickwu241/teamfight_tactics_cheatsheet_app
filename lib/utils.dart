import 'data.dart';

class AssetPath {
  static String forChampion(String championKey) {
    return 'assets/sprites/champions/$championKey.png';
  }

  static String forChampionSplash(String championKey) {
    return 'assets/splash/champions/$championKey.png';
  }

  static String forChampionAbility(String championKey) {
    return 'assets/sprites/abilities/$championKey.png';
  }

  static String forItem(String itemKey) {
    return 'assets/sprites/items/$itemKey.png';
  }

  static String forTrait(String trait) {
    final traitKey = trait.replaceAll(RegExp('[ -]'), '').toLowerCase();
    final ending = Data.isClass(traitKey)
        ? 'classes/$traitKey.png'
        : 'origins/$traitKey.png';
    return 'assets/sprites/$ending';
  }

  static String forPatch(String patch) {
    return 'assets/data/patches/$patch.md';
  }

  static String forImage(String imageName) {
    return 'assets/images/$imageName.png';
  }
}

class CaseIgnore {
  static bool startsWith(String str, String prefix) {
    return str.toLowerCase().startsWith(prefix.toLowerCase());
  }

  static bool equals(String s1, String s2) {
    return s1.toLowerCase() == s2.toLowerCase();
  }

  static bool listContains(List<String> list, String target) {
    return list.any((str) => CaseIgnore.equals(str, target));
  }
}
