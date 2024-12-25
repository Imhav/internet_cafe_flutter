import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../data/seat_data.dart';
enum Mode { normal, selection }

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  Mode _mode = Mode.normal;
  final List<Seat> selectedSeats = [];
  final TextEditingController _seatController = TextEditingController();

  List<Seat> get unselectedSeats =>
      dummySeats.where((seat) => !seat.isOccupied).toList();

  List<Seat> get filteredSeats {
    if (_filter == 'occupied') {
      return dummySeats.where((seat) => seat.isOccupied).toList();
    } else if (_filter == 'available') {
      return unselectedSeats;
    }
    return dummySeats;
  }

  String _filter = '';

  void _toggleSeatOccupancy(Seat seat) {
    setState(() {
      seat.isOccupied = !seat.isOccupied;
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _mode = _mode == Mode.normal ? Mode.selection : Mode.normal;
      if (_mode == Mode.normal) {
        selectedSeats.clear();
      }
    });
  }

  void _removeSelectedSeats() {
    setState(() {
      dummySeats.removeWhere((seat) => selectedSeats.contains(seat));
      _toggleSelectionMode();
    });
  }

  void updateSeatSelection(int seatIndex) {
    final seat = dummySeats[seatIndex];

    if (_mode == Mode.selection) {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        selectedSeats.add(seat);
      }
    } else {
      _toggleSeatOccupancy(seat);
    }
  }

  void toggleFilter(String filter) {
    setState(() {
      _filter = filter;
    });
  }

  void updateTotalSeats(String value) {
    final int newSeatCount = int.tryParse(value) ?? 0;
    if (newSeatCount > dummySeats.length) {
      for (int i = dummySeats.length; i < newSeatCount; i++) {
        dummySeats.add(Seat(id: 's${i + 1}', name: 'Seat ${i + 1}'));
      }
    } else if (newSeatCount < dummySeats.length) {
      dummySeats.removeRange(newSeatCount, dummySeats.length);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _seatController.text = dummySeats.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mode == Mode.normal
            ? 'Seats Selection'
            : '${dummySeats.length - unselectedSeats.length} Seats Selected'),
        actions: [
          if (_mode == Mode.selection)
            IconButton(
                onPressed: _removeSelectedSeats,
                icon: const Icon(Icons.remove)),
          if (_mode == Mode.normal)
            IconButton(
              onPressed: _toggleSelectionMode,
              icon: const Icon(Icons.select_all),
            ),
        ],
        leading: _mode == Mode.selection
            ? IconButton(
                onPressed: _toggleSelectionMode,
                icon: const Icon(Icons.arrow_back))
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Total Seats:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _seatController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Enter total seats",
                          ),
                          onChanged: updateTotalSeats,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GridItem(
                        gridColor: Colors.black,
                        label: "Occupied Seats",
                        icon: Icons.sensor_occupied,
                        amount: (dummySeats.length - unselectedSeats.length)
                            .toString(),
                        iconColor: Colors.red,
                        onTap: () => toggleFilter("occupied"),
                      ),
                      GridItem(
                        gridColor: Colors.black,
                        label: "Available Seats",
                        icon: Icons.event_available,
                        amount: unselectedSeats.length.toString(),
                        iconColor: Colors.greenAccent,
                        onTap: () => toggleFilter("available"),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredSeats.length,
                itemBuilder: (context, index) {
                  final seatIndex = dummySeats.indexOf(filteredSeats[index]);
                  return GestureDetector(
                    onTap: () => updateSeatSelection(seatIndex),
                    child: Container(
                      decoration: BoxDecoration(
                        color: filteredSeats[index].isOccupied
                            ? Colors.green
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          filteredSeats[index].name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final Color gridColor;
  final String label;
  final IconData icon;
  final String amount;
  final Color iconColor;
  final Function onTap;

  const GridItem({
    super.key,
    required this.gridColor,
    required this.label,
    required this.icon,
    required this.amount,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: gridColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
