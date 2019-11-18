import 'package:flutter/material.dart';

import '../data.dart';
import '../models/champion.dart';
import '../utils.dart';
import 'ui_helper.dart';
import 'widgets/champion_avatar_widget.dart';

class DropRatesTabView extends StatefulWidget {
  @override
  _DropRatesTabViewState createState() => _DropRatesTabViewState();
}

class _DropRatesTabViewState extends State<DropRatesTabView> {
  final _championsByCost = Data.getChampionsByCost();
  List<int> _filters = [1, 2, 3, 4, 5];

  Iterable<Widget> get filtersWidget sync* {
    for (int tier in [1, 2, 3, 4, 5]) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: ChoiceChip(
          label: Text('$tier', style: TextStyle(color: Colors.white)),
          selectedColor: UIHelper.borderColorForCost(tier),
          selected: _filters.contains(tier),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _filters.add(tier);
              } else {
                _filters.removeWhere((int filter) {
                  return filter == tier;
                });
              }
            });
          },
        ),
      );
    }
  }

  Widget _buildTierRow(int tier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
      child: Row(
        children: <Widget>[
          Text(
            'TIER $tier',
            style: TextStyle(
                color: UIHelper.borderColorForCost(tier),
                fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Wrap(
                children: _championsByCost[tier]
                    .followedBy(tier == 5 ? [Data.champions['Lux']] : [])
                    .map(_buildChampionAvatar)
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChampionAvatar(Champion champion) {
    return ChampionAvatarWidget(champion);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Image.asset(AssetPath.forImage('droprates')),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'TIERS: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: Wrap(
                  children: filtersWidget.toList(),
                ),
              ),
            ],
          ),
          if (_filters.contains(1)) _buildTierRow(1),
          if (_filters.contains(2)) _buildTierRow(2),
          if (_filters.contains(3)) _buildTierRow(3),
          if (_filters.contains(4)) _buildTierRow(4),
          if (_filters.contains(5)) _buildTierRow(5),
        ],
      ),
    );
  }
}
