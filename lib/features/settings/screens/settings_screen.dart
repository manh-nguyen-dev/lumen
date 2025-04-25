import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen/core/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/routes/routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary.withValues(alpha: .2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildOverviewCard(),
              const SizedBox(height: 24),
              _buildUpgradeCard(context),
              const SizedBox(height: 24),
              _buildSettingsMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tổng quan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(title: 'Ghi chú', value: '12'),
              _StatItem(title: 'Ngày ghi chú', value: '2'),
              _StatItem(title: 'Ngày tập trung', value: '2'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(color: Colors.grey[900]),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nâng cấp lên VIP',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text('Mở khoá tất cả tính năng',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
              foregroundColor: AppColors.lightSurface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => context.push(Routes.premium),
            child: const Text('NÂNG CẤP', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: _cardDecoration(),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _SettingTile(icon: Icons.lock, title: 'Khoá', onTap: () => context.push(Routes.premium)),
          _SettingTile(icon: Icons.color_lens, title: 'Chủ đề', onTap: () => context.push(Routes.themeCustomization)),
          _SettingTile(icon: Icons.dark_mode, title: 'Chế độ tối', onTap: () => _showThemeDialog(context)),
          _SettingTile(
            icon: Icons.calendar_today,
            title: 'Ngày bắt đầu trong tuần',
            onTap: () => _showStartDateOfWeekPicker(context, title: "Ngày bắt đầu trong tuần", initialValue: 2),
          ),
          _SettingTile(
            icon: Icons.privacy_tip,
            title: 'Chính sách bảo mật',
            onTap: () => _launchExternalUrl('https://example.com/', context),
          ),
          _SettingTile(
            icon: Icons.delete_forever,
            title: 'Xoá tất cả ghi chú',
            onTap: () => _showDeleteConfirmationDialog(context),
          ),
          const _SettingTile(icon: Icons.help_outline, title: 'Trợ giúp & Liên hệ'),
          const Divider(),
          const _SettingTile(icon: Icons.info_outline, title: 'Phiên bản: 1.0.0', showArrow: false),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration({Color? color}) => BoxDecoration(
    color: color ?? Colors.white,
    borderRadius: BorderRadius.circular(12),
  );

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Chọn chủ đề'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('Chủ đề tối'),
            _buildThemeOption('Chủ đề ánh sáng'),
            _buildThemeOption('Chủ đề tùy chỉnh'),
            _buildThemeOption('Mặc định hệ thống'),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: label,
      groupValue: '',
      onChanged: (_) {},
    );
  }

  Future<void> _showStartDateOfWeekPicker(
      BuildContext context, {
        required String title,
        required int initialValue,
      }) async {
    int selectedIndex = initialValue;
    await showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 250,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                TextButton(onPressed: () => Navigator.pop(context, selectedIndex), child: const Text('Done')),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: initialValue),
                itemExtent: 60,
                onSelectedItemChanged: (index) => selectedIndex = index,
                children: const [
                  Center(child: Text("Thứ 7")),
                  Center(child: Text("Chủ Nhật")),
                  Center(child: Text("Thứ 2")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchExternalUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if(!context.mounted){
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể mở liên kết $url')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn xoá tất cả ghi chú không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Gọi hàm xoá ở đây
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool showArrow;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    this.showArrow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: showArrow ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
      onTap: onTap,
    );
  }
}
