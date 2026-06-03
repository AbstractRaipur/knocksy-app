import 'package:flutter/material.dart';

import 'home/home_page.dart';
import 'home/widgets/home_bottom_nav.dart';
import 'messages/messages_page.dart';
import 'profile/profile_page.dart';
import 'renter/renter_page.dart';

/// Hosts the four bottom-nav tabs and owns the single shared [HomeBottomNav].
/// An [IndexedStack] keeps each tab's scroll position alive when switching.
class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _index,
        children: const [
          HomePage(),
          RenterPage(),
          MessagesPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
