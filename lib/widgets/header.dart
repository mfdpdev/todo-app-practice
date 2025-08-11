import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

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
      dayName = DateFormat('EEEE, d').format(nowJakarta);
      hourMinute = DateFormat('HH:mm').format(nowJakarta);
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
    return Padding(
      padding: EdgeInsets.only(
        left: 26.0,
        right: 26.0,
        top: 10.0,
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
                      child: Text("GAtaw mAlezz"),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text("P!ingin beli trreckk"),
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
    );
  }
}
