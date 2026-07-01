import 'package:bookworld/adminPage/AccountHodadminScreen/purchase_not_for_sale_invoice_Deatils.dart';
import 'package:bookworld/adminPage/AccountHodadminScreen/purchase_not_for_sale_ledger_invoiceDetails.dart';
import 'package:flutter/material.dart';
import '../../Model/PurchaseNotForSale_model.dart';
import '../../Service/PurchaseNotForSale_service.dart';

class PurchaseNotForSaleScreen extends StatefulWidget {
  const PurchaseNotForSaleScreen({super.key});

  @override
  State<PurchaseNotForSaleScreen> createState() =>
      _PurchaseNotForSaleScreenState();
}

class _PurchaseNotForSaleScreenState
    extends State<PurchaseNotForSaleScreen> {
  List<PurchaseItem> list = [];
  List<PurchaseItem> filteredList = [];

  bool isLoading = true;
  double grandTotal = 0;

  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// 🔥 API CALL
  void loadData() async {
    final res = await PurchaseNotForSaleService.fetchList();

    if (res != null) {
      setState(() {
        list = res.data;
        filteredList = list; // 👈 for search
        grandTotal = res.grandTotal;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  /// 🔥 SEARCH FILTER
  void filterSearch(String query) {
    final results = list.where((item) {
      final bill = item.billNo.toLowerCase();
      final pub = item.publication.toLowerCase();
      final input = query.toLowerCase();

      return bill.contains(input) || pub.contains(input);
    }).toList();

    setState(() {
      filteredList = results;
    });
  }

  /// 🔥 DATE FORMAT
  String formatDate(String rawDate) {
    DateTime dt = DateTime.parse(rawDate);
    return "${dt.day}-${dt.month}-${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase Not For Sale"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btnUp",
            mini: true,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            onPressed: () {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: const Icon(Icons.arrow_upward),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btnDown",
            mini: true,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            onPressed: () {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: const Icon(Icons.arrow_downward),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [

          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: InputDecoration(
                hintText: "Search Bill No / Publication",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          /// 🔥 UNIFIED TABLE (Horizontal + Vertical Scroll)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 900, // Fixed width to ensure scrolling
                child: Column(
                  children: [
                    /// 🔥 TABLE HEADER
                    Container(
                      color: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Row(
                        children: const [
                          Expanded(
                              flex: 1,
                              child: Text("Sr No",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text("Bill No",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 4,
                              child: Text("Publication",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text("Date",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text("Amount",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text("Action",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),

                    /// 🔥 LIST BODY
                    Expanded(
                      child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text("${index + 1}")),
                          Expanded(flex: 2, child: Text(item.billNo)),
                          Expanded(
                            flex: 4,
                            child: Text(
                              item.publication,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Text(formatDate(item.date))),
                          Expanded(
                              flex: 2,
                              child: Text(
                                "₹ ${item.amount.toStringAsFixed(2)}",
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                              )),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == "details") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PurchaseNotForSaleInvoiceScreen(
                                          billNo: item.billNo,
                                        ),
                                      ),
                                    );
                                  } else if (value == "ledger") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PurchaseNotForSaleLedgerScreen(
                                          publicationId: item.publicationId,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: "details",
                                    child: Row(
                                      children: [
                                        Icon(Icons.receipt_long, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text("View Details"),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: "ledger",
                                    child: Row(
                                      children: [
                                        Icon(Icons.account_balance_wallet, color: Colors.green),
                                        SizedBox(width: 8),
                                        Text("View Ledger"),
                                      ],
                                    ),
                                  ),
                                ],
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade600,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.visibility, color: Colors.white, size: 16),
                                      SizedBox(width: 5),
                                      Text(
                                        "View",
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
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


          /// 🔥 GRAND TOTAL
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            color: Colors.deepPurple.shade50,
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Grand Total",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "₹ ${grandTotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepPurple),
                ),
              ],
            ),
          )
        ],
      ),
    )
    ),
          ),
    ],),
    );
  }
}