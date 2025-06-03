import 'package:flutter/material.dart';
import 'package:ksice/employee/history/historyPage.dart';
import 'package:ksice/employee/home/homePage.dart';
import 'package:ksice/employee/map/mapPage.dart';
import 'package:ksice/employee/profile/profilePage.dart';

class FristPage extends StatefulWidget {
  const FristPage({super.key});

  @override
  State<FristPage> createState() => _FristPageState();
}

class _FristPageState extends State<FristPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomePage();
  int selectedIndex = 0;


  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (selectedIndex == 0) {
        currentScreen = HomePage();
      } else if (selectedIndex == 1) {
        currentScreen = MapPage();
      } else if (selectedIndex == 2) {
        currentScreen = HistoryPage();
      } else if (selectedIndex == 3) {
        currentScreen = ProfilePage();
      } else {}
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
       body: SafeArea(
          child: PageStorage(
        bucket: bucket,
        child: currentScreen,
      )),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() => selectedIndex = index);
              onItemTapped(selectedIndex);
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'หน้าหลัก',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on),
                label: 'MAP',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'ประวัติการส่ง',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'โปรไฟล์',
              ),
            ],
          ),
        ),
      ),
    );
  }
}