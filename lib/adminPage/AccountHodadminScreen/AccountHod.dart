import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../HomePagelist/addDayBook.dart';
import '../../HomePagelist/dayBookHistory.dart';
import '../Sale/SaleManagementScreen.dart';
import 'AccountHodAddCashier.dart';
import 'BankBook/AccountBankBook.dart';
import 'PURCHASE.dart';

class AccountHodScreen extends StatelessWidget {
  const AccountHodScreen({super.key});

  /// OPTIONS
  static final List<Map<String, dynamic>> _options = [
    {
      "title": "PURCHASE",
      "icon": Icons.shopping_bag,
      "color": Colors.orange,
    },
    {
      "title": "SALE",
      "icon": Icons.point_of_sale,
      "color": Colors.green,
    },
    {
      "title": "CASH BOOK\nHISTORY",
      "icon": Icons.account_balance_wallet,
      "color": Colors.blue,
    },

    {
      "title": "REVENUE",
      "icon": Icons.trending_up,
      "color": Colors.teal,
    },
    {
      "title": "ADD CASHIER",
      "icon": Icons.money,
      "color": Colors.green,
    },

    {
      "title": "Bank Book",
      "icon": Icons.comment_bank,
      "color": Colors.deepPurpleAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      appBar: AppBar(
        title: Text(
          "Account HOD",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: _buildAccountHodSection(context),
      ),
    );
  }

  /// MAIN CONTAINER
  Widget _buildAccountHodSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Text(
            "Account Management",
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10.h),

          /// GRID
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _options.length,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.h,
              childAspectRatio: 0.50,
            ),

            itemBuilder: (context, index) {
              final item = _options[index];

              return InkWell(
                onTap: () => _navigate(context, item["title"]),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    /// ICON CARD
                    Container(
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: (item["color"] as Color).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        item["icon"],
                        size: 32.sp,
                        color: item["color"],
                      ),
                    ),

                    SizedBox(height: 8.h),

                    /// TITLE
                    Text(
                      item["title"],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// NAVIGATION
  void _navigate(BuildContext context, String title) {
    switch (title) {

      case "PURCHASE":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PurchaseManagementPage(),
          ),
        );
        break;

      case "SALE":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SaleManagementPage(),
          ),
        );
        break;

      case "CASH BOOK\nHISTORY":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DayBookHistory(),
          ),
        );
        break;


      case "ADD CASHIER":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CashierScreen (),
          ),
        );
        break;

      case "Bank Book":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AccountBankBook (),
          ),
        );
        break;
    }
  }
}

  /// CARD WIDGET

