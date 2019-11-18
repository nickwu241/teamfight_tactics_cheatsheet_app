import '../data.dart';
import '../utils.dart';

class AutoComplete {
  static List<String> withTraitPrefix(String prefix) {
    return _withTraitPrefixNoSort(prefix)..sort();
  }

  static List<String> _withTraitPrefixNoSort(String prefix) {
    return Data.classes.values
        .followedBy(Data.origins.values)
        .where((trait) => CaseIgnore.startsWith(trait.key, prefix))
        .map((trait) => trait.name)
        .toList();
  }

  static List<String> withChampionOrTraitPrefix(String prefix) {
    return Data.champions.values
        .where((champion) => CaseIgnore.startsWith(champion.key, prefix))
        .map((champion) => champion.key)
        .toList()
          ..addAll(_withTraitPrefixNoSort(prefix))
          ..sort();
  }
}
