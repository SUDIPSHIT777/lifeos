import 'package:flutter/material.dart';
import 'package:lifeos/feature/ai_assistant/ui/aiassistent.dart';
import 'package:lifeos/feature/dashboard/ui/dashboard.dart';
import 'package:lifeos/feature/finance/ui/financepage.dart';
import 'package:lifeos/feature/habit/ui/habitpage.dart';
import 'package:lifeos/feature/tasks/ui/taskpageui.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class Navigationbar extends StatefulWidget {
  const Navigationbar({super.key});

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  List<Widget> _screens() {
    return const [
      Dashboard(),
      Taskpageui(),
      AiassistentPage(),
      HabitPage(),
      Financepage(),
    ];
  }

  List<PersistentBottomNavBarItem> _items() {
    return [
      PersistentBottomNavBarItem(
        icon: Center(child: Image.asset("assets/dashboard.png", scale: 25)),
        activeColorPrimary: const Color(0xff6366F1),
      ),
      PersistentBottomNavBarItem(
        icon: Center(child: Image.asset("assets/task.png", scale: 22)),
        activeColorPrimary: const Color(0xff22C55E),
      ),
      PersistentBottomNavBarItem(
        icon: Center(child: Image.asset("assets/ai.png", scale: 12)),
        activeColorPrimary: Color(0xFF6D23DE),
      ),
      PersistentBottomNavBarItem(
        icon: Center(child: Image.asset("assets/gym.png", scale: 25)),
        activeColorPrimary: const Color(0xffF59E0B),
      ),
      PersistentBottomNavBarItem(
        icon: Center(
          child: Image.asset("assets/asset-management.png", scale: 20),
        ),
        activeColorPrimary: const Color(0xffEF4444),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _controller.index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_controller.index != 0) {
            _controller.jumpToTab(0);
          }
        }
      },
      child: Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _screens(),
          items: _items(),
          handleAndroidBackButtonPress: false,
          navBarStyle: NavBarStyle.style14,
        ),
      ),
    );
  }
}
