import 'package:flutter/material.dart';

class DiningTablePage extends StatefulWidget {
  const DiningTablePage({super.key});

  @override
  State<DiningTablePage> createState() => _DiningTablePageState();
}

class _DiningTablePageState extends State<DiningTablePage> {
  List<Map<String, dynamic>> tables = [
    {'name': 'Table 1', 'capacity': 4, 'isAvailable': true},
    {'name': 'Table 2', 'capacity': 4, 'isAvailable': true},
    {'name': 'Table 3', 'capacity': 4, 'isAvailable': true},
    {'name': 'Table 4', 'capacity': 4, 'isAvailable': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dining Table Page'),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        itemCount: tables.length,
        itemBuilder: (context, index) {
          return TableCard(
            tableName: tables[index]['name'],
            capacity: tables[index]['capacity'],
            isAvailable: tables[index]['isAvailable'],
            onAvailabilityChanged: (value) {
              setState(() {
                tables[index]['isAvailable'] = value;
              });
            },
          );
        },
      ),
    );
  }
}

class TableCard extends StatelessWidget {
  final String tableName;
  final int capacity;
  final bool isAvailable;
  final ValueChanged<bool> onAvailabilityChanged;

  const TableCard({
    required this.tableName,
    required this.capacity,
    required this.isAvailable,
    required this.onAvailabilityChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tableName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Capacity: $capacity'),
              ],
            ),
            Switch(value: isAvailable, onChanged: onAvailabilityChanged),
          ],
        ),
      ),
    );
  }
}
