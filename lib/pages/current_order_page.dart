import 'package:flutter/material.dart';

class CurrentOrderPage extends StatelessWidget {
  final List<Map<String, dynamic>> currentOrder;
  final double total;
  final VoidCallback clearOrder;

  const CurrentOrderPage({
    Key? key,
    required this.currentOrder,
    required this.total,
    required this.clearOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Order Details'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total: ₱${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: currentOrder.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${currentOrder[index]['name']} x ${currentOrder[index]['quantity']}'),
                    trailing: Text(
                        '₱${(currentOrder[index]['price'] * currentOrder[index]['quantity']).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    clearOrder();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown, foregroundColor: Colors.white),
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement checkout logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Checkout successful! (Not really)')),
                    );
                    clearOrder();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown, foregroundColor: Colors.white),
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
