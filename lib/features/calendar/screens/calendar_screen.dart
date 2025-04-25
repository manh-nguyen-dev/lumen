import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lumen/core/constants/app_constants.dart';
import 'package:lumen/core/theme/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/utils/document_helper.dart';
import '../../notes/models/notes_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late Box<NoteModel> notesBox;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi_VN');
  }

  Future<Box<NoteModel>> _openNotesBox() async {
    // Mở box ghi chú bất đồng bộ
    return await Hive.openBox<NoteModel>(AppConstants.notesBox);
  }

  List<String> _getNotesForDay(DateTime day) {
    final notesForDay =
        notesBox.values.where((note) {
          final noteDate = note.createdAt;
          return noteDate.year == day.year &&
              noteDate.month == day.month &&
              noteDate.day == day.day;
        }).toList();
    return notesForDay.map((note) => note.content).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch & Ghi chú'),
        backgroundColor: AppColors.lightPrimary.withValues(alpha: .2),
        leading: Icon(LucideIcons.calendar),
      ),
      body: FutureBuilder<Box<NoteModel>>(
        future: _openNotesBox(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Không thể mở ghi chú: ${snapshot.error}'),
            );
          }

          notesBox = snapshot.data!;
          final notes = _getNotesForDay(_selectedDay);

          return Column(
            children: [
              TableCalendar(
                locale: 'vi_VN',
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month view',
                },
                headerStyle: HeaderStyle(formatButtonVisible: true),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.lightPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    notes.isEmpty
                        ? const Center(child: Text('Không có ghi chú nào'))
                        : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: notes.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.lightSurface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IgnorePointer(
                                ignoring: true,
                                child: QuillEditor.basic(
                                  controller: QuillController(
                                    document: DocumentHelper.parseFromContent(
                                      notes[index],
                                    ),
                                    selection: const TextSelection.collapsed(
                                      offset: 0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
