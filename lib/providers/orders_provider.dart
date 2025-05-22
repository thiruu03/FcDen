import 'dart:async';
import 'dart:convert';
import 'package:fcden/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class OrderProvider with ChangeNotifier {
  bool _isOrderVisible = false;
  bool _isFullScreen = false;
  String _today = '';
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _isError = false;
  bool _isRefreshing = false;

  List<String> userids = [];
  List<Map<String, dynamic>> _selectedOrder = [];
  List<Map<String, dynamic>> _allOrders = [];
  List<String> _statusList = [];
  List<String> _selectedStatuses = [];
  List<Map<String, dynamic>> allStatusDetails = [];
  Timer? _pollingTimer;
  String _lastKnownOrderId = '';

  bool get isOrderVisible => _isOrderVisible;
  bool get isFullScreen => _isFullScreen;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  bool get isRefreshing => _isRefreshing;
  List<Map<String, dynamic>> get selectedOrder => _selectedOrder;
  List<Map<String, dynamic>> get allOrders => _allOrders;
  List<String> get statusList => _statusList;
  List<String> get selectedStatuses => _selectedStatuses;
  int get selectedIndex => _selectedIndex;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  OrderProvider({required this.flutterLocalNotificationsPlugin});

  void startAutoRefresh(BuildContext context) {
    // Cancel any existing timer
    _pollingTimer?.cancel();

    // Set up a timer that fetches orders every 15 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      await ordersHistory(context);

      print("Screen refreshed");
    });
  }

  Future<void> initialize(BuildContext context) async {
    await fetchInitialData(context);
    startPolling(context);
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'order_channel_id',
      'Order Notifications',
      channelDescription: 'Notifies when a new order is placed',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  String getTodayDate() {
    if (_today.isEmpty) {
      final now = DateTime.now();
      _today =
          "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    }
    return _today;
  }

  Future<void> fetchInitialData(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      await getStatus();
      await ordersHistory(context);

      _isLoading = false;
      _isError = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> ordersHistory(BuildContext context) async {
    final selectedLocationId =
        Provider.of<LocationProvider>(context, listen: false).locationId;

    if (selectedLocationId == null) {
      _isError = true;
      notifyListeners();
      return;
    }

    if (_isRefreshing) {
      _isRefreshing = true;
      notifyListeners();
    }

    try {
      final url = Uri.parse(
          "https://www.fcdens.ndapp.in/fcdenapi/api/Order/getkitchenorderhistory");
      final headers = {"Content-Type": "application/json"};
      final body = {
        "LocationId": selectedLocationId,
        "OrderFromDate": getTodayDate(),
        "OrderToDate": getTodayDate(),
      };

      final res = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200 || res.statusCode == 201) {
        final decoded = jsonDecode(res.body) as List;
        final orders = decoded.cast<Map<String, dynamic>>().toList();
        final ids = orders.map((item) => item['id'].toString()).toList();

        _selectedOrder = orders;
        userids = ids;
        _selectedStatuses = List.generate(
          _selectedOrder.length,
          (_) => _statusList.isNotEmpty ? _statusList.first : '',
        );
        _isError = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load orders: ${res.statusCode}');
      }
    } catch (e) {
      _isError = true;
      notifyListeners();
      rethrow;
    } finally {
      if (_isRefreshing) {
        _isRefreshing = false;
        notifyListeners();
      }
    }
  }

  Future<void> fetchFoodDetails(String id) async {
    try {
      final url = Uri.parse(
          "https://www.fcdens.ndapp.in/fcdenapi/api/Order/fooddetaildata/$id");
      final res = await http.get(url).timeout(const Duration(seconds: 30));

      if (res.statusCode == 200 || res.statusCode == 201) {
        final decoded = jsonDecode(res.body) as List;
        _allOrders = decoded
            .cast<Map<String, dynamic>>()
            .map((item) => {...item, 'isChecked': false})
            .toList();
        _isError = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load food details: ${res.statusCode}');
      }
    } catch (e) {
      _isError = true;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> getStatus() async {
    try {
      final res = await http
          .get(Uri.parse(
              'https://www.fcdens.ndapp.in/fcdenapi/api/Master/getorderstatusmasterdata'))
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        _statusList =
            data.map<String>((item) => item['text'].toString()).toList();
        allStatusDetails = data.cast<Map<String, dynamic>>().toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load status: ${res.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkForNewOrders(BuildContext context) async {
    try {
      final selectedLocationId =
          Provider.of<LocationProvider>(context, listen: false).locationId;

      if (selectedLocationId == null) return;

      final url = Uri.parse(
          "https://www.fcdens.ndapp.in/fcdenapi/api/Order/getkitchenorderhistory");
      final headers = {"Content-Type": "application/json"};
      final body = {
        "LocationId": selectedLocationId,
        "OrderFromDate": getTodayDate(),
        "OrderToDate": getTodayDate(),
      };

      final response = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        final data = jsonDecode(response.body) as List;
        if (data.isNotEmpty) {
          final latestOrderId = data[0]['id'].toString();
          if (latestOrderId != _lastKnownOrderId) {
            _lastKnownOrderId = latestOrderId;

            await showLocalNotification(
              title: 'New Order Received',
              body: 'Token: ${data[0]['tokenNumber']} - ${data[0]['name']}',
            );
            await ordersHistory(context);
          }
        }
      }
    } catch (e) {
      debugPrint("Polling error: $e");
    }
  }

  void startPolling(BuildContext context) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      await checkForNewOrders(context);
    });
  }

  Future<bool> updateOrderStatus({
    required String orderId,
    required String statusId,
  }) async {
    try {
      const String url =
          "https://www.fcdens.ndapp.in/fcdenapi/api/Order/updateorderstatus";

      final response = await http
          .post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "OrderId": orderId,
              "StatusId": statusId,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData is bool
            ? responseData
            : responseData is Map
                ? responseData['Result'] ?? false
                : false;
      } else {
        throw Exception('Failed to update status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Update status error: $e");
      return false;
    }
  }

  void toggleOrderVisibility(bool visible, int index) {
    _isOrderVisible = visible;
    _selectedIndex = index;
    notifyListeners();
  }

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  void updateCheckStatus(int index, bool value) {
    _allOrders[index]['IsServed'] = value;
    notifyListeners();
  }

  void updateSelectedStatus(int index, String newValue) {
    _selectedStatuses[index] = newValue;
    notifyListeners();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
