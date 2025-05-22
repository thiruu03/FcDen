import 'package:fcden/providers/alert_provider.dart';
import 'package:fcden/providers/checkbox_alert.dart';
import 'package:fcden/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

AlertProvider alertProvider = AlertProvider();

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.fetchInitialData(context);
      Future.delayed(Duration.zero, () {
        Provider.of<OrderProvider>(context, listen: false).initialize(context);
      });
    });
  }

  //Decides to display the ui or error screen
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      body: _buildBody(context, orderProvider),
    );
  }

  //Error handling part
  Widget _buildBody(BuildContext context, OrderProvider orderProvider) {
    if (orderProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orderProvider.isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load data'),
            ElevatedButton(
              onPressed: () async {
                orderProvider.fetchInitialData(context);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => orderProvider.ordersHistory(context),
      child: _buildMainContent(context, orderProvider),
    );
  }

  //main ui part
  Widget _buildMainContent(BuildContext context, OrderProvider orderProvider) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/pattern.png',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await orderProvider.ordersHistory(context);
            },
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/pattern.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Hero(
                      tag: 'redd',
                      child: Material(
                        type: MaterialType.transparency,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          padding: const EdgeInsets.all(14),
                          width: MediaQuery.of(context).size.width * 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: DataTable(
                                border: TableBorder.all(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        Theme.of(context).colorScheme.primary),
                                headingRowHeight: 100,
                                dataRowHeight: 90,
                                dataTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                columns: [
                                  DataColumn(
                                    headingRowAlignment:
                                        MainAxisAlignment.center,
                                    label: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Colors.white,
                                          child: Image.asset(
                                            'assets/images/logo-modified.png',
                                            height: 60,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        const Text(
                                          "Token number",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment:
                                        MainAxisAlignment.center,
                                    label: const Text(
                                      "Date",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment:
                                        MainAxisAlignment.center,
                                    label: const Text(
                                      "Type",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment:
                                        MainAxisAlignment.center,
                                    label: const Text(
                                      "Status",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment:
                                        MainAxisAlignment.center,
                                    label: const Text(
                                      "View",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    headingRowAlignment:
                                        MainAxisAlignment.center,
                                    label: const Text(
                                      "Action",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: List.generate(
                                    orderProvider.selectedOrder.length,
                                    (index) {
                                  final order =
                                      orderProvider.selectedOrder[index];
                                  return buildRow(context, order, index);
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (orderProvider.isOrderVisible)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: AnimatedContainer(
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 300),
                            width: orderProvider.isFullScreen
                                ? MediaQuery.of(context).size.width * 0.97
                                : 800,
                            height: orderProvider.isFullScreen
                                ? MediaQuery.of(context).size.height * 0.92
                                : 400,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(24)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order ID : ${orderProvider.allOrders.isNotEmpty ? orderProvider.allOrders[0]['orderId'] ?? '---' : '---'}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                          fontSize: orderProvider.isFullScreen
                                              ? 22
                                              : 25,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.open_in_full,
                                                color: Colors.white),
                                            onPressed: () {
                                              orderProvider.toggleFullScreen();
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close,
                                                color: Colors.white),
                                            onPressed: () {
                                              orderProvider
                                                  .toggleOrderVisibility(
                                                      false, 0);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 10),
                                  child: Text(
                                    "Order Type : ${orderProvider.allOrders.isNotEmpty ? orderProvider.allOrders[0]['orderTypeName'] ?? 'Unknown' : 'Unknown'}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          orderProvider.isFullScreen ? 21 : 22,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 35, vertical: 20),
                                      child: DataTable(
                                        border: TableBorder.all(
                                            color: Colors.black),
                                        columnSpacing:
                                            orderProvider.isFullScreen
                                                ? 40
                                                : 20,
                                        headingRowHeight:
                                            orderProvider.isFullScreen
                                                ? 50
                                                : 36,
                                        dataRowHeight:
                                            orderProvider.isFullScreen
                                                ? 130
                                                : 120,
                                        columns: [
                                          DataColumn(
                                            label: Text("Image",
                                                style: TextStyle(
                                                    fontSize: orderProvider
                                                            .isFullScreen
                                                        ? 21
                                                        : 22,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          DataColumn(
                                            label: Text("Name",
                                                style: TextStyle(
                                                    fontSize: orderProvider
                                                            .isFullScreen
                                                        ? 21
                                                        : 22,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          DataColumn(
                                            label: Text("Quantity",
                                                style: TextStyle(
                                                    fontSize: orderProvider
                                                            .isFullScreen
                                                        ? 21
                                                        : 22,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ],
                                        rows: List.generate(
                                            orderProvider.allOrders.length,
                                            (index) {
                                          final item =
                                              orderProvider.allOrders[index];
                                          final checkboxAlert =
                                              Provider.of<CheckboxAlert>(
                                                  context);

                                          return DataRow(cells: [
                                            DataCell(
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: item['isServed'] ??
                                                        false,
                                                    onChanged: (value) async {
                                                      // Call API
                                                      await checkboxAlert
                                                          .checkboxAlert(
                                                        item['orderDetailId'] ??
                                                            '',
                                                        context,
                                                        value ?? true,
                                                      );

                                                      // Update UI state
                                                      setState(() {
                                                        item['isServed'] =
                                                            value; // ✅ Update the local data
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Image.network(
                                                    orderProvider.selectedOrder[
                                                                    0]
                                                                ['imageName'] !=
                                                            null
                                                        ? 'https://www.fcdens.ndapp.in/fcdenapi/images/${orderProvider.selectedOrder[0]['imageName']}'
                                                        : 'https://www.fcdens.ndapp.in/fcdenapi/images/default.jpg',
                                                    width: orderProvider
                                                            .isFullScreen
                                                        ? 130
                                                        : 80,
                                                    height: orderProvider
                                                            .isFullScreen
                                                        ? 130
                                                        : 80,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Icon(
                                                          Icons.broken_image,
                                                          size: orderProvider
                                                                  .isFullScreen
                                                              ? 130
                                                              : 80);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(item['name'] ?? '',
                                                    style: TextStyle(
                                                        fontSize: orderProvider
                                                                .isFullScreen
                                                            ? 21
                                                            : 22)),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(
                                                    item['foodCount']
                                                            ?.toString() ??
                                                        '',
                                                    style: TextStyle(
                                                        fontSize: orderProvider
                                                                .isFullScreen
                                                            ? 21
                                                            : 22)),
                                              ),
                                            ),
                                          ]);
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // orderProvider.showLocalNotification(
              //     title: "Order Update", body: "A new order has been placed");
              orderProvider.checkForNewOrders(context);
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  DataRow buildRow(
      BuildContext context, Map<String, dynamic> order, int index) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(order['tokenNumber'] ?? '#----',
                    style: const TextStyle(fontSize: 20)),
                IconButton(
                  onPressed: () async {
                    await alertProvider.orderAlert(order['id'], context);
                    print(order['id']);
                  },
                  style: IconButton.styleFrom(backgroundColor: Colors.red),
                  icon: Icon(
                    Icons.notifications_active,
                    color: Theme.of(context).colorScheme.surface,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(Center(
            child: Text(order['orderDate'].toString().substring(0, 10),
                style: const TextStyle(fontSize: 20)))),
        DataCell(Center(
            child: Text(order['orderType'] ?? '',
                style: const TextStyle(fontSize: 20)))),
        DataCell(Center(
          child: Text(
            order['orderStatus'],
            style: const TextStyle(fontSize: 20),
          ),
        )),
        DataCell(Center(
          child: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            onPressed: () {
              orderProvider.toggleOrderVisibility(true, index);
              orderProvider.fetchFoodDetails(order['id']);
            },
          ),
        )),
        DataCell(
          DropdownButton<String>(
            value: orderProvider.selectedStatuses.length > index &&
                    allowedStatuses
                        .contains(orderProvider.selectedStatuses[index])
                ? orderProvider.selectedStatuses[index]
                : null,
            items: orderProvider.statusList
                .where((status) => allowedStatuses.contains(status))
                .map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                    color: Colors.yellow,
                  ),
                  child: Text(status, style: const TextStyle(fontSize: 17)),
                ),
              );
            }).toList(),
            onChanged: (newValue) async {
              if (newValue != null) {
                final matchedStatus = orderProvider.allStatusDetails.firstWhere(
                  (item) => item['text'].toString().trim() == newValue.trim(),
                  orElse: () => {},
                );

                if (matchedStatus.isEmpty || matchedStatus['id'] == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid status selected")),
                  );
                  return;
                }

                final statusId = matchedStatus['id'];

                final success = await orderProvider.updateOrderStatus(
                  orderId: order['id'],
                  statusId: statusId,
                );

                if (success) {
                  orderProvider.updateSelectedStatus(index, newValue);
                  await orderProvider.ordersHistory(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Order status updated successfully")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Failed to update order status")),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

final allowedStatuses = [
  'Processing',
  'Ready to Collect',
  'Out for Delivery',
  'Completed',
];
