import 'package:flutter/material.dart';

import '../data.dart';
import '../models/champion.dart';
import '../services/auto_complete.dart';
import '../utils.dart';
import 'ui_helper.dart';
import 'widgets/champion_avatar_widget.dart';
import 'widgets/champion_stat_chip.dart';
import 'widgets/search_bar.dart';

class ChampionsTabView extends StatefulWidget {
  @override
  _ChampionsTabViewState createState() => _ChampionsTabViewState();
}

class _ChampionsTabViewState extends State<ChampionsTabView> {
  List<Champion> _champions = Data.getChampionList();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            hintText: 'by Champion / Class / Origin',
            suggestionsCallback: AutoComplete.withChampionOrTraitPrefix,
            onCompleted: (String searchText) {
              setState(() {
                _champions = Data.getChampionList(keyword: searchText);
              });
            },
            onClear: () {
              setState(() {
                _champions = Data.getChampionList();
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 64.0),
          child: ListView.separated(
            itemCount: _champions.length,
            separatorBuilder: (context, i) => Divider(),
            itemBuilder: (context, i) {
              return ChampionListTile(_champions[i]);
            },
          ),
        ),
      ],
    );
  }
}

class ChampionListTile extends StatelessWidget {
  final Champion champion;

  ChampionListTile(this.champion);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => UIHelper.showChampionModal(context, champion),
      leading: ChampionAvatarWidget(champion),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              champion.name,
              style: TextStyle(
                color: UIHelper.borderColorForCost(champion.cost),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 70.0,
                child: Row(
                  children: champion.origins
                      .followedBy(champion.classes)
                      .map((trait) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[700],
                        radius: 10.0,
                        child: Image.asset(
                          AssetPath.forTrait(trait.toLowerCase()),
                          color: Colors.white,
                          width: 16.0,
                          height: 16.0,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Spacer(),
              ChampionStatChip(champion, ChampionStat.attackkdamage),
              Spacer(),
              ChampionStatChip(champion, ChampionStat.attackspeed, width: 60.0),
              Spacer(),
              ChampionStatChip(champion, ChampionStat.armor),
              Spacer(),
              ChampionStatChip(champion, ChampionStat.magicresist),
            ],
          ),
        ],
      ),
    );
  }
}
