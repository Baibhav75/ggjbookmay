import 'package:flutter/material.dart';
import '../SellReturn/sale_return_sample_screenDetails.dart';
import '/Model/sale_sample_return_list_model.dart';
import '/Service/sale_sample_return_list_service.dart';

class SaleSampleReturnListScreen extends StatefulWidget {
  const SaleSampleReturnListScreen({super.key});

  @override
  State<SaleSampleReturnListScreen> createState() =>
      _SaleSampleReturnListScreenState();
}

class _SaleSampleReturnListScreenState
    extends State<SaleSampleReturnListScreen> {

  List<SaleSampleReturnItem> list = [];
  List<SaleSampleReturnItem> filteredList = [];

  bool isLoading = true;
  double grandTotal = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final res = await SaleSampleReturnListService.fetchList();

    if (res != null) {
      setState(() {
        list = res.data;
        filteredList = list;
        grandTotal = res.grandTotal;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void search(String value) {
    setState(() {
      filteredList = list.where((item) {
        return item.billNo.toLowerCase().contains(value.toLowerCase()) ||
            item.schoolName.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  String formatDate(String rawDate) {
    DateTime dt = DateTime.parse(rawDate);
    return "${dt.day}-${dt.month}-${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sale Sample Return List"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [

          /// 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(10),
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

          /// 🔥 TABLE
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 920,
                child: Column(
                  children: [

                    /// HEADER
                    Container(
                      color: Colors.deepPurple.shade100,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: const [
                          SizedBox(width: 60, child: Text("Sr No", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 80, child: Text("Bill No", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 240, child: Text("School", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 140, child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 140, child: Text("Type", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 120, child: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 120, child: Text("View", style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),

                    /// LIST
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];

                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 60, child: Text("${index + 1}")),
                                SizedBox(width: 80, child: Text(item.billNo)),
                                SizedBox(
                                  width: 240,
                                  child: Text(
                                    item.schoolName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 140, child: Text(formatDate(item.date))),
                                SizedBox(width: 140, child: Text(item.type ?? "-")),
                                SizedBox(
                                  width: 140,
                                  child: Text("₹ ${item.amount.toStringAsFixed(2)}"),
                                ),
                                /// ACTION
                                SizedBox(
                                  width: 40,
                                  child: PopupMenuButton<String>(
                                    onSelected: (value) {

                                      /// 🔥 DISCOUNT CLICK
                                      if (value == "discount") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SaleReturnSampleScreen(
                                              billNo: item.billNo.toString(),
                                            ),
                                          ),
                                        );
                                      }

                                      /// 🔥 MRP CLICK
                                      else if (value == "mrp") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SaleReturnSampleScreen(
                                              billNo: item.billNo.toString(),
                                            ),
                                          ),
                                        );
                                      }
                                    },

                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: "discount", // ✅ FIXED VALUE
                                        child: Text("View Discount"),
                                      ),
                                      PopupMenuItem(
                                        value: "mrp", // ✅ FIXED VALUE
                                        child: Text("MRP Details"),
                                      ),
                                    ],

                                    child: const Icon(Icons.visibility, color: Colors.blue),
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

          /// GRAND TOTAL
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.deepPurple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Grand Total",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹ ${grandTotal.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}