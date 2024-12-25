import 'package:flutter/material.dart';
import '../data/stock_data.dart';
import '../models/stock_item.dart';
import '../widgets/new_item.dart';
import '../widgets/stock_list_tile.dart';
import '../data/mode.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stocklist(),
    );
  }
}

class Stocklist extends StatefulWidget {
  const Stocklist({super.key});

  @override
  State<Stocklist> createState() => _StocklistState();
}

class _StocklistState extends State<Stocklist> {
  Mode _mode = Mode.normal;
  final List<StockItem> selectedItem = [];
  List<StockItem>? _lastRemovedItems;
  List<int>? _lastRemovedIndices;

  // Add or edit a stock item
  void _newItem({StockItem? items, int? index}) async {
    final passedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewItem(
          mode: items == null ? Mode.input : Mode.edit,
          items: items,
        ),
      ),
    );

    if (passedData != null) {
      setState(() {
        if (index == null) {
          inStockItems.add(passedData);
        } else {
          inStockItems[index] = passedData;
        }
      });
    }
  }


  void _toggleSelectionMode() {
    setState(() {
      _mode = _mode == Mode.normal ? Mode.selection : Mode.normal;
      if (_mode == Mode.normal) {
        selectedItem.clear();
      }
    });
  }

  // Undo removal of selected items
  void _undoRemoval() {
    if (_lastRemovedItems != null && _lastRemovedIndices != null) {
      setState(() {
        for (int i = 0; i < _lastRemovedItems!.length; i++) {
          inStockItems.insert(_lastRemovedIndices![i], _lastRemovedItems![i]);
        }
      });
      _lastRemovedItems = null;
      _lastRemovedIndices = null;
    }
  }


  void _removeSelectedItem() {
    setState(() {
      _lastRemovedItems = [...selectedItem];
      _lastRemovedIndices =
          selectedItem.map((item) => inStockItems.indexOf(item)).toList();

      inStockItems.removeWhere((item) => selectedItem.contains(item));
      _toggleSelectionMode();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_lastRemovedItems!.length} item(s) removed'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: _undoRemoval,
          ),
        ),
      );
    });
  }

  // Toggle the selection of a stock item
  void _toggleSelection(StockItem items) {
    setState(() {
      if (selectedItem.contains(items)) {
        selectedItem.remove(items);
      } else {
        selectedItem.add(items);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Content to display when there are no items
    Widget content = const Center(child: Text('No items added yet.'));

    // Content to display when there are items in the list
    if (inStockItems.isNotEmpty) {
      content = ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = inStockItems.removeAt(oldIndex);
            inStockItems.insert(newIndex, item);
          });
        },
        children: [
          for (int i = 0; i < inStockItems.length; i++)
            StockListTile(
              key: ValueKey(inStockItems[i]),
              items: inStockItems[i],
              index: i,
              isSelected: selectedItem.contains(inStockItems[i]),
              mode: _mode,
              onLongPressed: _toggleSelectionMode,
              onTap: () {
                if (_mode == Mode.selection) {
                  _toggleSelection(inStockItems[i]);
                } else {
                  _newItem(items: inStockItems[i], index: i);
                }
              },
            )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_mode == Mode.normal
            ? 'Your Stock Items'
            : '${selectedItem.length} Items Selected'),
        actions: [
          if (_mode == Mode.selection)
            IconButton(
              onPressed: _removeSelectedItem,
              icon: const Icon(Icons.remove),
            ),
          if (_mode == Mode.normal)
            IconButton(
              onPressed: _newItem,
              icon: const Icon(Icons.add),
            ),
        ],
        leading: _mode == Mode.selection
            ? IconButton(
                onPressed: _toggleSelectionMode,
                icon: const Icon(Icons.arrow_back),
              )
            : null,
      ),
      body: content,
    );
  }
}
