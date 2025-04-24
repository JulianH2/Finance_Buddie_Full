import 'package:finance_buddie/provider/ThemeProvider.dart';
import 'package:finance_buddie/screens/ChatScreen.dart';
import 'package:finance_buddie/screens/InicioScreen.dart';
import 'package:finance_buddie/screens/MenuScreen.dart';
import 'package:finance_buddie/screens/OrganizadorScreen.dart';
import 'package:finance_buddie/screens/CursosScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Widget> _screens = [
    InicioScreen(),
    OrganizadorScreen(),
    ChatScreen(),
    CursosScreen(),
    MenuScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.monitor_heart_outlined,
    Icons.emoji_objects_outlined,
    Icons.book,
    Icons.menu_rounded,
  ];

  final List<String> _titles = [
    'Inicio',
    'Balance',
    'Asistente',
    'Cursos',
    'Menú',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    //  final screenHeight = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: themeProvider.surfaceColor,
        systemNavigationBarIconBrightness:
            themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.surfaceColor,
        elevation: 2,
        title: Text(
          'Finance Buddie',
          style: TextStyle(
            color: themeProvider.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: themeProvider.primaryColor,
              size: 26,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeProvider.isDarkMode
                      ? themeProvider.primaryDark.withOpacity(0.3)
                      : themeProvider.accentColor.withOpacity(0.1),
                  themeProvider.backgroundColor,
                ],
                stops: [0.0, 0.3],
              ),
            ),
          ),
          FadeTransition(
            opacity: _animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.05, 0),
                end: Offset.zero,
              ).animate(_animation),
              child: IndexedStack(index: _selectedIndex, children: _screens),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: themeProvider.surfaceColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _icons.length,
                (index) => InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _onItemTapped(index),
                  child: Container(
                    width: screenWidth / _icons.length - 10,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color:
                          _selectedIndex == index
                              ? themeProvider.secondaryColor.withOpacity(0.15)
                              : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _icons[index],
                          color:
                              _selectedIndex == index
                                  ? themeProvider.secondaryColor
                                  : themeProvider.hintTextColor,
                          size: 26,
                        ),
                        SizedBox(height: 4),
                        Text(
                          _titles[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                _selectedIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                _selectedIndex == index
                                    ? themeProvider.secondaryColor
                                    : themeProvider.hintTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla Principal')),
      body: Center(
        child: ElevatedButton(
          child: Text('Ir a Configuración'),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ),
    );
  }
}
