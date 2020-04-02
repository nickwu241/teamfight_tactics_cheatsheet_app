import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../data.dart';
import '../items_bloc.dart';
import '../models/item.dart';
import '../utils.dart';
import 'ui_helper.dart';

class ItemsTabView extends StatefulWidget {
  _ItemsTabViewState createState() => _ItemsTabViewState();
}

class _ItemsTabViewState extends State<ItemsTabView> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_deselectAll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _deselectAll() {
    _selectItem('');
  }

  void _selectItem(String itemKey) {
    Provider.of<ItemsBloc>(context).selectItem(itemKey);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: Provider.of<ItemsBloc>(context).selectItemStream,
      builder: (context, snapshot) {
        return CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  UIHelper.titleText('Base Items'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: Data.baseItems
                        .take(5)
                        .map((item) => ItemGridTile(
                              item,
                              borderColor: Colors.grey,
                              isActive: snapshot.data == item.key,
                              onTap: () => _selectItem(item.key),
                            ))
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: Data.baseItems
                        .skip(5)
                        .map((item) => ItemGridTile(
                              item,
                              borderColor: Colors.grey,
                              isActive: snapshot.data == item.key,
                              onTap: () => _selectItem(item.key),
                            ))
                        .toList(),
                  ),
                  UIHelper.titleText('Combined Items'),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: Data.combinedItems.map((item) {
                      return ItemGridTile(
                        item,
                        borderColor: Colors.amber[300],
                        isActive: false,
                        onTap: () => _selectItem(item.key),
                        selectItemStream:
                            Provider.of<ItemsBloc>(context).selectItemStream,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ItemRecipeBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      initialData: '',
      stream: Provider.of<ItemsBloc>(context).selectItemStream,
      builder: (context, snapshot) {
        final selectedItemKey = snapshot.data;
        if (selectedItemKey.isEmpty || Data.items[selectedItemKey].depth != 1) {
          return Container(width: 0, height: 0);
        }
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.grey),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12.0),
                  topRight: const Radius.circular(12.0),
                ),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: Provider.of<ItemsBloc>(context).deselectAll,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ItemDescriptionBar(Data.items[selectedItemKey]),
                      ...Data.items[selectedItemKey].buildsInto.map((itemKey) {
                        return CombinedItemBar(
                          Data.items[itemKey],
                          firstItem: Data.items[selectedItemKey],
                          isDisplayingSmallT: itemKey ==
                              Data.items[selectedItemKey].buildsInto.first,
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ItemDescriptionBar extends StatelessWidget {
  final Item item;

  const ItemDescriptionBar(this.item);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
          child: ItemIcon(item),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(item.name, style: TextStyle(fontSize: 20.0)),
              Text(item.bonus),
            ],
          ),
        ),
      ],
    );
  }
}

class CombinedItemBar extends StatelessWidget {
  final Item combinedItem;
  final Item firstItem;
  final bool isDisplayingCombinedItem;
  final bool isDisplayingSmallT;

  CombinedItemBar(
    this.combinedItem, {
    this.firstItem,
    this.isDisplayingCombinedItem = true,
    this.isDisplayingSmallT = false,
  });

  @override
  Widget build(BuildContext context) {
    var requiredItems = List.of(combinedItem.buildsFrom);
    if (firstItem != null) {
      requiredItems.remove(firstItem.key);
    }

    final tHeight = isDisplayingSmallT ? 18.0 : 38.0;
    final requiredItem1 = Data.items[requiredItems[0]];
    final requiredItem2 =
        requiredItems.length >= 2 ? Data.items[requiredItems[1]] : null;

    // Disable tapping if it's the same as the selected item.
    final onTapRequiredItem1 = firstItem?.key == requiredItem1.key
        ? () {}
        : () => Provider.of<ItemsBloc>(context).selectItem(requiredItem1.key);

    return Row(
      children: <Widget>[
        CustomPaint(painter: TPainter(), size: Size(38.0, tHeight)),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: ItemIcon(
            requiredItem1,
            onTap: onTapRequiredItem1,
          ),
        ),
        if (requiredItem2 != null)
          ItemIcon(
            requiredItem2,
            onTap: () =>
                Provider.of<ItemsBloc>(context).selectItem(requiredItem2.key),
          ),
        if (isDisplayingCombinedItem) ...[
          Text('=', style: TextStyle(fontSize: 24.0)),
          Padding(
            padding: const EdgeInsets.fromLTRB(1.0, 1.0, 6.0, 1.0),
            child: ItemIcon(combinedItem),
          ),
          Flexible(
              child: Text(
            combinedItem.bonus,
            style: TextStyle(fontSize: 10.0),
          )),
        ],
      ],
    );
  }
}

class ItemGridTile extends StatelessWidget {
  final Item item;
  final Color borderColor;
  final bool isActive;
  final VoidCallback onTap;
  final Stream<String> selectItemStream;
  SuperTooltip _tooltip;

  ItemGridTile(
    this.item, {
    @required this.borderColor,
    @required this.onTap,
    this.isActive = false,
    this.selectItemStream,
  });

  void _onTapUp(BuildContext context, TapUpDetails details) {
    // Only show tooltip for combined items.
    if (item.depth == 1) {
      return;
    }

    // Close the tooltip if it was opened already.
    if (_tooltip != null && _tooltip.isOpen) {
      _tooltip.close();
      _tooltip = null;
      return;
    }

    // Create the tooltip and show it.
    _tooltip = SuperTooltip(
      borderColor: Colors.grey,
      // Show tooltip upwards unless at the top of the screen.
      popupDirection: details.globalPosition.dy >= 230
          ? TooltipDirection.up
          : TooltipDirection.down,
      showCloseButton: ShowCloseButton.inside,
      closeButtonSize: 24.0,
      // Propagate touch events outside of tooltip.
      touchThroughAreaShape: ClipAreaShape.rectangle,
      touchThrougArea: Rect.fromLTRB(
        0.0,
        0.0,
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      content: Material(
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ItemDescriptionBar(item),
              CombinedItemBar(
                item,
                isDisplayingCombinedItem: false,
                isDisplayingSmallT: true,
              ),
            ],
          ),
        ),
      ),
    );
    _tooltip.show(context);
  }

  @override
  Widget build(BuildContext context) {
    selectItemStream?.listen((itemKey) {
      if (_tooltip != null && _tooltip.isOpen && itemKey != item.key) {
        _tooltip.close();
        _tooltip = null;
      }
    });

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ItemIcon(
        item,
        onTap: onTap,
        onTapUp: (TapUpDetails details) => _onTapUp(context, details),
        width: 64.0,
        height: 64.0,
        isActive: isActive,
      ),
    );
  }
}

class ItemIcon extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;
  final void Function(TapUpDetails) onTapUp;
  final double width;
  final double height;
  final bool isActive;

  const ItemIcon(
    this.item, {
    this.onTap,
    this.onTapUp,
    this.width = 48.0,
    this.height = 48.0,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderColor =
        item.depth == 1 ? Colors.grey : Colors.amber[300];

    return Tooltip(
      message: '${item.name}\n${item.bonus}',
      child: GestureDetector(
        onTap: onTap,
        onTapUp: onTapUp,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(AssetPath.forItem(item.key)),
            ),
            border: Border.all(
              color: isActive ? Colors.red : defaultBorderColor,
              width: isActive ? 6.0 : 2.0,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
    );
  }
}

class TPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1.2;
    canvas.drawLine(
      Offset(size.width / 2, -size.height),
      Offset(size.width / 2, size.height / 2),
      paint,
    );
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
