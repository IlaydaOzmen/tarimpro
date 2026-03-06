import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'plan_wizard_screen.dart';
import 'ai_recommendations_screen.dart';
import 'climate_market_screen.dart';
import 'profile_screen.dart';

class MainViewScreen extends StatefulWidget {
  const MainViewScreen({Key? key}) : super(key: key);

  @override
  _MainViewScreenState createState() => _MainViewScreenState();
}

class _MainViewScreenState extends State<MainViewScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const PlanWizardScreen(),
    const AiRecommendationsScreen(),
    const ClimateMarketScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed if > 3 items
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Özet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Plan Sihirbazı',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco),
            label: 'Yapay Zeka',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'İklim/Piyasa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
