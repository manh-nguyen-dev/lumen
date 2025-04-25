import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../models/notes_model.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreen();
}

class _NoteDetailScreen extends State<NoteDetailScreen> {
  late QuillController _controller;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();
  late bool _isPinned;

  @override
  void initState() {
    super.initState();

    _isPinned = widget.note.isPinned;

    Document doc;
    try {
      final jsonContent = jsonDecode(widget.note.content);
      doc = Document.fromJson(jsonContent);
    } catch (_) {
      doc = Document()..insert(0, widget.note.content);
    }

    _controller = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  Future<void> _saveNote() async {
    final updatedContent = jsonEncode(_controller.document.toDelta().toJson());
    setState(() {
      widget.note.content = updatedContent;
      widget.note.isPinned = _isPinned;
      widget.note.createdAt = DateTime.now();
    });

    await widget.note.save();

    if (!context.mounted) return;
    Navigator.pop(context, widget.note);
  }


  void _togglePin() {
    setState(() {
      _isPinned = !_isPinned;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorScrollController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Align(
          alignment: Alignment.topLeft,
          child: Text('Chi tiết ghi chú'),
        ),
        actions: [
          IconButton(
            icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            tooltip: _isPinned ? 'Bỏ ghim' : 'Ghim ghi chú',
            onPressed: _togglePin,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Lưu',
            onPressed: _saveNote,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: QuillEditor(
                controller: _controller,
                scrollController: _editorScrollController,
                focusNode: _editorFocusNode,
                config: const QuillEditorConfig(
                  placeholder: 'Nhập ghi chú...',
                  padding: EdgeInsets.all(16),
                ),
              ),
            ),
            QuillSimpleToolbar(
              controller: _controller,
              config: const QuillSimpleToolbarConfig(showClipboardPaste: true),
            ),
          ],
        ),
      ),
    );
  }
}