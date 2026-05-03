import 'package:bookworld/adminPage/AccountHodadminScreen/purchase_return_list_index_screen.dart';
import 'package:bookworld/adminPage/AccountHodadminScreen/purchase_return_not_for_sale_screen.dart';
import 'package:bookworld/adminPage/AccountHodadminScreen/purchase_sample_revenue_return_screen.dart';
import 'package:bookworld/adminPage/AccountHodadminScreen/purchase_sample_revenue_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../BilingPurchase/purchaseNotForSale.dart';
import '../BilingPurchase/PurchaseSampleRevenew.dart';
import '../BilingPurchase/PurchaseInvoice.dart';
import '../Sale/purchaseHistoryClubView.dart';
import '../Sale/salePurchaseInvoice.dart';
import 'PubchaseEnterInvoice.dart';
import 'PurchaseNotForSaleScreen.dart';

class PurchaseManagementPage extends StatelessWidget {
  const PurchaseManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B46C1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Purchase Management",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [

          /// PURCHASE SECTION
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              title: Text(
                "Purchase",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              children: [

                _purchaseItem(
                  context,
                  1,
                  "Purchase Not For Sale",
                  const PurchaseNotForSaleScreen (),
                ),

                _purchaseItem(
                  context,
                  2,
                  "Purchase Sample Revenue",
                  const PurchaseSampleRevenueScreen (),
                ),

                _purchaseItem(
                  context,
                  3,
                  "Purchase Invoice Individual ",
                  const SalePurchaseInvoiceHistory(),
                ),

                _purchaseItem(
                  context,
                  4,
                  "Purchase Club View ",
                  const SalePurchaseClubInvoiceHistory(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// PURCHASE RETURN SECTION
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: ExpansionTile(
              title: Text(
                "Purchase Return",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              children: [

                _purchaseItem(
                  context,
                  1,
                  "Purchase Return",
                  const  PurchaseReturnListIndexScreen(), // change page
                ),

                _purchaseItem(
                  context,
                  2,
                  "Purchase Return Not For Sale",
                  const PurchaseReturnNotForSaleScreen(), // change page
                ),

                _purchaseItem(
                  context,
                  3,
                  "Purchase Return Sample",
                  const PurchaseSampleRevenueReturnScreen(), // change page
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// PURCHASE ITEM
  Widget _purchaseItem(
      BuildContext context,
      int index,
      String title,
      Widget page,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: InkWell(
        borderRadius: BorderRadius.circular(10),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),

          child: Row(
            children: [

              /// NUMBER BADGE
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF6B46C1),
                  shape: BoxShape.circle,
                ),

                child: Text(
                  index.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// TITLE
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}