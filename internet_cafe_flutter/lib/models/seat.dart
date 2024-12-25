class Seat {
  final String id;
  final String name;
  bool isOccupied;

  Seat({
    required this.id,
    required this.name,
    this.isOccupied = false,
  });
}