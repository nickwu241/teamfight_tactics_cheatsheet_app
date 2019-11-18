import 'package:flutter/material.dart';

import '../models/champion.dart';
import '../services/analytics.dart';
import 'widgets/champion_modal.dart';

class UIHelper {
  static const _borderColorByCost = {
    1: Colors.grey,
    // 2: Color(0xFF158D53),
    2: Colors.green,
    3: Colors.blue,
    // 4: Color(0xFFAD199F),
    4: Colors.purple,
    5: Color(0xFFDAAA29),
    7: Colors.purpleAccent,
  };

  static Widget titleText(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 4.0, 4.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  static Color borderColorForCost(int cost) {
    return _borderColorByCost[cost];
  }

  static void showChampionModal(BuildContext context, Champion champion) {
    Analytics.logChampionModalEvent(champion.key, true);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(child: ChampionModal(champion));
      },
    ).then((_) => Analytics.logChampionModalEvent(champion.key, false));
  }
}
