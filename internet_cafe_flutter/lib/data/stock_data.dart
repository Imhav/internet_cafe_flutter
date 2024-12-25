import '../models/stock_type.dart';
import '../models/stock_item.dart';

final inStockItems = [
  const StockItem(id: 'a', name: 'Lay', quantity: 1, type: StockType.snack),
  const StockItem(
      id: 'b', name: 'Coka Cola', quantity: 5, type: StockType.drink),
  const StockItem(
      id: 'c', name: 'Pork Rice', quantity: 1, type: StockType.food),
];
