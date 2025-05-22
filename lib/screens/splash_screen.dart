import 'package:fcden/screens/home_screen.dart';
import 'package:fcden/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../providers/location_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  InternetConnectionChecker internetConnectionChecker =
      InternetConnectionChecker.instance;

  Future<void> _checkInternetAndNavigate() async {
    bool isConnected = await internetConnectionChecker.hasConnection;

    if (!isConnected) {
      _showNoInternetDialog();
      return;
    }

    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    // Load saved location if any
    bool hasSavedLocation = await locationProvider.loadSavedLocation();

    // If no saved location, fetch locations from API
    if (!hasSavedLocation) {
      await locationProvider.getlocation();
    }

    await Future.delayed(Duration(seconds: 2));

    if (hasSavedLocation) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderScreen(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('No Internet Connection'),
        content: Text('Please turn on mobile data or Wi-Fi to continue.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              _checkInternetAndNavigate(); // Retry
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkInternetAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
          ),
          Center(
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/images/logo-modified.png',
                height: 250,
              ),
            ),
          ),
          SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.only(bottom: height / 10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "Powered BY",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    "Blyn technologies & Nidha Group",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
