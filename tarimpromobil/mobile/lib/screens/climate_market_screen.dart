import 'package:flutter/material.dart';

class ClimateMarketScreen extends StatelessWidget {
  const ClimateMarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('İklim ve Piyasa Yakında...', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
