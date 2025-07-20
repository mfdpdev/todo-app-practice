import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: const Text("Hellos, World!")
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          onTap: (index) {
            // setState(() {
            //   _selectedIndex = index;
            // });
          },
          // backgroundColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 16.0), // Padding pada icon
                child: Icon(Icons.check_box),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 16.0), // Padding pada icon
                child: Icon(Icons.add),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 16.0), // Padding pada icon
                child: Icon(Icons.settings),
              ),
              label: '',
            ),
          ]
        )
      )
    );
  }
}

// class Header extends StatelessWidget {
//   const Header({super.key});
//
//   @override
//   Widget build(BuildContext context){
//     return 
//   }
// }
