import 'package:flutter/material.dart';

import '../../models/champion.dart';
import '../../utils.dart';
import '../ui_helper.dart';
import 'champion_stat_chip.dart';

class ChampionModal extends StatelessWidget {
  final Champion champion;

  ChampionModal(this.champion);

  Stack _buildSplashStack(bool championHasMana, double cardWidth) {
    return Stack(
      children: <Widget>[
        Image.asset(
          AssetPath.forChampionSplash(champion.key),
        ),
        // Top Left Corner.
        Positioned(
          top: 4.0,
          left: 8.0,
          child: Text(
            champion.key,
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          ),
        ),
        // Top Right Corner.
        Positioned(
          top: 4.0,
          right: 8.0,
          child: ChampionStatChip(
            champion,
            ChampionStat.cost,
            noSizedBox: true,
          ),
        ),
        // Bottom Full Width.
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _buildTraitsColumn(),
                  Spacer(),
                  _buildStatsColumn(),
                ],
              ),
              // Health Bar.
              Container(
                height: 16.0,
                color: Colors.green,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Text(champion.stats.health.toString()),
                  ),
                ),
              ),
              // Mana Bar.
              if (championHasMana)
                Stack(
                  children: <Widget>[
                    Container(
                      height: 16.0,
                      color: Colors.blue[900],
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Text(
                              '${champion.ability.manaStart} / ${champion.ability.manaCost}'),
                        ),
                      ),
                    ),
                    Container(
                      height: 16.0,
                      color: Colors.blue,
                      width: cardWidth *
                          (champion.ability.manaStart /
                              champion.ability.manaCost),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildTraitsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: champion.origins
          .followedBy(champion.classes)
          .map((trait) => Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 2.0),
                child: Row(
                  children: <Widget>[
                    Image.asset(AssetPath.forTrait(trait.toLowerCase())),
                    Text(' $trait'),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Column _buildStatsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: <Widget>[
              ChampionStatChip(champion, ChampionStat.attackkdamage),
              ChampionStatChip(champion, ChampionStat.attackspeed),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: <Widget>[
              ChampionStatChip(champion, ChampionStat.armor),
              ChampionStatChip(champion, ChampionStat.magicresist),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: SizedBox(
            width: 100.0,
            child: Text('Range: ${champion.stats.range}'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.8;
    final bool championHasMana = champion.ability.manaCost != null;

    return Theme(
      data: ThemeData.dark().copyWith(
        cardTheme: CardTheme.of(context).copyWith(
          color: Colors.grey[850],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: UIHelper.borderColorForCost(champion.cost), width: 2.0),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildSplashStack(championHasMana, cardWidth),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white54,
                            ),
                          ),
                          child: Image.asset(
                            AssetPath.forChampionAbility(champion.key),
                            width: 32.0,
                            height: 32.0,
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text.rich(TextSpan(
                              children: [
                                TextSpan(
                                  text: '${champion.ability.name} ',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                TextSpan(text: '(${champion.ability.type})'),
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                    Container(height: 4.0),
                    Text(champion.ability.description),
                    Container(height: 12.0),
                    ...champion.ability.stats.map((stat) {
                      return Text.rich(TextSpan(
                        children: [
                          TextSpan(
                            text: '${stat.type}: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: stat.value),
                        ],
                      ));
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
