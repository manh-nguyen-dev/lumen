import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/routes/routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/enums.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/document_helper.dart' show DocumentHelper;
import '../models/notes_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with TickerProviderStateMixin {
  final TextEditingController _noteController = TextEditingController();
  late Box<NoteModel> notesBox;
  bool _isExpanded = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _openNotesBox();
  }

  Future<void> _openNotesBox() async {
    notesBox = await Hive.openBox<NoteModel>(AppConstants.notesBox);
    setState(() {
      _isLoading = false;
    });
  }

  void _cancelNote() {
    setState(() {
      _noteController.clear();
      _isExpanded = false;
    });
  }

  void _saveNote() {
    final content = _noteController.text.trim();
    if (content.isNotEmpty) {
      setState(() {
        notesBox.add(
          NoteModel(
            id: notesBox.length,
            content: content,
            createdAt: DateTime.now(),
          ),
        );
        _noteController.clear();
        _isExpanded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary.withValues(alpha: .2),
      drawer: _buildProjectsDrawer(context),
      appBar: AppBar(
        backgroundColor: AppColors.lightPrimary.withValues(alpha: .2),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
            ),
            const SizedBox(width: 4),
            const Text("Lumen", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              switch (value) {
                case 'view-type':
                  break;
                case 'view-list':
                  break;
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'select',
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(LucideIcons.fileCheck, size: 18),
                        Text('Lựa chọn'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'view-list',
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(LucideIcons.listFilter, size: 18),
                        Text('Xem danh sách'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'view-type',
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(LucideIcons.type, size: 18),
                        Text('Loại'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Stack(
                children: [
                  TextField(
                    controller: _noteController,
                    onTap: () {
                      setState(() {
                        _isExpanded = true;
                      });
                    },
                    maxLines: _isExpanded ? 5 : 1,
                    decoration: InputDecoration(
                      hintText: "Ghi chú nhanh tại đây",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                  if (_isExpanded)
                    Positioned(
                      bottom: 4,
                      right: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: _cancelNote,
                            child: const Text("Huỷ bỏ"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _saveNote,
                            child: const Text("Lưu"),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ValueListenableBuilder(
                        valueListenable: notesBox.listenable(),
                        builder: (context, Box<NoteModel> box, _) {
                          final notes = box.values.toList().reversed.toList();
                          return MasonryGridView.count(
                            padding: EdgeInsets.zero,
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push(Routes.noteDetail, extra: note);
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            IgnorePointer(
                                              ignoring: true,
                                              child: QuillEditor.basic(
                                                controller: QuillController(
                                                  document:
                                                      DocumentHelper.parseFromContent(
                                                        note.content,
                                                      ),
                                                  selection:
                                                      const TextSelection.collapsed(
                                                        offset: 0,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '${note.createdAt.hour}:${note.createdAt.minute.toString().padLeft(2, '0')} - ${note.createdAt.day}/${note.createdAt.month}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (note.isPinned)
                                          Positioned(
                                            top: -18,
                                            right: -20,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFFFE0B2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.push_pin,
                                                size: 16,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsDrawer(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Lumen',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: noteTypes.length,
                itemBuilder: (context, index) {
                  final type = noteTypes[index];
                  return _buildTypeItem(context, type);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeItem(BuildContext context, NoteType type) {
    return ListTile(
      leading: Icon(type.icon),
      title: Text(type.label),
      // trailing: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Container(
      //       width: 12,
      //       height: 12,
      //       decoration: BoxDecoration(
      //         color: Colors.red,
      //         shape: BoxShape.circle,
      //       ),
      //     ),
      //   ],
      // ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
