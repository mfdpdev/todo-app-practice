import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Page(),
    );
  }
}

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  int _selectedIndex = 1;

  final List<Widget> _page = <Widget>[
    Page0(),
    Page1(),
    Page2(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _page[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Color(0xFFFAFAFA),
        selectedItemColor: Colors.black,
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
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 26.0,
                  right: 26.0,
                  top: 18.0,
                  bottom: 18.0,
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text('Sunday',
                          style: TextStyle(
                            fontSize: 20,
                          )
                        )
                      ),
                    ),
                    Container(
                      height: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text('22.30', 
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                                const Text('DEC',
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  )
                                )
                              ]
                            )
                          ),
                          Container(
                            width: 1,               // lebar garis
                            height: double.infinity,             // tinggi garis
                            color: Colors.grey,     // warna garis
                            margin: EdgeInsets.symmetric(horizontal: 8),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text('1:20 PM', 
                                      style: TextStyle(
                                        fontSize: 20,
                                      )
                                    ),
                                    const Text('New York'),
                                  ]
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text('6:20 PM', 
                                      style: TextStyle(
                                        fontSize: 20,
                                      )
                                    ),
                                    const Text('UK'),
                                  ]
                                ),
                              ]
                            )
                          ),
                        ]
                      ),
                    )
                  ]
                )
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: const Text('Hello, World!')
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context){
    return Center(
      child: const Text('Settings Coming Soon!')
    );
  }
}

class Page0 extends StatelessWidget {
  const Page0({super.key});

  @override
  Widget build(BuildContext context){
    return Center(
      child: const Text('Checklist Coming Soon!')
    );
  }
}
