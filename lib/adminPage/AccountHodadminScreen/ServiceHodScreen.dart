import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../oderManagement/OderManagement.dart';
import '../oderManagement/discussion_order_list_screen.dart';
import '../SellReturn/order_agreement_list_screen.dart';

class ServiceHodScreen extends StatelessWidget {
  const ServiceHodScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> options = [

      {
        "title": "Dispatch Order",
        "icon": Icons.local_shipping,
        "color": Colors.blue
      },

      {
        "title": "Order Management",
        "icon": Icons.manage_accounts,
        "color": Colors.green
      },

      {
        "title": "Order Agreement",
        "icon": Icons.description,
        "color": Colors.orange
      },

    ];

    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Service HOD",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),

        child: Container(

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
                "Service Management",
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12.h),

              /// GRID
              GridView.builder(

                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: options.length,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 3,

                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,

                  childAspectRatio: 0.9,
                ),

                itemBuilder: (context, index) {

                  final item = options[index];

                  return InkWell(

                    onTap: () {

                      if (item["title"] == "Dispatch Order") {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DiscussionOrderListScreen(),
                          ),
                        );

                      }

                      if (item["title"] == "Order Management") {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrderManagementPage(),
                          ),
                        );

                      }

                      if (item["title"] == "Order Agreement") {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrderAgreementListScreen(),
                          ),
                        );

                      }

                    },

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
        ),
      ),
    );
  }
}