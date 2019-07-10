import 'package:flutter/material.dart';

import '../../models/champion.dart';
import '../../utils.dart';
import '../ui_helper.dart';

class ChampionAvatarWidget extends StatelessWidget {
  final Champion champion;

  ChampionAvatarWidget(this.champion);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 2.0, 2.0),
      child: GestureDetector(
        onTap: () => UIHelper.showChampionModal(context, champion),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: UIHelper.borderColorForCost(champion.cost),
              width: 2.5,
            ),
          ),
          child: Image.asset(
            AssetPath.forChampion(champion.key),
            width: 40.0,
            height: 40.0,
          ),
        ),
      ),
    );
  }
}
