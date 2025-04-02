import 'package:fcden/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
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
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: height / 10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
