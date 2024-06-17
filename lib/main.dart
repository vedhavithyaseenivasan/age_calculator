import 'package:age_calculator/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const AgeCalculatorApp());
}

class AgeCalculatorApp extends StatelessWidget {
  const AgeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Age Calculator',
      theme: ThemeData(),
      home: const SplashScreen(),
    );
  }
}

class AgeCalculatorHome extends StatefulWidget {
  const AgeCalculatorHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AgeCalculatorHomeState createState() => _AgeCalculatorHomeState();
}

class _AgeCalculatorHomeState extends State<AgeCalculatorHome> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String _ageDetails = '';
  String _nextBirthdayDetails = '';
  String _years = '';
  String _months = '';
  String _days = '';
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Set selected date to current date
    _dobController.text = DateFormat('MM/dd/yyyy').format(_selectedDate!);
    _calculateAge();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
        _calculateAge();
      });
    }
  }

  void _calculateAge() {
    if (_selectedDate == null) return;

    final inputDate = _selectedDate!;
    final now = DateTime.now();

    // Calculate age in years, months, and days
    int years = now.year - inputDate.year;
    int months = now.month - inputDate.month;
    int days = now.day - inputDate.day;

    if (days < 0) {
      months -= 1;
      days += DateTime(now.year, now.month, 0).day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    // to Calculate total months old
    int totalMonths = years * 12 + months;

    // to Calculate total days old
    int totalDays = now.difference(inputDate).inDays;

    // to Calculate total weeks old
    int totalWeeks = totalDays ~/ 7;

    // to Calculate total hours, minutes, and seconds old
    int totalHours = totalDays * 24 + now.hour;
    int totalMinutes = totalHours * 60 + now.minute;
    int totalSeconds = totalMinutes * 60 + now.second;

    // next birthday
    DateTime nextBirthday = DateTime(now.year, inputDate.month, inputDate.day);
    if (now.isAfter(nextBirthday)) {
      nextBirthday = DateTime(now.year + 1, inputDate.month, inputDate.day);
    }
    int daysUntilNextBirthday = nextBirthday.difference(now).inDays;
    int monthsUntilNextBirthday = nextBirthday.month - now.month;
    if (monthsUntilNextBirthday < 0) {
      monthsUntilNextBirthday += 12;
    }

    setState(() {
      _years = '$years';
      _months = '$months';
      _days = '$days';
      _ageDetails = ' $days';
      _nextBirthdayDetails =
          'Next Birthday \n$monthsUntilNextBirthday Months $daysUntilNextBirthday Days\n(${DateFormat('EEEE').format(nextBirthday)})';
    });
  }

  void _onClear() {
    setState(() {
      _selectedDate = DateTime.now();
      _dobController.text = DateFormat('MM/dd/yyyy').format(_selectedDate!);
      _calculateAge();
    });
  }

  @override
  Widget build(BuildContext context) {
    //age calculation
    DateTime now = DateTime.now();
    int years = _selectedDate != null ? now.year - _selectedDate!.year : 0;
    int months = _selectedDate != null ? now.month - _selectedDate!.month : 0;
    int totalDays =
        _selectedDate != null ? now.difference(_selectedDate!).inDays : 0;
    int totalHours = _selectedDate != null ? totalDays * 24 + now.hour : 0;
    int totalMinutes = _selectedDate != null ? totalHours * 60 + now.minute : 0;
    int totalSeconds =
        _selectedDate != null ? totalMinutes * 60 + now.second : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Age Calculator',
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: MediaQuery.of(context).size.width > 600
              ? const EdgeInsets.all(64.0)
              : const EdgeInsets.all(16.0),
          child: Form(
            //key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 38, 7, 215),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Select your Date of birth",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                style: const TextStyle(color: Colors.black),
                                controller: _dobController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.calendar_month_sharp,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _selectDate(context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: _onClear,
                                    child: const Text(
                                      'Clear',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Your age is:",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 38, 7, 215),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 80,
                                  width: 80,
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          _years,
                                          style: const TextStyle(
                                              fontSize: 55,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 194, 154, 186),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 80,
                                  width: 80,
                                  child: Column(
                                    children: [
                                      Text(
                                        _months,
                                        style: const TextStyle(
                                            fontSize: 55, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 146, 223, 180),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 80,
                                  width: 80,
                                  child: Column(
                                    children: [
                                      Text(
                                        _days,
                                        style: const TextStyle(
                                            fontSize: 55, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "Years",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    Center(
                                        child: Text(
                                      "Months",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal),
                                    ))
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Days",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 5,
                      ),
                      Text(
                        'Months old: ${years * 12 + months}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Weeks old: ${totalDays ~/ 7}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Days old: $totalDays',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Hours old (approx): $totalHours',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Minutes old (approx): $totalMinutes',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Seconds old (approx): $totalSeconds',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 146, 223, 180),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _nextBirthdayDetails,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
