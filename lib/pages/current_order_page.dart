import 'package:flutter/material.dart';

class CurrentOrderPage extends StatefulWidget {
  final List<Map<String, dynamic>> currentOrder;
  final double total;
  final VoidCallback clearOrder;

  const CurrentOrderPage({
    super.key,
    required this.currentOrder,
    required this.total,
    required this.clearOrder,
  });

  @override
  State<CurrentOrderPage> createState() => _CurrentOrderPageState();
}

class _CurrentOrderPageState extends State<CurrentOrderPage> {
  late final List<Map<String, dynamic>> _currentOrder;
  late double _total;

  @override
  void initState() {
    super.initState();
    _currentOrder = List.from(widget.currentOrder);
    _total = widget.total;
  }

  void _updateTotal() {
    setState(() {
      _total = _currentOrder.fold(
        0.0,
        (sum, item) => sum + (item['price'] * item['quantity']),
      );
      widget.currentOrder.clear();
      widget.currentOrder.addAll(_currentOrder);
      // Remove items with quantity 0
      widget.currentOrder.removeWhere((item) => item['quantity'] == 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Order Details'),
        backgroundColor: Colors.brown,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: ₱${_total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _currentOrder.length,
                itemBuilder: (context, index) {
                  final item = _currentOrder[index];
                  return ListTile(
                    title: Row(
                      children: [Text('${item['name']} x ${item['quantity']}')],
                    ),
                    trailing: Text(
                      '₱${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                    ),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (item['quantity'] > 1) {
                                item['quantity']--;
                                _updateTotal();
                              } else if (item['quantity'] == 1) {
                                _currentOrder.removeAt(index);
                                _updateTotal();
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              item['quantity']++;
                              _updateTotal();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _createButton('Clear', () {
                  widget.clearOrder();
                  Navigator.pop(context);
                }),
                _createButton('Checkout', () {
                  showCheckoutDialog(context);
                }),
                _createButton('Back', () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _createButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      child: Text(text),
    );
  }

  void showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Checkout"),
          content: const Text(
            "This would ideally process the order and payment.",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                widget.clearOrder();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

