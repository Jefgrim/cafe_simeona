import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> pickupOrders = [];
  List<Map<String, dynamic>> tableReservations = [];

  @override
  void initState() {
    super.initState();
    // Dummy data for pick-up orders
    pickupOrders = [
      {
        'orderId': 'PO1',
        'customerName': 'Alice',
        'items': [
          {'name': 'Latte', 'quantity': 1},
          {'name': 'Pastry', 'quantity': 2},
        ],
        'orderTime': DateTime.now().subtract(const Duration(minutes: 15)),
      },
      {
        'orderId': 'PO2',
        'customerName': 'Bob',
        'items': [
          {'name': 'Espresso', 'quantity': 2},
          {'name': 'Sandwich', 'quantity': 1},
        ],
        'orderTime': DateTime.now().subtract(const Duration(minutes: 30)),
      },
    ];

    // Dummy data for table reservations
    tableReservations = [
      {
        'reservationId': 'TR1',
        'customerName': 'Charlie',
        'tableNumber': 5,
        'reservationTime': DateTime.now().add(const Duration(hours: 1)),
      },
      {
        'reservationId': 'TR2',
        'customerName': 'David',
        'tableNumber': 3,
        'reservationTime': DateTime.now().add(const Duration(hours: 2)),
      },
    ];
  }

  void acceptPickupOrder(String orderId) {
    setState(() {
      pickupOrders.removeWhere((order) => order['orderId'] == orderId);
    });
    // Optionally, you can add logic to handle the accepted order, e.g., sending a notification.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Pick-up Order $orderId Accepted!')));
  }

  void acceptTableReservation(String reservationId) {
    setState(() {
      tableReservations.removeWhere(
        (reservation) => reservation['reservationId'] == reservationId,
      );
    });
    // Optionally, you can add logic to handle the accepted reservation.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Table Reservation $reservationId Accepted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders & Reservations'),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pick-up Orders Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Pick-up Orders',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 250, // Adjust the height as needed
              child: ListView.builder(
                itemCount: pickupOrders.length,
                itemBuilder: (context, index) {
                  final order = pickupOrders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: Colors.brown[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID: ${order['orderId']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Customer: ${order['customerName']}'),
                          const SizedBox(height: 8),
                          ...((order['items'] as List).map(
                            (item) =>
                                Text('${item['name']} x ${item['quantity']}'),
                          )),
                          const SizedBox(height: 8),
                          Text('Order Time: ${order['orderTime'].toString()}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white
                            ),
                            onPressed:
                                () => acceptPickupOrder(order['orderId']),
                            child: const Text('Ready for Pick-up'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Table Reservations Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Table Reservations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 250, // Adjust the height as needed
              child: ListView.builder(
                itemCount: tableReservations.length,
                itemBuilder: (context, index) {
                  final reservation = tableReservations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: Colors.brown[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reservation ID: ${reservation['reservationId']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Customer: ${reservation['customerName']}'),
                          const SizedBox(height: 8),
                          Text('Table Number: ${reservation['tableNumber']}'),
                          const SizedBox(height: 8),
                          Text(
                            'Reservation Time: ${reservation['reservationTime'].toString()}',
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                            ),
                            onPressed:
                                () => acceptTableReservation(
                                  reservation['reservationId'],
                                ),
                            child: const Text('Accept'),
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
      ),
    );
  }
}
