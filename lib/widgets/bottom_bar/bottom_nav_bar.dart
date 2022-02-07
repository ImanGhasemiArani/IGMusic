import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: 100,
    );
  }
}

// SalomonBottomBar(
//         itemShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         curve: Curves.bounceOut,
//         unselectedItemColor: Colors.grey,
//         margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
//         itemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         currentIndex: ScreenHolder.currentTabNotifier.value,
//         onTap: (i) => setState(() => ScreenHolder.currentTabNotifier.value = i),
//         items: [
//           SalomonBottomBarItem(
//             icon: const Icon(Icos.headphones_1),
//             title: Text(
//               "My Music",
//               style: GoogleFonts.ubuntuMono(),
//             ),
//             selectedColor: Colors.orange,
//           ),
//           SalomonBottomBarItem(
//             icon: const Icon(Icons.online_prediction_rounded),
//             title: Text(
//               "Online",
//               style: GoogleFonts.ubuntuMono(),
//             ),
//             selectedColor: Colors.teal,
//           ),
//         ],
//       ),
