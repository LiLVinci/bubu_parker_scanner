import 'package:bubu_parker_scanner/screens/wine_list_screen.dart';
import 'package:flutter/material.dart';
import 'screens/wine_menu_scanner.dart';

void main() {
  runApp(WineMenuApp());
}

class WineMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wine Menu',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  List<Widget> _screens = [
    WineMenuScanner(),
    WineListScreen(),
    // Add more screens here if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Wine List',
          ),
          // Add more items here if needed
        ],
      ),
    );
  }
}