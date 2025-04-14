import 'dart:math';
import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<Map<String, dynamic>> sales = [];
  List<Map<String, dynamic>> _filteredSales = [];
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedTransactioner;
  List<String> _transactioners = [];

  @override
  void initState() {
    super.initState();
    final random = Random();
    List<String> transactioners = ['John Doe', 'Jane Smith', 'Peter Jones'];
    _transactioners = transactioners;
    sales = [
      {
        'saleId': '1',
        'dateTime': DateTime.now().subtract(const Duration(hours: 1)),
        'items': [
          {'name': 'Espresso', 'quantity': 2, 'subtotal': 140},
          {'name': 'Pastry', 'quantity': 1, 'subtotal': 40},
        ],
        'total': 180,
        'transactioner': transactioners[random.nextInt(transactioners.length)],
      },
      {
        'saleId': '2',
        'dateTime': DateTime.now().subtract(const Duration(hours: 3)),
        'items': [
          {'name': 'Latte', 'quantity': 1, 'subtotal': 80},
          {'name': 'Sandwich', 'quantity': 1, 'subtotal': 45},
        ],
        'total': 125,
        'transactioner': transactioners[random.nextInt(transactioners.length)],
      },
      {
        'saleId': '3',
        'dateTime': DateTime.now().subtract(const Duration(hours: 5)),
        'items': [
          {'name': 'Cappuccino', 'quantity': 3, 'subtotal': 240},
          {'name': 'Salad', 'quantity': 2, 'subtotal': 100},
        ],
        'total': 340,
        'transactioner': transactioners[random.nextInt(transactioners.length)],
      },
    ];
    _filteredSales = List.from(sales);
  }

  void _applyFilters() {
    setState(() {
      _filteredSales = sales.where((sale) {
        final saleDate = (sale['dateTime'] as DateTime);
        bool dateMatch = true;
        bool transactionerMatch = true;

        // Date filter
        if (_startDate != null && _endDate != null) {
          dateMatch = saleDate.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
              saleDate.isBefore(_endDate!.add(const Duration(days: 1)));
        }

        // Transactioner filter
        if (_selectedTransactioner != null) {
          transactionerMatch = sale['transactioner'] == _selectedTransactioner;
        }

        return dateMatch && transactionerMatch;
      }).toList();
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        backgroundColor: Colors.brown,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectDateRange(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Filter by Date'),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedTransactioner,
                  hint: const Text('Select Transactioner'),
                  items: _transactioners.map((String transactioner) {
                    return DropdownMenuItem<String>(
                      value: transactioner,
                      child: Text(transactioner),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTransactioner = newValue;
                      _applyFilters();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSales.length,
              itemBuilder: (context, index) {
                final sale = _filteredSales[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sale ID: ${sale['saleId']}'),
                        Text('Date: ${sale['dateTime'].toString()}'),
                        Text('Transactioner: ${sale['transactioner']}'),
                        const Text('Items:'),
                        ...sale['items'].map<Widget>((item) => Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            '- ${item['name']} x${item['quantity']} (₱${item['subtotal']})',
                          ),
                        )),
                        Text('Total: ₱${sale['total']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
