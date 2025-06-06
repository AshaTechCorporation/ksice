import 'package:flutter/material.dart';
import 'package:ksice/constants.dart';
import 'package:ksice/employee/history/historyPage.dart';
import 'package:ksice/employee/home/homePage.dart';
import 'package:ksice/employee/map/mapPage.dart';
import 'package:ksice/employee/profile/profilePage.dart';

class FristPage extends StatefulWidget {
  const FristPage({super.key, this.pageNum});
  final int? pageNum;

  @override
  State<FristPage> createState() => _FristPageState();
}

class _FristPageState extends State<FristPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomePage();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.pageNum != null) {
      selectedIndex = widget.pageNum!;
      onItemTapped(widget.pageNum!);
    }
  }

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

  Widget _buildNavItem({
    required int index,
    required String image,
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          image,
          width: 24,
          height: 24,
          color: isSelected ? Colors.white : Colors.white70,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: PageStorage(
        bucket: bucket,
        child: currentScreen,
      )),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        height: 80,
        // padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() => selectedIndex = index);
            onItemTapped(index);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0, // ซ่อนไม่ใช้ label ของระบบ
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavItem(
                index: 0,
                image: 'assets/icons/material-symbols_home-outline-rounded (1)_0.png',
                label: 'หน้าหลัก',
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(
                index: 1,
                image: 'assets/icons/bx_map (1)_0.png',
                label: 'MAP',
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(
                index: 2,
                image: 'assets/icons/subway_refresh-time (1)_0.png',
                label: 'ประวัติการส่ง',
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(
                index: 3,
                image: 'assets/icons/iconamoon_profile-bold (1)_0.png',
                label: 'โปรไฟล์',
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
