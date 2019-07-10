import 'package:flutter/material.dart';

import '../data.dart';
import '../models/trait.dart';
import '../services/auto_complete.dart';
import '../utils.dart';
import 'ui_helper.dart';
import 'widgets/champion_avatar_widget.dart';
import 'widgets/search_bar.dart';

class TraitsTabView extends StatefulWidget {
  @override
  _TraitsTabViewState createState() => _TraitsTabViewState();
}

class _TraitsTabViewState extends State<TraitsTabView> {
  ScrollController _scrollController = ScrollController();
  Map<String, GlobalKey> keys = _createKeys();

  static Map<String, GlobalKey> _createKeys() {
    Map<String, GlobalKey> keys = {};
    Data.classes.values.followedBy(Data.origins.values).forEach((trait) {
      keys[trait.key] = GlobalKey();
    });
    return keys;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTrait(String traitKey) {
    if (keys.containsKey(traitKey)) {
      Scrollable.ensureVisible(
        keys[traitKey].currentContext,
        duration: Duration(milliseconds: 500),
      );
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchBar(
        hintText: 'by Class / Origin',
        suggestionsCallback: AutoComplete.withTraitPrefix,
        onCompleted: (String searchText) {
          _scrollToTrait(searchText.toLowerCase());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildSearchBar(),
        Padding(
          padding: const EdgeInsets.only(top: 64.0),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                UIHelper.titleText('Classes'),
                ...Data.classes.values
                    .map((c) => TraitWidget(c, key: keys[c.key]))
                    .toList(),
                UIHelper.titleText('Origins'),
                ...Data.origins.values
                    .map((o) => TraitWidget(o, key: keys[o.key]))
                    .toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TraitWidget extends StatelessWidget {
  final Trait trait;

  TraitWidget(this.trait, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey(this.trait.key),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Title Row.
          Row(
            children: <Widget>[
              // Trait Icon.
              CircleAvatar(
                // backgroundColor: traitColorMap[trait.key] ?? Colors.black,
                backgroundColor: Colors.black,
                radius: 16.0,
                child: Image.asset(
                  AssetPath.forTrait(trait.key),
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              // Trait Title.
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  trait.name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trait.key != 'ninja')
                ...trait.bonuses
                    .map((bonus) => Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: NumberChip(bonus.needed)))
                    .toList()
              // Be explicit about needing exactly 1 or 4 ninjas.
              else ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: NumberChip(trait.bonuses[0].needed),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text('or'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: NumberChip(trait.bonuses[1].needed),
                ),
              ]
            ],
          ),
          Container(height: 2.0),
          // Champions Row.
          Wrap(
            children: Data.traitToChampionsMap[trait.name]
                .map((champion) => ChampionAvatarWidget(champion))
                .toList(),
          ),
          Container(height: 8.0),
        ],
      ),
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (trait.description != null) Text(trait.description),
                ...trait.bonuses.map((bonus) {
                  return Row(
                    children: <Widget>[
                      NumberChip(bonus.needed),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(bonus.effect),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                Container(height: 8.0),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class NumberChip extends StatelessWidget {
  final int number;
  final Color color;

  NumberChip(
    this.number, {
    // Default is Colors.grey[700]
    this.color = const Color(0xFF616161),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(number.toString(),
          style: TextStyle(fontSize: 14.0, color: Colors.white)),
    );
  }
}
