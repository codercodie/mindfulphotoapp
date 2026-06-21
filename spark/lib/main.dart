import 'package:flutter/material.dart';
import 'package:spark/theme/themes.dart' as theme show activeThemePack;
import 'screens/home_screen.dart';
import 'screens/clusters_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/build_theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wabisnaps',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(theme.activeThemePack),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final screens = const [
    HomeScreen(),
    ClustersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'home'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), label: 'clusters'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'me'),
        ],
      ),
    );
  }
}