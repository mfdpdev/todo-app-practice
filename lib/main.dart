import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

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

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {

  late Timer _timer;

  late String dayName;
  late String hourMinute;
  late String monthShort;
  late String indonesiaTime;
  late String internationalTime;

  void initState(){
    super.initState();
    initializeTimeZones();
    _updateTime();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      _updateTime();
    });
  }

  void _updateTime(){
    final jakarta = tz.getLocation('Asia/Jakarta');

    final nowJakarta = tz.TZDateTime.now(jakarta);
    final nowUtc = DateTime.now().toUtc();

    setState(() {
      dayName = DateFormat('EEEE').format(nowJakarta);
      hourMinute = DateFormat('HH.mm').format(nowJakarta);
      monthShort = DateFormat('MMM').format(nowJakarta).toUpperCase();
      indonesiaTime = DateFormat('hh:mm a').format(nowJakarta);
      internationalTime = DateFormat('hh:mm a').format(nowUtc);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
                        child: Text(dayName,
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
                                Text(hourMinute, 
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                                Text(monthShort,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(indonesiaTime, 
                                      style: TextStyle(
                                        fontSize: 20,
                                      )
                                    ),
                                    const Text('Indonesia'),
                                  ]
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(internationalTime, 
                                      style: TextStyle(
                                        fontSize: 20,
                                      )
                                    ),
                                    const Text('UTC Time'),
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
                  child: Tasks()
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

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  final List<String> data = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G'];

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        final task = data[index];

        return Padding(
          padding: EdgeInsets.all(4.0),
          child: Container(
            height: 60,
            color: Color(0xFFFAFAFA),
            child: ListTile(
              title: Text(task),
              leading: Checkbox(
                value: true,
                onChanged: (bool? newValue) {
                  // setState(() {
                  //   task.isChecked = newValue!;
                  // });
                },
                activeColor: Colors.grey,  // Warna ketika checked
                checkColor: Colors.white,  // Warna icon check saat checked
                side: BorderSide(color: Colors.grey, width: 2),  // Warna border saat unchecked
              ),
            ) 
          )
        );
      }
    );
  }
}
