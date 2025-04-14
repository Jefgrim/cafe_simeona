import 'dart:math';

import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});


  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<Map<String, dynamic>> sales = [];

  @override
  void initState() {
    super.initState();
    final random = Random();
    const transactioners = ['Jefgrim', 'David', 'Angel'];
    // Dummy data for sales
    sales = [
      {
        'saleId': '1',
        'dateTime': DateTime.now().subtract(const Duration(minutes: 30)),
        'items': [
          {'name': 'Latte', 'quantity': 2, 'subtotal': 160},
          {'name': 'Pastry', 'quantity': 1, 'subtotal': 40},
        ],
        'total': 200.0,
        'transactioner': transactioners[random.nextInt(transactioners.length)],
      },
      {
        'saleId': '2',
        'dateTime': DateTime.now().subtract(const Duration(hours: 2)),
        'items': [
          {'name': 'Espresso', 'quantity': 1, 'subtotal': 70},
          {'name': 'Sandwich', 'quantity': 1, 'subtotal': 45},
        ],
        'total': 115,
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
    _filteredSales = List.from(sales); // Initialize filtered sales with all sales
    _sortSalesByDateTime();

  }

  String? selectedTransactioner;

  List<Map<String, dynamic>> get filteredSales {
    if (selectedTransactioner == null) {
      return sales;
    } else {
      return sales
          .where((sale) => sale['transactioner'] == selectedTransactioner)
          .toList();
    }
  }

  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, dynamic>> _filteredSales = []; // Initially all sales are displayed

  // Method to sort sales by dateTime
  void _sortSalesByDateTime() {
    _filteredSales.sort((a, b) => (b['dateTime'] as DateTime).compareTo(a['dateTime'] as DateTime));
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
        _filterSalesByDate();
      });
    }
  }

  void _filterSalesByDate() {
    if (_startDate == null || _endDate == null) {
      _filteredSales = List.from(sales);
    } else {
      _filteredSales = sales.where((sale) {
        final saleDate = (sale['dateTime'] as DateTime);
        return saleDate.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
            saleDate.isBefore(_endDate!.add(const Duration(days: 1)));
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> transactioners =
        sales.map((sale) => sale['transactioner'] as String).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Page'),
        backgroundColor: Colors.brown,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (String value) {
              setState(() {
                selectedTransactioner = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return transactioners
                  .map<PopupMenuItem<String>>((String value) =>
                      PopupMenuItem<String>(value: value, child: Text(value)))
                  .toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Filtering (Placeholder)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(_startDate != null && _endDate != null
                    ? 'Selected Range: ${_startDate!.toLocal().toString().split(' ')[0]} - ${_endDate!.toLocal().toString().split(' ')[0]}'
                    : 'No date range selected'),
                const SizedBox(width: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white
                    ),
                    onPressed: () => _selectDateRange(context),
                    child: const Text('Select Date Range')
                )

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white
                    ),
                    onPressed: () {
                      setState(() {_filteredSales = sales; _sortSalesByDateTime();});
                    },
                    child: const Text('Show All')
                )
              ],
            ),
          ),
          Expanded(
            child: filteredSales.isEmpty
                ? const Center(child: Text('No sales records found.'))
                : ListView.builder(
                    itemCount: _filteredSales.length,
                    itemBuilder: (context, index) {
                      final sale = _filteredSales[index];
                      return Card(
                  margin: const EdgeInsets.all(10),
                  color: Colors.brown[50],
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sale ID: ${sale['saleId']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Transacted by: ${sale['transactioner']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Date & Time: ${sale['dateTime'].toString()}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Items Sold:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          children:
                              (sale['items'] as List)
                                  .map(
                                    (item) => ListTile(
                                      title: Text(
                                        '${item['name']} x ${item['quantity']}',
                                      ),
                                      trailing: Text(
                                        '₱${item['subtotal'].toStringAsFixed(2)}',
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₱${sale['total'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
