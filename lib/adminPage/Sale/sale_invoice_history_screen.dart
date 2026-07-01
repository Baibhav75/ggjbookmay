import 'package:bookworld/adminPage/Sale/sale_details_mrp_screen.dart';
import 'package:bookworld/adminPage/Sale/sale_invoice_details_screen.dart';
import 'package:bookworld/adminPage/Sale/sale_view_mrp_ledger_screen.dart';
import 'package:bookworld/adminPage/Sale/view_agent_discount_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../appDart/discrete_circular_loader.dart';
import '/Model/club_view_model.dart';
import '/Service/club_view_service.dart';
import 'EnterysaleScreen.dart';
import 'SaleLedgerDiscount_screen.dart';
import 'SaleMixReportCompanyPScreen.dart';
import 'SaleMixReportOrderPendingScreen.dart';
import 'SaleMixReportScreen.dart';

class SaleInvoiceClubHistoryScreen extends StatefulWidget {
  const SaleInvoiceClubHistoryScreen({super.key});
//history file
  @override
  State<SaleInvoiceClubHistoryScreen> createState() =>
      _SaleInvoiceClubHistoryScreenState();
}

class _SaleInvoiceClubHistoryScreenState
    extends State<SaleInvoiceClubHistoryScreen> {

  List<ClubViewItem> list = [];
  List<ClubViewItem> filteredList = [];

  bool isClubView = true;
  bool isLoading = true;
  double grandTotal = 0;
  double totalReturn = 0;
  double netSale = 0;
  int totalBills = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void loadData() async {
    final res = await ClubViewService.fetchClubView();

    if (res != null) {
      setState(() {
        list = res.data;
        filteredList = res.data;
        totalBills = res.totalParties;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void search(String value) {
    setState(() {
      filteredList = list.where((item) {
        return item.partyName
            .toLowerCase()
            .contains(value.toLowerCase()) ||
            item.schoolId
                .toLowerCase()
                .contains(value.toLowerCase());
      }).toList();
    });
  }

  String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "-";
    try {
      DateTime dt = DateTime.parse(rawDate);
      return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
    } catch (e) {
      return rawDate;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B46C1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Sale Club View History ",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        // 👇 Add this section
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.white),
            tooltip: "Add Sale",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SaleInvoiceEntry(), // your screen
                ),
              );
            },
          ),
        ],
      ),

      body: Stack(
        children: [

          /// 🔶 MAIN UI (ALWAYS RENDER)
          Column(
            children: [
              // 🔥 SUMMARY CARD (TOP)
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6B46C1), Color(0xFF9F7AEA)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.spaceBetween,
                    children: [

                      summaryItem("Total Bills", "$totalBills"),
                      summaryItem("Total Return", "₹ ${totalReturn.toStringAsFixed(2)}"),
                      summaryItem("Net Sale", "₹ ${netSale.toStringAsFixed(2)}"),

                    ],
                  )
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [

                    /// 🔍 SEARCH FIELD
                    Expanded(
                      flex: 3,
                      child: TextField(
                        onChanged: search,
                        decoration: InputDecoration(
                          hintText: "Search Bill No / School",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// 🔁 TOGGLE BUTTON

                  ],
                ),
              ),

              /// 🔥 TABLE
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 680,
                    child: Column(
                      children: [

                        /// HEADER
                        Container(
                            color: Colors.deepPurple.shade100,
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                SizedBox(width: 60, child: Text("Sr No")),
                                // ✅ ADD
                                SizedBox(width: 260, child: Text("School")),
                                SizedBox(width: 160, child: Text("Amount")),
                                SizedBox(width: 80, child: Text("View")),
                              ],
                            )
                        ),

                        /// LIST
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SaleViewMRPLedgerScreen(
                                        schoolId: item.schoolId,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 60, child: Text("${index + 1}")),
                                      SizedBox(width: 260, child: Text(item.partyName)),
                                      SizedBox(
                                        width: 160,
                                        child: Text("₹ ${item.totalAmount.toStringAsFixed(2)}"),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: PopupMenuButton<String>(
                                          onSelected: (value) {
                                            switch (value) {

                                              case "mrp":
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => SaleDetailsMrpScreen(
                                                      billNo: item.billNo,
                                                    ),
                                                  ),
                                                );
                                                break;

                                              case "discount":
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => SaleInvoiceDetailsScreen(
                                                      billNo: item.billNo,
                                                    ),
                                                  ),
                                                );
                                                break;

                                              case "MRP_ledger":
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>  SaleViewMRPLedgerScreen(
                                                      schoolId: item.schoolId,
                                                    ),
                                                  ),
                                                );
                                                break;

                                              case "Discount":
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>  SaleLedgerDiscountScreen(
                                                      schoolId: item.schoolId,
                                                    ),
                                                  ),
                                                );
                                                break;
                                              case "mix":
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>  SaleMixReportScreen(
                                                      schoolId: item.schoolId,
                                                    ),
                                                  ),
                                                );
                                                break;

                                              case "pending_mix":
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>  SalePendingMixOrderScreen (
                                                      schoolId: item.schoolId,
                                                    ),
                                                  ),
                                                );
                                                break;

                                              case "company_mix":
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => SaleMixReportCompanyPScreen (
                                                      schoolId: item.schoolId,
                                                    ),
                                                  ),
                                                );
                                                break;

                                              case "agent_discount":
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => ViewAgentDiscountDetailsScreen (
                                                      billNo: item.billNo,
                                                    ),
                                                  ),
                                                );
                                                break;

                                              case "edit":
                                                print("Edit Invoice");
                                                break;

                                              case "add_product":
                                                print("Add Product");
                                                break;

                                              case "ledger":
                                                print("Discount Ledger");
                                                break;

                                            }
                                          },

                                          itemBuilder: (context) => [

                                            const PopupMenuItem(
                                              value: "mrp",
                                              child: Text("1. View MRP Details"),
                                            ),

                                            const PopupMenuItem(
                                              value: "discount",
                                              child: Text("2. View Discount Details"),
                                            ),

                                            const PopupMenuItem(
                                              value: "agent_discount",
                                              child: Text("3. View Agent Discount Details"),
                                            ),

                                            const PopupMenuItem(
                                              value: "edit",
                                              child: Text("4. Edit Invoice Sale"),
                                            ),

                                            const PopupMenuItem(
                                              value: "add_product",
                                              child: Text("5. Add New Product"),
                                            ),

                                            const PopupMenuItem(
                                              value: "MRP_ledger",
                                              child: Text("6. View MRP Ledger"),
                                            ),

                                            const PopupMenuItem(
                                              value: "Discount",
                                              child: Text("7. Sale Ledger Discount"),
                                            ),

                                            const PopupMenuItem(
                                              value: "mix",
                                              child: Text("8. View Sale MixReport"),
                                            ),

                                            const PopupMenuItem(
                                              value: "pending_mix",
                                              child: Text("9. View Sale Pending MixReport"),
                                            ),

                                            const PopupMenuItem(
                                              value: "company_mix",
                                              child: Text("10. View Sale MixReport Company"),
                                            ),
                                          ],

                                          /// 🔥 BUTTON UI
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.visibility, color: Colors.white, size: 16),
                                                SizedBox(width: 5),
                                                Text(
                                                  "View",
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


            ],
          ),

          /// 🔥 LOADER (CORRECT PLACE)
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: SchoolLoader(
                  size: 70,
                  color: Colors.deepPurple,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(Icons.arrow_upward),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            mini: true,
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(Icons.arrow_downward),
          ),
        ],
      ),
    );
  }

  Widget summaryItem(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // 👈 height same feel
      crossAxisAlignment: CrossAxisAlignment.center, // 👈 center align
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}