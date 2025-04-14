import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> menuItems = [
    {'name': 'Espresso', 'price': 70},
    {'name': 'Latte', 'price': 80},
    {'name': 'Cappuccino', 'price': 80},
    {'name': 'Mocha', 'price': 85},
    {'name': 'Americano', 'price': 90},
    {'name': 'Iced Coffee', 'price': 80},
    {'name': 'Tea', 'price': 60},
    {'name': 'Pastry', 'price': 40},
    {'name': 'Sandwich', 'price': 45},
    {'name': 'Salad', 'price': 50},
  ];

  List<Map<String, dynamic>> currentOrder = [];
  double total = 0.0;
  bool isOrderExpanded = false;

  void addItemToOrder(Map<String, dynamic> item) {
    setState(() {
      int index = currentOrder.indexWhere((orderItem) => orderItem['name'] == item['name']);
      if (index != -1) {
        currentOrder[index]['quantity'] += 1;
      } else {
        currentOrder.add({'name': item['name'], 'quantity': 1, 'price': item['price']});
      }
      updateTotal();
    });
  }

  void removeItemFromOrder(Map<String, dynamic> item) {
    setState(() {
      int index = currentOrder.indexWhere((orderItem) => orderItem['name'] == item['name']);
      if (index != -1) {
        if (currentOrder[index]['quantity'] > 1) {
          currentOrder[index]['quantity'] -= 1;
        } else {
          currentOrder.removeAt(index);
        }
      }
      updateTotal();
    });
  }

  void clearOrder() {
    setState(() {
      currentOrder.clear();
      total = 0.0;
    });
  }

  void updateTotal() {
    total = currentOrder.fold(
        0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void toggleOrderVisibility() {
    setState(() {
      isOrderExpanded = !isOrderExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafe Simeona POS'),
        backgroundColor: Colors.brown,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.brown[100],
                  child: InkWell(
                    onTap: () => addItemToOrder(menuItems[index]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          menuItems[index]['name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('₱${menuItems[index]['price'].toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: toggleOrderVisibility,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isOrderExpanded ? MediaQuery.of(context).size.height - AppBar().preferredSize.height - kBottomNavigationBarHeight : 60,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Current Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Total: ₱${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  if (isOrderExpanded)
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentOrder.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                '${currentOrder[index]['name']} x ${currentOrder[index]['quantity']}'),
                            trailing: Text(
                                '₱${(currentOrder[index]['price'] * currentOrder[index]['quantity']).toStringAsFixed(2)}'),
                          );
                        },
                      ),
                    ),
                  if (isOrderExpanded)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: clearOrder,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown, foregroundColor: Colors.white),
                          child: const Text('Clear'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Implement checkout logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Checkout successful! (Not really)')),
                            );
                            clearOrder();
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
          ),
        ],
      ),
    );
  }
}
