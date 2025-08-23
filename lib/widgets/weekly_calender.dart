import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './../utils/date_utils.dart'
    show getWeekDates, getWeekStart, isSameDate, getWeekStartFromDate;

class WeeklyCalendar extends StatefulWidget {
  final PageController pageController;
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;
  final void Function(int) changeCurrentPage;

  const WeeklyCalendar({
    super.key,
    required this.pageController,
    required this.selectedDate,
    required this.onDateSelected,
    required this.changeCurrentPage,
  });

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  // Gunakan variabel ini untuk melacak tanggal yang akan digunakan untuk label bulan
  late DateTime _displayedDateForLabel;

  @override
  void initState() {
    super.initState();
    // Inisialisasi awal dengan tanggal yang dipilih
    _displayedDateForLabel = widget.selectedDate;
  }

  // Metode untuk memperbarui label bulan saat PageView digeser
  void _handlePageChanged(int index) {
    final newWeekStart = getWeekStart(index - 1000);
    setState(() {
      _displayedDateForLabel = newWeekStart;
    });
    widget.changeCurrentPage(index);
  }

  // Saat widget diperbarui dari parent
  @override
  void didUpdateWidget(covariant WeeklyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Perbarui _displayedDateForLabel jika selectedDate berubah
    if (!isSameDate(widget.selectedDate, oldWidget.selectedDate)) {
      setState(() {
        _displayedDateForLabel = widget.selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            // Menggunakan _displayedDateForLabel untuk label bulan
            DateFormat('MMM yyyy').format(_displayedDateForLabel),
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 80,
          child: PageView.builder(
            controller: widget.pageController,
            onPageChanged: _handlePageChanged,
            itemBuilder: (context, index) {
              final weekStart = getWeekStart(index - 1000);
              final weekDates = getWeekDates(weekStart);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: weekDates.map((date) {
                  final isSelected = isSameDate(date, widget.selectedDate);

                  return GestureDetector(
                    onTap: () {
                      // Panggil onDateSelected, label akan di-update oleh didUpdateWidget
                      widget.onDateSelected(date);
                    },
                    child: Column(
                      children: [
                        Text(
                          DateFormat('E').format(date).substring(0, 1),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: isSelected ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey,
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ],
    );
  }
}
