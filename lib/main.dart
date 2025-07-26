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

class Page extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Page1(),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        shape: CircularNotchedRectangle(), // Biar ada notch (takik) buat FAB
        // color: Color(0xFFFAFAFA),
        color: Colors.black,
      ), 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            // isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Sudut melengkung
            ),
            context: context,
            builder: (context) => Container(
              // height: 200,
              // shape: RoundedRectangleBorder,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Todo',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          // hintText: 'Masukkan sesuatu...',
                          // hintStyle: TextStyle(
                          //   color: Colors.grey.shade500, // Warna hint text
                          // ),
                          // fillColor: Colors.blue.shade50, // Background warna
                          // filled: true,  // Mengaktifkan fillColor
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black, // Warna border saat difokuskan
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black, // Warna border saat tidak difokuskan
                              width: 2,
                            ),
                          ),
                        )
                      )
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        var pickedDate = await showDatePicker(
                          context: context,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2019),
                          lastDate: DateTime(2050),
                        );

                        // setState(() {
                        //   selectedDate = pickedDate;
                        // });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        var pickedTime = await showTimePicker(
                          context: context,
                          initialEntryMode: TimePickerEntryMode.dial,
                          initialTime: TimeOfDay.now(),
                        );

                        // setState(() {
                        //   selectedDate = pickedDate;
                        // });
                      },
                    ),
                    Material(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.0),
                        onTap: () => {
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.add, color: Colors.white)
                        )
                      )
                    )
                  ]
                )
              )
            )
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  bottom: 0.0,
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        // alignment: Alignment.centerLeft,
                        children: <Widget>[
                          Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 20,
                            )
                          ),
                          PopupMenuButton<int>(
                            icon: Icon(Icons.more_vert),
                            color: Color(0xFFFAFAFA),
                            onSelected: (int value) {

                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<int>(
                                value: 0,
                                child: Text("Option 1"),
                              ),
                              PopupMenuItem<int>(
                                value: 1,
                                child: Text("Option 2"),
                              ),
                            ],
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Container(
                height: 140,
                child: WeeklyCalendar(),
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

class Task {
  String task;
  bool isDone;
  DateTime? scheduleAt;

  Task({required this.task, this.isDone = false, this.scheduleAt});
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
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        final task = data[index];

        return Padding(
          padding: EdgeInsets.all(6.0),
          child: Material(
            color: Colors.black,
            elevation: 1,
            child: Container(
              height: 60,
              // color: Color(0xFFFAFAFA),
              color: Colors.white,
              child: ListTile(
                title: Text(task),
                leading: Checkbox(
                  value: true,
                  onChanged: (bool? newValue) {
                  },
                  activeColor: Colors.black,  // Warna ketika checked
                  checkColor: Colors.white,  // Warna icon check saat checked
                  side: BorderSide(color: Colors.grey, width: 2),  // Warna border saat unchecked
                ),
              ) 
            )
          )
        );
      }
    );
  }
}


class WeeklyCalendar extends StatefulWidget {
  @override
  _WeeklyCalendarState createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  PageController _pageController = PageController(initialPage: 1000);
  int _currentPage = 1000;

  DateTime selectedDate = DateTime.now();

  DateTime getWeekStart(int weekOffset) {
    final now = DateTime.now();
    final weekday = now.weekday;
    final monday = now.subtract(Duration(days: weekday - 1));
    return monday.add(Duration(days: 7 * weekOffset));
  }

  DateTime getMonthStart(int monthOffset){
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month + monthOffset, 1);
  }

  void _onDateSelected(DateTime date){
    setState((){
      selectedDate = date;
    });
  }

  List<DateTime> getWeekDates(DateTime startOfWeek) {
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {

    DateTime startOfWeek = getWeekStart(_currentPage - 1000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            DateFormat('MMM yyyy').format(startOfWeek),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 80,
          // width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final weekStart = getWeekStart(index - 1000);
              final weekDates = getWeekDates(weekStart);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: weekDates.map((date) {
                  final isToday = _isSameDate(date, DateTime.now());
                  final isSelected = _isSameDate(date, selectedDate);

                  return GestureDetector(
                    onTap: () {
                      _onDateSelected(date);
                    },
                    child: Column(
                      children: [
                        Text(
                          DateFormat('E').format(date).substring(0, 1),
                          style: TextStyle(
                            color: Colors.grey,
                          )
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: isToday ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )
                          ),
                          child: Center(
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                color: isToday ? Colors.white : Colors.black,
                              )
                            )
                          )
                        )
                      ]
                    )
                  );
                }).toList(),
              );
            }
          ) 
        ),
        Container(
          height: 1,               // lebar garis
          width: double.infinity,             // tinggi garis
          color: Colors.grey,     // warna garis
          margin: EdgeInsets.symmetric(horizontal: 8),
        ),
      ]
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}


              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: List.generate(31, (dayIndex) {
              //       DateTime date = DateTime(startOfMonth.year, startOfMonth.month, dayIndex + 1);
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //         child: GestureDetector(
              //           onTap: () {
              //             _onDateSelected(date);
              //           },
              //           child: Column(
              //             children: [
              //               Text(
              //                 DateFormat('E').format(date),
              //               ),
              //               SizedBox(height: 4),
              //               Container(
              //                 padding: EdgeInsets.all(10.0),
              //                 decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: Colors.black,
              //                   border: Border.all(
              //                     color: Colors.black,
              //                     width: 2,
              //                   )
              //                 ),
              //                 child: Text(
              //                   date.day.toString(),
              //                   style: TextStyle(
              //                     color: Colors.white,
              //                   )
              //                 )
              //               )
              //             ]
              //           )
              //         )
              //       );
              //     })
              //   )
              // )
