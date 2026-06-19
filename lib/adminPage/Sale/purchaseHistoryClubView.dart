import 'package:bookworld/adminPage/AccountHodadminScreen/GetMixReportPubDiscPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../AccountHodadminScreen/PubchaseEnterInvoice.dart';
import '../AccountHodadminScreen/PurchaseMixReportScreen.dart';
import '../AccountHodadminScreen/PurchaseStock_register_screen.dart';
import '../AccountHodadminScreen/ViewCompanyDiscountScreen.dart';
import '../PurchaseReturn/PurchaseViewMrpLedger.dart';
import '/Model/purchase_history_model.dart';
import '/Service/purchase_history_service.dart';
import 'PurchaseMrpDestails.dart';
import '/appDart/discrete_circular_loader.dart';
import '/adminPage/AccountHodadminScreen/ViewPurchaseDiscountInvoiceScreen.dart';

class SalePurchaseClubInvoiceHistory extends StatefulWidget {
  const SalePurchaseClubInvoiceHistory({super.key});

  @override
  State<SalePurchaseClubInvoiceHistory> createState() =>
      _SalePurchaseClubInvoiceHistoryState();
}

class _SalePurchaseClubInvoiceHistoryState
    extends State<SalePurchaseClubInvoiceHistory> {
  List<PurchaseData> list = [];
  List<PurchaseData> filteredList = [];

  bool isLoading = true;
  double grandTotal = 0;
  int totalRecords = 0;

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
    final res = await PurchaseHistoryService.fetchPurchaseHistory();

    if (res != null) {
      List<PurchaseData> rawData = res.data;

      // Sort raw data by date (newest first)
      rawData.sort((a, b) {
        DateTime? dateA = a.date;
        DateTime? dateB = b.date;
        if (dateA != null && dateB != null) return dateB.compareTo(dateA);
        if (dateA != null) return -1;
        if (dateB != null) return 1;
        return 0;
      });

      setState(() {
        list = rawData;
        filteredList = getClubList();
        grandTotal = res.grandTotal;
        totalRecords = res.totalRecords;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  List<PurchaseData> getClubList() {
    Map<String, PurchaseData> map = {};

    for (var item in list) {
      if (map.containsKey(item.publicationId)) {
        final existing = map[item.publicationId]!;

        map[item.publicationId] = PurchaseData(
          id: existing.id,
          srNo: existing.srNo,
          billNo: existing.billNo,
          publication: existing.publication,
          publicationId: existing.publicationId,
          partyId: existing.partyId,
          party: existing.party,
          grno: existing.grno,
          box: existing.box,
          totalAmount: existing.totalAmount + item.totalAmount,
          date: existing.date,
          backDate: existing.backDate,
          groups: existing.groups,
          sepBillNo: existing.sepBillNo,
        );
      } else {
        map[item.publicationId] = item;
      }
    }

    return map.values.toList()
      ..sort((a, b) =>
          a.publication.toLowerCase().compareTo(b.publication.toLowerCase()));
  }

  void search(String value) {
    List<PurchaseData> baseList = getClubList();

    setState(() {
      filteredList = baseList.where((item) {
        return item.billNo.toLowerCase().contains(value.toLowerCase()) ||
            item.publication.toLowerCase().contains(value.toLowerCase()) ||
            item.groups.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Purchase Club View History",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF6B46C1),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.white),
            tooltip: "Add Purchase",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PurchaseInvoiceEntry(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          /// 🔶 MAIN UI
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
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    summaryItem("Total Records", "$totalRecords"),
                    summaryItem(
                        "Grand Total", "₹ ${grandTotal.toStringAsFixed(2)}"),
                  ],
                ),
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
                          hintText: "Search Bill No / Publication / Groups",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
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
                          child: const Row(
                            children: [
                              SizedBox(width: 60, child: Text("Sr No")),
                              SizedBox(width: 260, child: Text("Publication")),
                              SizedBox(width: 160, child: Text("Amount")),
                              SizedBox(width: 80, child: Text("View")),
                            ],
                          ),
                        ),

                        /// LIST
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];

                              return Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 60, child: Text("${index + 1}")),
                                    SizedBox(
                                        width: 260,
                                        child: Text(item.publication)),
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                          "₹ ${item.totalAmount.toStringAsFixed(2)}"),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: PopupMenuButton<String>(
                                        onSelected: (value) {
                                          switch (value) {
                                            case 'view_mrp_invoice':
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PurchaseInvoicePage(
                                                              billNo: item
                                                                  .billNo
                                                                  .toString())));
                                              break;
                                            case 'edit_invoice':
                                              print("Edit Invoice");
                                              break;
                                            case 'add_product':
                                              print("Add Product");
                                              break;
                                            case 'view_image':
                                              print("View Image");
                                              break;
                                            case 'company_discount':
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          ViewCompanyDiscountScreen(
                                                              billNo: item
                                                                  .billNo
                                                                  .toString())));
                                              break;
                                            case 'publication_discount':
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PurchaseDetailsDiscountInvoiceScreen(
                                                              billNo: item
                                                                  .billNo
                                                                  .toString())));
                                              break;
                                            case 'only_mrp':
                                              print("Only MRP");
                                              break;
                                            case 'mix_report':
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PurchaseMixReportScreen(
                                                              publicationId: item
                                                                  .publicationId)));
                                              break;
                                            case 'stock_register':
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          StockRegisterScreen(
                                                              publicationId: item
                                                                  .publicationId
                                                                  .toString())));
                                              break;
                                            case 'mix_pub_disc':
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          GetMixReportPubDiscPage(
                                                              publicationId: item
                                                                  .publicationId
                                                                  .toString())));
                                              break;
                                            case 'mrp_ledger':
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PurchaseMrpLedgerScreen(
                                                              publicationId: item
                                                                  .publicationId
                                                                  .toString())));
                                              break;
                                            case 'company_ledger':
                                              print("Company Ledger");
                                              break;
                                            case 'publication_ledger':
                                              print("Publication Ledger");
                                              break;
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          _menuItem("1. View MRP Invoice",
                                              "view_mrp_invoice"),
                                          _menuItem(
                                              "2. Edit Invoice", "edit_invoice"),
                                          _menuItem(
                                              "3. Add New Product In Invoice",
                                              "add_product"),
                                          _menuItem("4. View Invoice Image",
                                              "view_image"),
                                          _menuItem(
                                              "5. View Company Discount Invoice",
                                              "company_discount"),
                                          _menuItem(
                                              "6. View Publication Discount Invoice",
                                              "publication_discount"),
                                          _menuItem("7. View Only MRP Invoice",
                                              "only_mrp"),
                                          _menuItem("8. View MixReport",
                                              "mix_report"),
                                          _menuItem("9. View Stock Register",
                                              "stock_register"),
                                          _menuItem("10. View MixReport PubDisc",
                                              "mix_pub_disc"),
                                          _menuItem(
                                              "11. View MRP Ledger", "mrp_ledger"),
                                          _menuItem(
                                              "12. View Company Discount Ledger",
                                              "company_ledger"),
                                          _menuItem(
                                              "13. View Publication Discount Ledger",
                                              "publication_ledger"),
                                        ],
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.visibility,
                                                  color: Colors.white,
                                                  size: 16),
                                              SizedBox(width: 5),
                                              Text(
                                                "View",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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

          /// 🔥 LOADER
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
            heroTag: 'purchase_up_btn',
            onPressed: () {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: const Icon(Icons.arrow_upward),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            mini: true,
            heroTag: 'purchase_down_btn',
            onPressed: () {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: const Icon(Icons.arrow_downward),
          ),
        ],
      ),
    );
  }

  Widget summaryItem(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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

  PopupMenuItem<String> _menuItem(String text, String value) {
    return PopupMenuItem(
      value: value,
      child: Text(text),
    );
  }
}