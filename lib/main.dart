import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data.dart';
import 'items_bloc.dart';
import 'pages/champions_tab_view.dart';
import 'pages/drop_rates_tab_view.dart';
import 'pages/items_tab_view.dart';
import 'pages/patches_tab_view.dart';
import 'pages/traits_tab_view.dart';

void main() async {
  // Must be run before Data.initialize().
  WidgetsFlutterBinding.ensureInitialized();

  // Load our static data.
  await Data.initialize();

  // Pin to portrait mode.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<ItemsBloc>(
      builder: (context) => ItemsBloc(),
      child: MaterialApp(
        title: 'Teamfight Tactics Cheatsheet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Set Tab Bar color.
          primaryColor: Colors.black,
          // Set ExpansionTile active color.
          accentColor: Colors.black,
        ),
        // theme: ThemeData.dark(),
        home: MainApp(),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  static const initialTabIndex = 0;
  static const tabIndexToNameMap = {
    0: 'Items',
    1: 'Classes & Origins',
    2: 'Drop Rates',
    3: 'Champions',
    4: 'Patches',
  };

  final _tabs = <Tab>[
    Tab(child: const Text('Items')),
    Tab(child: const Text('Classes & Origins')),
    Tab(child: const Text('Drop Rates')),
    Tab(child: const Text('Champions')),
    Tab(child: const Text('Patches')),
  ];
  final _tabViews = <Widget>[
    ItemsTabView(),
    TraitsTabView(),
    DropRatesTabView(),
    ChampionsTabView(),
    PatchesTabView(),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: initialTabIndex,
      length: _tabs.length,
      vsync: this,
    );
    _tabController.animation.addListener(() {
      Provider.of<ItemsBloc>(context).deselectAll();
    });
    _tabController.addListener(() {
      Provider.of<ItemsBloc>(context).deselectAll();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Provider.of<ItemsBloc>(context).handleBackButton,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: TabBar(
              tabs: _tabs,
              controller: _tabController,
              isScrollable: true,
            ),
          ),
        ),
        body: TabBarView(controller: _tabController, children: _tabViews),
        bottomSheet: ItemRecipeBottomSheet(),
      ),
    );
  }
}
