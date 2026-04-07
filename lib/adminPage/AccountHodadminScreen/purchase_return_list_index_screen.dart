import 'package:flutter/material.dart';
import '/Model/purchase_return_list_index_model.dart';
import '/Service/purchase_return_list_index_service.dart';

class PurchaseReturnListIndexScreen extends StatefulWidget {
  const PurchaseReturnListIndexScreen({super.key});

  @override
  State<PurchaseReturnListIndexScreen> createState() =>
      _PurchaseReturnListIndexScreenState();
}

class _PurchaseReturnListIndexScreenState
    extends State<PurchaseReturnListIndexScreen> {

  List<PurchaseReturnListItem> list = [];
  List<PurchaseReturnListItem> filteredList = [];

  bool isLoading = true;
  double grandTotal = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final res = await PurchaseReturnListIndexService.fetchList();

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
            item.publication.toLowerCase().contains(value.toLowerCase());
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
        title: const Text("Purchase Return List"),
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
                hintText: "Search Bill No / Publication",
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
                width: 700,
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
                          SizedBox(width: 200, child: Text("Publication", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 120, child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 120, child: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 80, child: Text("View", style: TextStyle(fontWeight: FontWeight.bold))),
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
                                  width: 200,
                                  child: Text(
                                    item.publication,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 120, child: Text(formatDate(item.date))),
                                SizedBox(
                                  width: 120,
                                  child: Text("₹ ${item.amount.toStringAsFixed(2)}"),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: IconButton(
                                    icon: const Icon(Icons.visibility, color: Colors.blue),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("View Bill ${item.billNo}")),
                                      );
                                    },
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