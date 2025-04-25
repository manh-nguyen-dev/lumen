import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lumen/core/utils/helpers.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/colors.dart';
import '../models/timer_history_model.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late DateTime _startTime;
  int _remainingTime = 3600;
  Timer? _timer;
  bool _isTimerRunning = false;
  bool _isTimerPaused = false;

  String get formattedTime {
    int minutes = (_remainingTime / 60).floor();
    int seconds = _remainingTime % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _calculateTotalCountdownTime(DateTime startTime, DateTime completedAt) {
    final duration = completedAt.difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours giờ $minutes phút $seconds giây';
    } else if (minutes > 0) {
      return '$minutes phút $seconds giây';
    } else {
      return '$seconds giây';
    }
  }

  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
        }
      });
    });
    setState(() {
      _isTimerRunning = true;
      _isTimerPaused = false;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isTimerPaused = true;
    });
  }

  Future<void> _saveTimerHistory(int remainingTime) async {
    final box = await Hive.openBox<TimerHistoryModel>(
      AppConstants.timerHistoryBox,
    );

    final newHistory = TimerHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch,
      minutes: (remainingTime / 60).floor(),
      startTime: _startTime,
      completedAt: DateTime.now(),
    );

    await box.add(newHistory);
  }

  Future<void> _stopTimer({bool forceStop = false}) async {
    if (_remainingTime == 0 || forceStop) {
      await _saveTimerHistory(_remainingTime);
    }

    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isTimerPaused = false;
      _remainingTime = 3600;
    });
  }

  void _changeTime(int minutes) {
    setState(() {
      _remainingTime = minutes * 60;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showEditTimeDialog() async {
    final int? newTime = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int newTimeInMinutes = (_remainingTime / 60).floor();
        return AlertDialog(
          title: const Text('Thay đổi số phút'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newTimeInMinutes = int.tryParse(value) ?? 0;
            },
            decoration: const InputDecoration(labelText: 'Số phút'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, newTimeInMinutes),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );

    if (newTime != null) {
      _changeTime(newTime);
    }
  }

  void _showHistoryDialog() async {
    var box = await Hive.openBox<TimerHistoryModel>(
      AppConstants.timerHistoryBox,
    );
    List<TimerHistoryModel> historyList = [];

    for (var history in box.values) {
      historyList.add(history);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Lịch sử sử dụng đếm ngược',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SizedBox(
            width: 400,
            height: 450,
            child: ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                TimerHistoryModel history = historyList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.green,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Bắt đầu: ${DateTimeHelper.formatDateTime(history.startTime)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Kết thúc: ${DateTimeHelper.formatDateTime(history.completedAt)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                color: Colors.blue,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Tổng thời gian đếm ngược: ${_calculateTotalCountdownTime(history.startTime, history.completedAt)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 10),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Đóng',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary.withValues(alpha: .2),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  CircleTimerCard(time: formattedTime),
                  if (!_isTimerRunning && !_isTimerPaused)
                    ElevatedButton(
                      onPressed: _startTimer,
                      child: const Text('Bắt đầu'),
                    ),
                  if (_isTimerRunning)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: [
                        FloatingActionButton(
                          backgroundColor: AppColors.lightPrimary,
                          onPressed: _pauseTimer,
                          child: const Icon(
                            Icons.pause,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        if (_isTimerRunning || _isTimerPaused)
                          FloatingActionButton(
                            backgroundColor: Colors.red,
                            onPressed: _stopTimer,
                            child: const Icon(
                              Icons.refresh,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  if (_isTimerPaused)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: [
                        FloatingActionButton(
                          backgroundColor: AppColors.lightDisabled,
                          onPressed: _startTimer,
                          child: const Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () => _stopTimer(forceStop: true),
                          child: const Icon(
                            LucideIcons.stopCircle,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (!_isTimerRunning && !_isTimerPaused) ...[
                Positioned(
                  top: 0,
                  right: -36,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        LucideIcons.edit2,
                        size: 24,
                        color: Colors.black54,
                      ),
                      tooltip: 'Chỉnh sửa thời gian',
                      onPressed: _showEditTimeDialog,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: -36,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        LucideIcons.history,
                        size: 24,
                        color: Colors.black54,
                      ),
                      tooltip: 'Xem lịch sử',
                      onPressed: _showHistoryDialog,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CircleTimerCard extends StatelessWidget {
  final String time;
  const CircleTimerCard({required this.time, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(200),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Thời gian còn lại',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            time,
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
