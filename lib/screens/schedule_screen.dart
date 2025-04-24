import 'package:ai_league_app/constants/app_constants.dart';
import 'package:ai_league_app/functions.dart';
import 'package:ai_league_app/screens/routes_screen.dart';
import 'package:ai_league_app/utils.dart';
import 'package:ai_league_app/widgets/custom_app_bar.dart';
import 'package:ai_league_app/widgets/styled_button.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // Import for File type

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _cityController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _hasTicket = false;
  File? _pickedTicketFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        height: double.infinity,
        color: AppConstants.mainColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInstructionText(),
              const SizedBox(height: 30),

              buildSectionTitle('When are you staying?'),
              const SizedBox(height: 12),

              // Date inputs
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabelText('From'),
                        const SizedBox(height: 6),
                        buildDateTimeInput(
                          context: context,
                          dateTime: _fromDate,
                          onPressed: () async {
                            DateTime? dt = await selectDateTime(
                              context: context,
                              initialDateTime: _fromDate,
                            );
                            if (dt == null) {
                              return;
                            }
                            if (_toDate != null && _toDate!.isBefore(dt)) {
                              return;
                            }
                            setState(() {
                              _fromDate = dt;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabelText('To'),
                        const SizedBox(height: 6),
                        buildDateTimeInput(
                          context: context,
                          dateTime: _toDate,
                          onPressed: () async {
                            DateTime? dt = await selectDateTime(
                              context: context,
                              initialDateTime: _toDate,
                            );
                            if (dt == null) {
                              return;
                            }
                            if (_fromDate != null && dt.isBefore(_fromDate!)) {
                              return;
                            }
                            setState(() {
                              _toDate = dt;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              buildSectionTitle('Which city are you visiting?'),
              const SizedBox(height: 12),
              buildCityInput(controller: _cityController),
              const SizedBox(height: 30),

              buildSectionTitle('Do you have a ticket?'),
              const SizedBox(height: 12),
              buildTicketSelection(
                hasTicket: _hasTicket,
                onYesPressed: () => setState(() => _hasTicket = true),
                onNoPressed: () => setState(() => _hasTicket = false),
              ),
              const SizedBox(height: 30),

              if (_hasTicket) ...[
                buildSectionTitle('Upload your ticket'),
                const SizedBox(height: 12),
                buildTicketUpload(
                  pickedFile: _pickedTicketFile,
                  onUploadPressed: () async {
                    File? file = await pickTicketFile();
                    if (file != null) {
                      setState(() {
                        _pickedTicketFile = file;
                      });
                    }
                  },
                ),
                const SizedBox(height: 40),
              ],

              buildDoneButton(
                onPressed: () {
                  // Handle Done action
                  // print('From Date: $_fromDate');
                  // print('To Date: $_toDate');
                  // print('City: ${_cityController.text}');
                  // print('Has Ticket: $_hasTicket');
                  // print('Ticket File: ${_pickedTicketFile?.path}');
                  // routes = getRoutes()
                  pushScreen(context, RoutesScreen());
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}

// Pure function widgets
Widget buildInstructionText() {
  return const SizedBox(
    width: double.infinity,
    child: Text(
      'Enter your stay, ticket info, and preferences\nto get your AI-generated travel roadmap.',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey, fontSize: 14),
    ),
  );
}

Widget buildSectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget buildLabelText(String label) {
  return Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14));
}

Widget buildDateTimeInput({
  required BuildContext context,
  required DateTime? dateTime,
  required VoidCallback onPressed,
}) {
  String displayText =
      dateTime == null
          ? "DD/MM/YYYY\nHH:MM"
          : "${getDateStr(dateTime, context)}\n${getTimeStr(dateTime, context)}";

  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppConstants.matchColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          displayText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.3,
          ),
        ),
      ),
    ),
  );
}

Widget buildCityInput({required TextEditingController controller}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: AppConstants.matchColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextField(
      controller: controller,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: const InputDecoration(
        hintText: 'Write your destination',
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget buildTicketSelection({
  required bool hasTicket,
  required VoidCallback onYesPressed,
  required VoidCallback onNoPressed,
}) {
  return Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: onNoPressed,
          child: StyledButton(
            disabled: hasTicket,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'No',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: !hasTicket ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: GestureDetector(
          onTap: onYesPressed,
          child: StyledButton(
            disabled: !hasTicket,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'Yes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: hasTicket ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildTicketUpload({
  required File? pickedFile,
  required VoidCallback onUploadPressed,
}) {
  return Row(
    children: [
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppConstants.matchColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            pickedFile?.path.split(Platform.pathSeparator).last ?? 'Upload',
            style: TextStyle(
              color: pickedFile != null ? Colors.white : Colors.grey,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      const SizedBox(width: 10),
      StyledButton(
        child: GestureDetector(
        onTap: onUploadPressed,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: const Icon(Icons.add, color: Colors.white, size: 24)),
      ),
      ),
    ],
  );
}

Widget buildDoneButton({required VoidCallback onPressed}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 60),
    child: GestureDetector(
      onTap: onPressed,
      child: StyledButton(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// Pure functions for date, time and file operations
Future<DateTime?> selectDateTime({
  required BuildContext context,
  DateTime? initialDateTime,
}) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDateTime ?? DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppConstants.confirmColor,
            onPrimary: Colors.white,
            surface: AppConstants.matchColor,
            onSurface: Colors.white,
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: AppConstants.mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (pickedDate != null) {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppConstants.confirmColor,
              onPrimary: Colors.white,
              surface: AppConstants.matchColor,
              onSurface: Colors.white,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppConstants.mainColor,
              dialBackgroundColor: AppConstants.matchColor,
              hourMinuteTextColor: Colors.white,
              dayPeriodTextColor: Colors.white,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppConstants.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      return DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
  }
  return null;
}

Future<File?> pickTicketFile() async {
  // This is a placeholder for the actual implementation that would use FilePicker
  // Since FilePicker is commented out in the original code, we'll just return null
  // In a real implementation, you would:
  // 1. Call FilePicker.platform.pickFiles()
  // 2. If result isn't null, return File(result.files.single.path!)
  return null;
}
