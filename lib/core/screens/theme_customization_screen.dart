import 'package:flutter/material.dart';

class ThemeCustomizationScreen extends StatefulWidget {
  const ThemeCustomizationScreen({super.key});

  @override
  State<ThemeCustomizationScreen> createState() =>
      _ThemeCustomizationScreenState();
}

class _ThemeCustomizationScreenState extends State<ThemeCustomizationScreen> {
  final List<Color> _pureColors = [
    const Color(0xFF4A6572), // Default gray
    const Color(0xFFE57373), // Red
    const Color(0xFFF06292), // Pink
    const Color(0xFFBA68C8), // Purple
    const Color(0xFF9575CD), // Deep Purple
    const Color(0xFF7986CB), // Indigo
    const Color(0xFF64B5F6), // Blue
    const Color(0xFF4FC3F7), // Light Blue
    const Color(0xFF4DD0E1), // Cyan
    const Color(0xFF4DB6AC), // Teal
    const Color(0xFF81C784), // Green
    const Color(0xFFAED581), // Light Green
    const Color(0xFFDCE775), // Lime
    const Color(0xFFFFD54F), // Yellow
    const Color(0xFFFFB74D), // Orange
    const Color(0xFFFF8A65), // Deep Orange
  ];

  final List<Color> _pastelColors = [
    const Color(0xFFFFC1CC), // Pastel Pink
    const Color(0xFFFFE4B5), // Moccasin / Pastel Orange
    const Color(0xFFB0E0E6), // Powder Blue
    const Color(0xFFE0BBE4), // Pastel Purple
    const Color(0xFFFFFACD), // Lemon Chiffon
    const Color(0xFFD5F5E3), // Mint
    const Color(0xFFFFDAB9), // Peach Puff
    const Color(0xFFFFF0F5), // Lavender Blush
  ];

  final List<Color> _uniqueArtColors = [
    Color(0xFF53A2BE), // Glacier Blue
    Color(0xFFF25C54), // Coral Red
    Color(0xFFB5E2FA), // Baby Ice
    Color(0xFFF7C59F), // Soft Apricot
    Color(0xFF9B5094), // Deep Mauve
    Color(0xFFEEC170), // Honey Glow
  ];

  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = _pureColors.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Align(alignment: Alignment.topLeft, child: Text('Chủ đề')),
        backgroundColor: _selectedColor,
      ),
      body: Column(
        children: [
          _buildColorGroup("Màu tinh khiết", _pureColors),
          _buildColorGroup("Màu Pastel", _pastelColors),
          _buildColorGroup("Màu nghệ thuật", _uniqueArtColors),
        ],
      ),
    );
  }

  Widget _buildColorGroup(String title, List<Color> colors) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final color = colors[index];
              final isSelected = color == _selectedColor;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border:
                        isSelected
                            ? Border.all(color: Colors.black, width: 3)
                            : null,
                  ),
                  child:
                      isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
