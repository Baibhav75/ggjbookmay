import 'package:bookworld/adminPage/Sale/saleHistoryList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/Model/sale_history_model.dart';
import '/Service/sale_history_service.dart';

class SaleHistoryListPage extends StatefulWidget {
  const SaleHistoryListPage({super.key});

  @override
  State<SaleHistoryListPage> createState() => _SaleHistoryListPageState();
}

class _SaleHistoryListPageState extends State<SaleHistoryListPage> {

  List<SaleHistoryData> allData = [];
  List<SaleHistoryData> filteredData = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// LOAD API DATA
  void loadData() async {

    final data = await SaleHistoryService.fetchSaleHistory();

    setState(() {
      allData = data;
      filteredData = data;
    });
  }

  /// SEARCH FILTER
  void filterSearch(String query) {

    if (query.isEmpty) {
      setState(() {
        filteredData = allData;
      });
      return;
    }

    final results = allData.where((item) {

      final party = item.schoolName.toLowerCase();
      final bill = item.billNo.toLowerCase();
      final input = query.toLowerCase();

      return party.contains(input) || bill.contains(input);

    }).toList();

    setState(() {
      filteredData = results;
    });
  }

  /// DATE FORMAT
  String formatDate(String date) {
    DateTime dt = DateTime.parse(date);
    return "${dt.day}-${dt.month}-${dt.year}";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Sale History",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6B46C1),
      ),

      body: Column(
        children: [

          /// 🔎 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10),

            child: TextField(
              controller: searchController,

              decoration: InputDecoration(
                hintText: "Search Party Name or Bill No",

                prefixIcon: const Icon(Icons.search),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              onChanged: (value) {
                filterSearch(value);
              },
            ),
          ),

          /// TABLE
          Expanded(
            child: filteredData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(

              scrollDirection: Axis.horizontal,

              child: DataTable(

                headingRowColor:
                MaterialStateProperty.all(const Color(0xFFB0C9D1)),

                columns: const [

                  DataColumn(label: Text("Sr No")),
                  DataColumn(label: Text("Bill No")),
                  DataColumn(label: Text("Party Name")),
                  DataColumn(label: Text("Total Amount")),
                  DataColumn(label: Text("Date")),
                  DataColumn(label: Text("Action")),

                ],

                rows: filteredData.map((item) {

                  return DataRow(cells: [

                    DataCell(Text(item.sNo.toString())),

                    DataCell(Text(item.billNo)),

                    DataCell(
                      SizedBox(
                        width: 220,
                        child: Text(
                          item.schoolName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    DataCell(Text(item.totalAmount.toString())),

                    DataCell(Text(formatDate(item.dates))),

                    DataCell(

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),

                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SaleHistoryDetailsPage(
                                  billNo: item.billNo,
                                ),
                              ),
                            );
                          },

                          child: const Text("Actions"),
                        )

                    ),

                  ]);

                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}