



import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/request/UpdateWorkingHoursRequest.dart';
import '../../../data/models/request/UpdateWorkingHoursRequest12.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/widgets/TButton.dart';
import '../../provider/DoctorProvider.dart';

class UpdateAvailabilityScreen extends StatefulWidget {
  const UpdateAvailabilityScreen({super.key});

  @override
  State<UpdateAvailabilityScreen> createState() => _UpdateAvailabilityScreenState();
}

class _UpdateAvailabilityScreenState extends State<UpdateAvailabilityScreen> {
  static const String WORKING_HOURS_KEY = 'doctor_working_hours';

  // Store working hours by date
  Map<String, DateWorkingHours> _workingHoursByDate = {};
  bool _isLoadingData = true;
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(Duration(days: 30));

  @override
  void initState() {
    super.initState();
    _loadExistingWorkingHours();
  }

  /// Load working hours from SharedPreferences
  Future<void> _loadExistingWorkingHours() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getString(WORKING_HOURS_KEY);

      if (storedData != null) {
        print('📂 Loading working hours from SharedPreferences');
        final Map<String, dynamic> decodedData = json.decode(storedData);

        setState(() {
          decodedData.forEach((dateStr, dayData) {
            _workingHoursByDate[dateStr] = DateWorkingHours(
              date: DateTime.parse(dateStr),
              isWorking: dayData['isWorking'] ?? false,
              startTime: dayData['startTime'] != null
                  ? _parseTime(dayData['startTime'])
                  : TimeOfDay(hour: 9, minute: 0),
              endTime: dayData['endTime'] != null
                  ? _parseTime(dayData['endTime'])
                  : TimeOfDay(hour: 17, minute: 0),
            );
          });
          _isLoadingData = false;
        });

        print('✅ Loaded ${_workingHoursByDate.length} working hour entries');
      } else {
        print('ℹ️ No stored working hours found');
        setState(() {
          _isLoadingData = false;
        });
      }
    } catch (e) {
      print('❌ Error loading working hours: $e');
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  /// Save working hours to SharedPreferences
  Future<void> _saveToSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic> dataToStore = {};
      _workingHoursByDate.forEach((dateStr, workingHours) {
        dataToStore[dateStr] = {
          'isWorking': workingHours.isWorking,
          'startTime': workingHours.isWorking
              ? _formatTimeForApi(workingHours.startTime)
              : null,
          'endTime': workingHours.isWorking
              ? _formatTimeForApi(workingHours.endTime)
              : null,
        };
      });

      final jsonString = json.encode(dataToStore);
      await prefs.setString(WORKING_HOURS_KEY, jsonString);

      print('💾 Working hours saved to SharedPreferences');
    } catch (e) {
      print('❌ Error saving to SharedPreferences: $e');
    }
  }

  /// Clear working hours from SharedPreferences
  Future<void> _clearSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(WORKING_HOURS_KEY);
      print('🗑️ Working hours cleared from SharedPreferences');
    } catch (e) {
      print('❌ Error clearing SharedPreferences: $e');
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Working Hours",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Clear All Data'),
                  content: Text('This will remove all stored working hours. Continue?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _clearSharedPreferences();
                        setState(() {
                          _workingHoursByDate.clear();
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('All working hours cleared'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Clear'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Clear stored data',
          ),
        ],
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, provider, child) {
          if (_isLoadingData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading saved working hours...'),
                ],
              ),
            );
          }

          if (provider.isWorkingHoursLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Updating working hours...'),
                ],
              ),
            );
          }

          return             SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Set Your Working Schedule",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Add specific dates and configure your working hours",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Show error if any
                  if (provider.workingHoursErrorMessage != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              provider.workingHoursErrorMessage!,
                              style: TextStyle(color: Colors.red.shade900),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, size: 18),
                            onPressed: () {
                              provider.clearWorkingHoursError();
                            },
                          ),
                        ],
                      ),
                    ),

                  // Show success message if available
                  if (provider.hasWorkingHoursData && provider.userProfileResponse != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Working hours updated successfully for Dr. ${provider.userProfileResponse!.firstName} ${provider.userProfileResponse!.lastName}',
                              style: TextStyle(color: Colors.green.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),

                  /// ---------------- DATE RANGE SELECTOR ----------------
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Generate Schedule',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDateSelector(
                                  label: 'Start Date',
                                  date: _selectedStartDate,
                                  onTap: () => _selectStartDate(),
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.arrow_forward, color: Colors.grey),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildDateSelector(
                                  label: 'End Date',
                                  date: _selectedEndDate,
                                  onTap: () => _selectEndDate(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _generateDateRange,
                            icon: Icon(Icons.auto_awesome),
                            label: Text('Generate Dates'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 45),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  /// ---------------- ADD SINGLE DATE BUTTON ----------------
                  OutlinedButton.icon(
                    onPressed: _addSingleDate,
                    icon: Icon(Icons.add_circle_outline),
                    label: Text('Add Single Date'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45),
                    ),
                  ),

                  SizedBox(height: 24),

                  /// ---------------- WORKING HOURS LIST ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Configured Dates (${_workingHoursByDate.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_workingHoursByDate.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _workingHoursByDate.clear();
                            });
                          },
                          icon: Icon(Icons.clear_all, size: 18),
                          label: Text('Clear All'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12),

                  if (_workingHoursByDate.isEmpty)
                    Container(
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 48,
                                color: Colors.grey.shade400
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No dates configured yet',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Add dates to set your working hours',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._buildDateCards(),

                  SizedBox(height: 32),

                  /// ---------------- SAVE BUTTON ----------------
                  QButton(
                    text: 'Save Working Hours',
                    onPressed: _workingHoursByDate.isEmpty ? null : _saveWorkingHours,
                  ),

                  SizedBox(height: 26),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// ---------------- DATE SELECTOR WIDGET ----------------
  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, yyyy').format(date),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- DATE CARDS ----------------
  List<Widget> _buildDateCards() {
    final sortedDates = _workingHoursByDate.keys.toList()
      ..sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));

    return sortedDates.map((dateStr) {
      final workingHours = _workingHoursByDate[dateStr]!;
      final date = workingHours.date;
      final dayName = DateFormat('EEEE').format(date);

      return Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: workingHours.isWorking ? Colors.green.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: workingHours.isWorking ? Colors.green.shade300 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            // Date header with toggle
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMM dd, yyyy').format(date),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: workingHours.isWorking
                                ? Colors.green.shade900
                                : Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          dayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        workingHours.isWorking ? 'Working' : 'Off',
                        style: TextStyle(
                          fontSize: 14,
                          color: workingHours.isWorking
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Switch(
                        value: workingHours.isWorking,
                        onChanged: (value) {
                          setState(() {
                            _workingHoursByDate[dateStr] = DateWorkingHours(
                              date: workingHours.date,
                              isWorking: value,
                              startTime: workingHours.startTime,
                              endTime: workingHours.endTime,
                            );
                          });
                        },
                        activeColor: Colors.green,
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _workingHoursByDate.remove(dateStr);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Date removed'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Time pickers (only shown if working)
            if (workingHours.isWorking)
              Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTimePicker(
                        label: 'Start',
                        time: workingHours.startTime,
                        onTap: () => _selectTime(dateStr, isStart: true),
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.arrow_forward, color: Colors.grey),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTimePicker(
                        label: 'End',
                        time: workingHours.endTime,
                        onTap: () => _selectTime(dateStr, isStart: false),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }).toList();
  }

  /// ---------------- TIME PICKER WIDGET ----------------
  Widget _buildTimePicker({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatTimeOfDay(time),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Icon(Icons.access_time, color: Colors.grey.shade600, size: 20),
          ],
        ),
      ),
    );
  }

  /// ---------------- SELECT START DATE ----------------
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
        // Ensure end date is after start date
        if (_selectedEndDate.isBefore(_selectedStartDate)) {
          _selectedEndDate = _selectedStartDate.add(Duration(days: 7));
        }
      });
    }
  }

  /// ---------------- SELECT END DATE ----------------
  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: _selectedStartDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  /// ---------------- GENERATE DATE RANGE ----------------
  void _generateDateRange() {
    if (_selectedEndDate.isBefore(_selectedStartDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('End date must be after start date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      DateTime currentDate = _selectedStartDate;
      while (currentDate.isBefore(_selectedEndDate) ||
          currentDate.isAtSameMomentAs(_selectedEndDate)) {
        String dateStr = _formatDate(currentDate);

        // Only add if not already exists
        if (!_workingHoursByDate.containsKey(dateStr)) {
          _workingHoursByDate[dateStr] = DateWorkingHours(
            date: currentDate,
            isWorking: true,
            startTime: TimeOfDay(hour: 9, minute: 0),
            endTime: TimeOfDay(hour: 17, minute: 0),
          );
        }

        currentDate = currentDate.add(Duration(days: 1));
      }
    });

    final daysGenerated = _selectedEndDate.difference(_selectedStartDate).inDays + 1;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generated $daysGenerated dates'),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// ---------------- ADD SINGLE DATE ----------------
  Future<void> _addSingleDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      String dateStr = _formatDate(picked);

      if (_workingHoursByDate.containsKey(dateStr)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('This date is already added'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() {
        _workingHoursByDate[dateStr] = DateWorkingHours(
          date: picked,
          isWorking: true,
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Date added: ${DateFormat('MMM dd, yyyy').format(picked)}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// ---------------- SELECT TIME ----------------
  Future<void> _selectTime(String dateStr, {required bool isStart}) async {
    DateWorkingHours workingHours = _workingHoursByDate[dateStr]!;
    TimeOfDay initialTime = isStart ? workingHours.startTime : workingHours.endTime;

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        _workingHoursByDate[dateStr] = DateWorkingHours(
          date: workingHours.date,
          isWorking: workingHours.isWorking,
          startTime: isStart ? picked : workingHours.startTime,
          endTime: isStart ? workingHours.endTime : picked,
        );
      });
    }
  }

  /// ---------------- SAVE WORKING HOURS ----------------
  Future<void> _saveWorkingHours() async {
    if (_workingHoursByDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one date'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate time slots
    for (var entry in _workingHoursByDate.entries) {
      if (entry.value.isWorking) {
        if (!_isValidTimeSlot(entry.value.startTime, entry.value.endTime)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${entry.key}: End time must be after start time'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    // Save to SharedPreferences
    await _saveToSharedPreferences();

    // Convert to API format
    List<WorkingHours> workingHoursList = _workingHoursByDate.entries.map((entry) {
      DateWorkingHours workingHours = entry.value;
      return WorkingHours(
        date: entry.key,
        startTime: workingHours.isWorking
            ? _formatTimeForApi(workingHours.startTime)
            : '00:00:00',
        endTime: workingHours.isWorking
            ? _formatTimeForApi(workingHours.endTime)
            : '00:00:00',
        isWorking: workingHours.isWorking,
      );
    }).toList();

    if (kDebugMode) {
      print('📅 Sending ${workingHoursList.length} working hour entries');
    }

    // Create request and call API
    final request = UpdateWorkingHoursRequest12(workingHours: workingHoursList);
    final provider = context.read<DoctorProvider>();
    await provider.updateDoctorWorkingHours(request);

    if (!mounted) return;

    if (provider.workingHoursStatus == WorkingHoursStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Working hours updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          AppRouter.router.push('/availabilityUpdatedScreen');
        }
      });
    } else if (provider.hasWorkingHoursError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update working hours'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _saveWorkingHours(),
          ),
        ),
      );
    }
  }

  /// ---------------- HELPER METHODS ----------------
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatTimeForApi(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  bool _isValidTimeSlot(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes > startMinutes;
  }
}

/// ---------------- DATE WORKING HOURS MODEL ----------------
class DateWorkingHours {
  final DateTime date;
  final bool isWorking;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  DateWorkingHours({
    required this.date,
    required this.isWorking,
    required this.startTime,
    required this.endTime,
  });
}