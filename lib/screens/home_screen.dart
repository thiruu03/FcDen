import 'package:fcden/screens/order_screen.dart';
import 'package:fcden/utils/custom_dropdown.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -85,
            left: -90,
            child: Image.asset(
              "assets/images/pizza.png",
              height: 400,
            ),
          ),
          Positioned(
            top: -85,
            right: -70,
            child: Transform.rotate(
              angle: 4.3,
              child: Image.asset(
                "assets/images/fries.png",
                height: 420,
              ),
            ),
          ),
          Positioned(
            bottom: -25,
            left: -70,
            child: Transform.rotate(
              angle: 0,
              child: Image.asset(
                "assets/images/burger.png",
                height: 270,
              ),
            ),
          ),
          Positioned(
            bottom: -65,
            right: -90,
            child: Transform.rotate(
              angle: 0,
              child: Image.asset(
                "assets/images/chick.png",
                height: 390,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(fontFamily: 'lora', fontSize: 35),
                ),
                SizedBox(
                  height: height / 30,
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/images/logo-modified.png',
                    height: 250,
                  ),
                ),
                SizedBox(
                  height: height / 30,
                ),
                Text(
                  'Please choose your franchise location to proceed with your order.',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: height / 30,
                ),
                CustomDropdown(),
                SizedBox(
                  height: height / 30,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => OrderScreen(),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'redd',
                      child: Text(
                        "ENTER",
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
