import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(ReservationApp());
}

class ReservationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReservationScreen(),
    );
  }
}

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String utcTime = "Select a time to view details.";
  String localTime = "";

  // Converts and formats the selected time
  void handleReservationTime(DateTime reservationTime) {
    setState(() {
      utcTime = _formatTime(reservationTime.toUtc(), "UTC");
      localTime = _formatTime(reservationTime.toLocal(), "Local");
    });
  }

  // Formats time with a label
  String _formatTime(DateTime time, String label) {
    return "${DateFormat('yMMMMd • h:mm a').format(time)} ($label)";
  }

  // Opens a combined date and time picker
  Future<void> pickReservationTime() async {
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (pickedTime != null) {
        handleReservationTime(
          DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Tracker'),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Track Reservations Across Time Zones",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: pickReservationTime,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blueAccent, // Correct property name
                shadowColor: Colors.blueGrey,
                elevation: 5,
              ),
              child: Text(
                "Select Reservation Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
            SizedBox(height: 30),
            _buildTimeCard("Stored Time (UTC):", utcTime),
            SizedBox(height: 20),
            _buildTimeCard("Displayed Time (Local):", localTime),
          ],
        ),
      ),
    );
  }

  // A reusable widget to display time in cards
  Widget _buildTimeCard(String label, String time) {
    return Card(
      elevation: 5,
      shadowColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[700],
              ),
            ),
            SizedBox(height: 10),
            Text(
              time,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
