import 'package:chatting_app/screens/friends_search.dart';
import 'package:chatting_app/screens/home_screen.dart';
import 'package:chatting_app/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AllPages extends StatefulWidget {
  const AllPages({super.key});

  @override
  State<AllPages> createState() => _AllPagesState();
}

class _AllPagesState extends State<AllPages> {
  // List pages = [HomeScreen(),Settings(),Account()];
  int pageIndex = 0;
  final _pageController = PageController(initialPage: 0);
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: const [
          HomeScreen(),
          Settings(),
          FriendsSearch(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
          _pageController.jumpToPage(pageIndex);
        },
        items: [
          BottomNavigationBarItem(
            
            icon: const Icon(FontAwesomeIcons.comments,),
            label: "Chats",
            
            activeIcon: Icon(FontAwesomeIcons.solidComments,color: Theme.of(context).iconTheme.color,),
          ),
          BottomNavigationBarItem(
            
            icon: const Icon(Icons.settings_outlined),
            label: "Settings",
            activeIcon: Icon(Icons.settings,color: Theme.of(context).iconTheme.color,)
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_add_outlined,),
            label: "Add friends",
            activeIcon: Icon(Icons.person_add,color: Theme.of(context).iconTheme.color,),
          ),
        ],
        ),
    );
  }
}