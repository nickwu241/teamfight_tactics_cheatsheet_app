import 'package:flutter/material.dart';

import '../../icons/stat_icons.dart';
import '../../models/champion.dart';

enum ChampionStat { attackkdamage, attackspeed, armor, magicresist, cost }

class ChampionStatChip extends StatelessWidget {
  final Champion champion;
  final ChampionStat stat;
  final double width;
  final bool noSizedBox;

  ChampionStatChip(
    this.champion,
    this.stat, {
    this.width = 50.0,
    this.noSizedBox = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children;
    switch (stat) {
      case ChampionStat.attackkdamage:
        children = [
          Icon(StatIcons.attackdamage, size: 14.0),
          Text(' ${champion.stats.damage.toString()}'),
        ];
        break;
      case ChampionStat.attackspeed:
        children = [
          Icon(StatIcons.attackspeed, size: 14.0),
          Text(' ${champion.stats.attackSpeed.toString()}'),
        ];
        break;
      case ChampionStat.armor:
        children = [
          Icon(StatIcons.armor, size: 14.0),
          Text(' ${champion.stats.armor.toString()}'),
        ];
        break;
      case ChampionStat.magicresist:
        children = [
          Icon(StatIcons.magicresist, size: 14.0),
          Text(' ${champion.stats.magicResist.toString()}'),
        ];
        break;
      case ChampionStat.cost:
        children = [
          Icon(StatIcons.gold, size: 14.0),
          Text(' ${champion.cost.toString()}'),
        ];
        break;
    }

    if (noSizedBox) {
      return Row(children: children);
    }

    return SizedBox(
      width: width,
      child: Row(children: children),
    );
  }
}
