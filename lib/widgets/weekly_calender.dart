import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyCalendar extends StatelessWidget {

  final pageController;
  final selectedDate;
  final DateTime Function(int) getWeekStart;
  final void Function(DateTime) onDateSelected;
  final List<DateTime> Function(DateTime) getWeekDates;
  final void Function(int) changeCurrentPage;

  const WeeklyCalendar({
    super.key,
    required this.pageController,
    required this.selectedDate,
    required this.getWeekStart,
    required this.onDateSelected,
    required this.getWeekDates,
    required this.changeCurrentPage,
  });

  @override
  Widget build(BuildContext context) {
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
            DateFormat('MMM yyyy').format(selectedDate),
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
            controller: pageController,
            onPageChanged: (int index) {
              changeCurrentPage(index);
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
                      onDateSelected(date);
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
                            color: isSelected ? Colors.black : Colors.white,
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
                                color: isSelected ? Colors.white : Colors.black,
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
