import 'stock_type.dart';

class StockItem {
  const StockItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.type,
  });

  final String id;
  final String name;
  final int quantity;
  final StockType type;
}
