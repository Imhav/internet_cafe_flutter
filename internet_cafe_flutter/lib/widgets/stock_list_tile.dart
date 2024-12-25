import 'package:flutter/material.dart';
import '../models/stock_item.dart';
import '../data/mode.dart';



class StockListTile extends StatelessWidget {
  final StockItem items;
  final int index;
  final bool isSelected;
  final Mode mode;
  final VoidCallback onTap;
  final VoidCallback onLongPressed;

  const StockListTile({
    super.key,
    required this.items,
    required this.index,
    required this.isSelected,
    required this.mode,
    required this.onTap,
    required this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        key: ValueKey(items),
        leading: mode == Mode.selection
            ? Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  onTap();
                },
              )
            : Icon(items.type.icon),
        title: Text(items.name),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text("${items.quantity}"),
        ),
        onTap: onTap,
        onLongPress: onLongPressed,
      ),
    );
  }
}
