import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:quickmed/modules/patient/appointment/widgets/doctor_card.dart';
import 'package:quickmed/modules/patient/appointment/widgets/time_slot_grid.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/widgets/TButton.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../provider/BookingProvider.dart';
import '../../../data/models/request/BookingRequest.dart';
import '../../provider/DoctorProvider.dart';

class SelectAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic>? doctorData;

  const SelectAppointmentScreen({super.key, this.doctorData});

  @override
  State<SelectAppointmentScreen> createState() =>
      _SelectAppointmentScreenState();
}

class _SelectAppointmentScreenState extends State<SelectAppointmentScreen> {
  DateTime? selectedDate;
  DateTime focusedDay = DateTime.now();
  int? selectedSlotIndex;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _printReceivedData();
  }

  void _printReceivedData() {
    print("=== RECEIVED DOCTOR DATA ===");
    if (widget.doctorData == null) {
      print("❌ No data received (doctorData is null)");
    } else {
      print("✅ Data received:");
      widget.doctorData!.forEach((key, value) {
        print("  $key: $value (${value.runtimeType})");
      });
    }
    print("===========================");
  }

  // Get doctor data from route or use defaults
  int get doctorId => widget.doctorData?['doctorId'] ?? 0;
  String get doctorName => widget.doctorData?['doctorName'] ?? 'Doctor';
  String get specialization =>
      widget.doctorData?['specialization'] ?? 'Specialist';
  String get location => widget.doctorData?['location'] ?? 'Location';
  String get medicalHistory => widget.doctorData?['medicalHistory'] ?? '';
  String get symptoms => widget.doctorData?['symptoms'] ?? '';
  String get imageUrl => widget.doctorData?['imageUrl'] ?? '';
  String get doctorEmail => widget.doctorData?['email'] ?? '';
  String get doctorPhone => widget.doctorData?['phone'] ?? '';
  double get consultationFee =>
      widget.doctorData?['consultationFee']?.toDouble() ?? 0.0;

  @override
  void dispose() {
    super.dispose();
  }

  String _getSelectedDayName() {
    if (selectedDate == null) return '';
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[selectedDate!.weekday - 1];
  }

  bool _isSlotExpired(String slotTime) {
    if (selectedDate == null) return false;

    final now = DateTime.now();
    final isToday = selectedDate!.year == now.year &&
        selectedDate!.month == now.month &&
        selectedDate!.day == now.day;

    if (!isToday) return false;

    try {
      final timeParts = slotTime.split(':');
      final slotHour = int.parse(timeParts[0]);
      final slotMinute = int.parse(timeParts[1]);

      final slotDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        slotHour,
        slotMinute,
      );

      const bufferMinutes = 30;
      final slotWithBuffer =
      slotDateTime.subtract(Duration(minutes: bufferMinutes));

      return now.isAfter(slotWithBuffer);
    } catch (e) {
      print('❌ Error parsing slot time: $e');
      return false;
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(this.selectedDate, selectedDay)) {
      setState(() {
        this.selectedDate = selectedDay;
        this.focusedDay = focusedDay;
        selectedSlotIndex = null; // Reset slot selection
      });

      _fetchAvailableSlots();
    }
  }

  Future<void> _fetchAvailableSlots() async {
    if (selectedDate == null || doctorId == 0) return;

    final doctorProvider = context.read<DoctorProvider>();
    final formattedDate = _formatDateForAPI(selectedDate!);

    print(
      '📅 Fetching slots for doctor $doctorId on $formattedDate (${_getSelectedDayName()})',
    );

    await doctorProvider.getAvailableSlots(doctorId.toString(), formattedDate);
  }

  String _formatDateTime() {
    if (selectedDate == null || selectedSlotIndex == null) return '';

    final doctorProvider = context.read<DoctorProvider>();
    final slotsResponse = doctorProvider.availableSlots;

    if (slotsResponse == null) return '';

    final availableSlots = slotsResponse.slots
        .where((slot) => slot.isAvailable && !_isSlotExpired(slot.time))
        .toList();

    if (selectedSlotIndex! >= availableSlots.length) return '';

    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final dayName = days[selectedDate!.weekday - 1];

    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final monthName = months[selectedDate!.month - 1];

    final timeSlot = availableSlots[selectedSlotIndex!];
    final displayTime = timeSlot.displayTime;

    return '$dayName ${selectedDate!.day}${_getDaySuffix(selectedDate!.day)} $monthName $displayTime';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _formatDateForAPI(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _getSelectedSlotTime() {
    if (selectedSlotIndex == null) return '';

    final doctorProvider = context.read<DoctorProvider>();
    final slotsResponse = doctorProvider.availableSlots;

    if (slotsResponse == null) return '';

    final availableSlots = slotsResponse.slots
        .where((slot) => slot.isAvailable && !_isSlotExpired(slot.time))
        .toList();

    if (selectedSlotIndex! >= availableSlots.length) return '';

    return availableSlots[selectedSlotIndex!].time;
  }

  Future<void> _handleContinue() async {
    if (selectedDate == null) {
      _showSnackBar('Please select an appointment date', isError: true);
      return;
    }

    if (selectedSlotIndex == null) {
      _showSnackBar('Please select a time slot', isError: true);
      return;
    }

    if (doctorId == 0) {
      _showSnackBar('Invalid doctor selection', isError: true);
      return;
    }

    setState(() {
      _isBooking = true;
    });

    try {
      final bookingProvider = context.read<BookingProvider>();

      final bookingRequest = BookingRequest(
        doctorId: doctorId,
        medicalHistory: medicalHistory,
        currentSymptoms: symptoms,
        date: _formatDateForAPI(selectedDate!),
        time: _getSelectedSlotTime(),
      );

      print('📝 Creating booking with request: ${bookingRequest.toJson()}');

      final success = await bookingProvider.createBooking(bookingRequest);

      if (!mounted) return;

      if (success) {
        final booking = bookingProvider.currentBooking;

        final successData = {
          'doctorName': doctorName,
          'specialization': specialization,
          'dateTime': _formatDateTime(),
          'location': location,
          'booking': booking,
          'patientName': booking?.patientName ?? '',
          'status': booking?.status ?? 'pending',
          'bookingId': booking?.id ?? 0,
        };

        context.pushReplacement(
          '/appointmentSuccessScreen',
          extra: successData,
        );
      } else {
        _showSnackBar(
          bookingProvider.errorMessage ?? 'Failed to create booking',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;
      print('❌ Error in _handleContinue: $e');
      _showSnackBar('An error occurred: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildNoAppointmentsWidget(bool isDark, String dayName, bool isToday) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.grey.shade800, Colors.grey.shade900]
              : [Colors.blue.shade50, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.blue.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade700 : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 48,
              color: isDark ? Colors.grey.shade500 : Colors.blue.shade400,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "No Appointments Available",
            style: TAppTextStyle.inter(
              fontSize: 20,
              weight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.grey.shade900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            isToday
                ? "The doctor has no appointments scheduled for today"
                : "The doctor is not available on $dayName",
            textAlign: TextAlign.center,
            style: TAppTextStyle.inter(
              fontSize: 15,
              weight: FontWeight.w500,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.shade800.withOpacity(0.5)
                  : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: isDark ? Colors.grey.shade400 : Colors.blue.shade700,
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Please choose another date from the calendar",
                    style: TAppTextStyle.inter(
                      fontSize: 13,
                      weight: FontWeight.w400,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllSlotsBookedWidget(bool isDark, bool isToday) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange.shade50, Colors.red.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy,
              size: 48,
              color: Colors.orange.shade600,
            ),
          ),
          SizedBox(height: 20),
          Text(
            isToday ? "No More Slots Today" : "All Slots Booked",
            style: TAppTextStyle.inter(
              fontSize: 20,
              weight: FontWeight.w700,
              color: Colors.orange.shade900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            isToday
                ? "All available time slots for today have passed or are fully booked"
                : "All time slots for the selected date are already booked",
            textAlign: TextAlign.center,
            style: TAppTextStyle.inter(
              fontSize: 15,
              weight: FontWeight.w500,
              color: Colors.orange.shade800,
            ),
          ),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.orange.shade700),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Try selecting a different date from the calendar",
                    style: TAppTextStyle.inter(
                      fontSize: 13,
                      weight: FontWeight.w400,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                /// Back Button
                GestureDetector(
                  onTap: _isBooking ? null : () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: _isBooking
                            ? (isDark ? Colors.white38 : Colors.black38)
                            : (isDark ? Colors.white : Colors.black),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Go Back",
                        style: TAppTextStyle.inter(
                          fontSize: 16,
                          weight: FontWeight.w500,
                          color: _isBooking
                              ? (isDark ? Colors.white38 : Colors.black38)
                              : (isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                /// Title
                Center(
                  child: Text(
                    "Book Appointment",
                    style: TAppTextStyle.inter(
                      fontSize: 20,
                      weight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// Selected Doctor Label
                Text(
                  "Selected Doctor",
                  style: TAppTextStyle.inter(
                    fontSize: 16,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 12),
                //
                // /// Doctor Card Widget
                // DoctorCard(
                //   name: doctorName,
                //   speciality: specialization,
                //   miles: location,
                //   onDirectionTap: () {
                //     context.push(
                //       '/getDirectionScreen',
                //       extra: {
                //         'doctorName': doctorName,
                //         'location': location,
                //         'specialization': specialization,
                //       },
                //     );
                //   },
                // ),
                /// Doctor Card Widget
                DoctorCard(
                  name: doctorName,
                  speciality: specialization,
                  miles: location,
                  onDirectionTap: () {
                    context.push(
                      '/getDirectionScreen',
                      extra: {
                        'doctorName': doctorName,
                        'location': location,
                        'specialization': specialization,
                        'latitude': widget.doctorData?['latitude'],
                        'longitude': widget.doctorData?['longitude'],
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),

                /// Calendar Section
                Text(
                  "Select Appointment Date",
                  style: TAppTextStyle.inter(
                    fontSize: 16,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                /// Calendar Widget
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(Duration(days: 365)),
                    focusedDay: focusedDay,
                    selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: _isBooking ? null : _onDaySelected,
                    onPageChanged: (focusedDay) {
                      this.focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      // Today
                      todayDecoration: BoxDecoration(
                        color: QColors.newPrimary500.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      // Selected day
                      selectedDecoration: BoxDecoration(
                        color: QColors.newPrimary500,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      // Default days
                      defaultTextStyle: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      // Weekend days
                      weekendTextStyle: TextStyle(
                        color: isDark ? Colors.red.shade300 : Colors.red,
                      ),
                      // Outside days (previous/next month)
                      outsideDaysVisible: false,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TAppTextStyle.inter(
                        fontSize: 17,
                        weight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                      weekendStyle: TextStyle(
                        color: isDark ? Colors.red.shade300 : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Disable past dates
                    enabledDayPredicate: (day) {
                      return day.isAfter(
                        DateTime.now().subtract(Duration(days: 1)),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                /// Time Slots Label
                Text(
                  "Available Time Slots",
                  style: TAppTextStyle.inter(
                    fontSize: 16,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                /// Time Slots Section with Consumer
                Consumer<DoctorProvider>(
                  builder: (context, doctorProvider, child) {
                    // Show message if no date selected
                    if (selectedDate == null) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey[800]
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? Colors.grey[700]!
                                : Colors.blue.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 24,
                              color: isDark
                                  ? Colors.blue.shade300
                                  : Colors.blue.shade700,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Tap a date on the calendar to view available time slots",
                                style: TAppTextStyle.inter(
                                  fontSize: 14,
                                  weight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.blue.shade300
                                      : Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Show loading state
                    if (doctorProvider.isSlotsLoading) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                color: QColors.newPrimary500,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Loading available slots...",
                                style: TAppTextStyle.inter(
                                  fontSize: 14,
                                  weight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Show error state
                    if (doctorProvider.slotsErrorMessage != null) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              doctorProvider.slotsErrorMessage ??
                                  'Failed to load slots',
                              textAlign: TextAlign.center,
                              style: TAppTextStyle.inter(
                                fontSize: 14,
                                weight: FontWeight.w500,
                                color: Colors.red.shade900,
                              ),
                            ),
                            SizedBox(height: 12),
                            QButton(
                              text: 'Retry',
                              backgroundColor: Colors.red,
                              height: 48,
                              width: 200,
                              onPressed: _fetchAvailableSlots,
                            ),
                          ],
                        ),
                      );
                    }

                    // Get slots data
                    final slotsResponse = doctorProvider.availableSlots;
                    final now = DateTime.now();
                    final isToday = selectedDate!.year == now.year &&
                        selectedDate!.month == now.month &&
                        selectedDate!.day == now.day;
                    final dayName = _getSelectedDayName();

                    // Case 1: NO APPOINTMENTS
                    if (slotsResponse == null || slotsResponse.slots.isEmpty) {
                      return _buildNoAppointmentsWidget(
                        isDark,
                        dayName,
                        isToday,
                      );
                    }

                    // Filter available slots
                    final availableSlots = slotsResponse.slots
                        .where(
                          (slot) =>
                      slot.isAvailable && !_isSlotExpired(slot.time),
                    )
                        .toList();

                    // Case 2: ALL SLOTS BOOKED
                    if (availableSlots.isEmpty) {
                      return _buildAllSlotsBookedWidget(isDark, isToday);
                    }

                    // Case 3: SHOW AVAILABLE SLOTS
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.green,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "${availableSlots.length} available slot${availableSlots.length > 1 ? 's' : ''}",
                                style: TAppTextStyle.inter(
                                  fontSize: 13,
                                  weight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${slotsResponse.durationMinutes} min each",
                                style: TAppTextStyle.inter(
                                  fontSize: 13,
                                  weight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Show today's info message
                        if (isToday)
                          Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: Colors.blue.shade700,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Showing available slots for today (past times excluded)",
                                    style: TAppTextStyle.inter(
                                      fontSize: 12,
                                      weight: FontWeight.w400,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        /// Time Slot Grid
                        TimeSlotGrid(
                          slots: availableSlots
                              .map((slot) => slot.displayTime)
                              .toList(),
                          selectedSlotIndex: selectedSlotIndex,
                          onSlotSelected: _isBooking
                              ? null
                              : (index) {
                            setState(() {
                              selectedSlotIndex = index;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 30),

                /// Continue Button
                QButton(
                  text: _isBooking ? "Creating Appointment..." : "Continue",
                  onPressed: _isBooking ? null : _handleContinue,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}