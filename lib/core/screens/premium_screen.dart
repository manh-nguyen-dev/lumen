import 'dart:async';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final PageController _pageController = PageController();
  int _selectedPlan = 1;
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> _features = [
    {
      "image": "assets/image/banner1.png",
      "text": "Không quảng cáo, trải nghiệm liền mạch",
    },
    {
      "image": "assets/image/banner2.png",
      "text": "Ghi chú không giới hạn & bảo mật",
    },
    {
      "image": "assets/image/banner3.png",
      "text": "Tùy chỉnh chủ đề và nhắc nhở thông minh",
    },
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _features.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    _pageController.addListener(() {
      final next = _pageController.page?.round() ?? 0;
      if (next != _currentPage) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6EBFF),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Mua gói Premium",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "PRO",
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sub-title
                Text(
                  "Truy cập vào tất cả tính năng cao cấp",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),

                // Carousel
                SizedBox(
                  height: 290,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _features.length,
                    itemBuilder:
                        (_, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 32.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Image.asset(
                                    _features[index]['image']!,
                                    width: double.infinity,
                                    height: 190,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    _features[index]['text']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                ),
                // Page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _features.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            _currentPage == index ? Colors.orange : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Plan options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPlanOption(0, "Hàng tháng", "80.000đ"),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _buildPlanOption(
                            1,
                            "Hàng năm",
                            "765.000đ",
                            discountedPrice: "365.000đ",
                          ),
                          Positioned(
                            top: -8,
                            left: 4,
                            right: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "Tiết kiệm 50%",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      _buildPlanOption(
                        2,
                        "Cả đời",
                        "1.000.000đ",
                        discountedPrice: "695.000đ",
                      ),
                    ],
                  ),
                ),

                Spacer(),
              ],
            ),

            // Bottom Fixed Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightPrimary,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // handle continue
                      },
                      child: Text("Tiếp tục"),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Thanh toán định kỳ, huỷ bất cứ lúc nào",
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanOption(
    int index,
    String title,
    String price, {
    String? discountedPrice,
  }) {
    bool isSelected = _selectedPlan == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = index;
        });
      },
      child: AnimatedContainer(
        height: 150,
        width: 120,
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.orange : Colors.black,
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 13,
                color: discountedPrice != null ? Colors.grey[600] : Colors.red,
                decoration:
                    discountedPrice != null ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (discountedPrice != null)
              Text(
                discountedPrice,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
