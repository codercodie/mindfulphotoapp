import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
// import 'screens/corners_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/camera_screen.dart';
import 'theme/build_theme.dart';
import 'state/active_theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemePackProvider);

    return MaterialApp(
      title: 'wabisnaps',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(activeTheme),
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

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      CameraScreen(
        onGlimmerSaved: () {
          setState(() {
            selectedIndex = 0;
          });
        },
      ),
      // const CornersScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        height: 66,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_outlined, size: 31),
            selectedIcon: Icon(Icons.add, size: 31),
            label: 'add glimmer',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.group_outlined),
          //   selectedIcon: Icon(Icons.group),
          //   label: 'corners',
          // ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'me',
          ),
        ],
      ),
    );
  }
}
