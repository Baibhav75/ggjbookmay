import 'package:flutter/material.dart';
import '../model/counter_stock_details_model.dart';
import '../service/counter_stock_details_service.dart';

class CounterStockDetailsPage extends StatefulWidget {
  final String billNo;

  const CounterStockDetailsPage({
    Key? key,
    required this.billNo,
  }) : super(key: key);

  @override
  State<CounterStockDetailsPage> createState() =>
      _CounterStockDetailsPageState();
}

class _CounterStockDetailsPageState
    extends State<CounterStockDetailsPage> {

  late Future<CounterStockDetailsModel> futureData;

  @override
  void initState() {
    super.initState();
    futureData =
        CounterStockDetailsService.fetchBillDetails(widget.billNo);
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Counter Stock Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<CounterStockDetailsModel>(
        future: futureData,
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text("Failed to load data"));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// 🔵 COMPANY HEADER
                const Text(
                  "GJ BOOK WORLD PVT. LTD.",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                /// 🔵 BILL INFO
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(children: [
                      _cell("BillNo : ${data.billNo}"),
                      _cell("School : ${data.schoolName}"),
                      _cell("Date : ${formatDate(data.billDate)}"),
                    ])
                  ],
                ),

                const SizedBox(height: 30),

                /// 🔵 ITEMS TABLE
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    border: TableBorder.all(),
                    defaultColumnWidth:
                    const IntrinsicColumnWidth(),
                    children: [

                      /// HEADER
                      TableRow(
                        decoration:
                        const BoxDecoration(color: Colors.grey),
                        children: [
                          _header("S.N"),
                          _header("Series"),
                          _header("Book Name"),
                          _header("Class"),
                          _header("Subject"),
                          _header("Qty"),
                          _header("Rate"),
                          _header("Publication"),
                          _header("Total"),
                        ],
                      ),

                      /// DATA
                      ...data.items
                          .asMap()
                          .entries
                          .map((entry) {

                        int index = entry.key + 1;
                        final item = entry.value;

                        return TableRow(
                          children: [
                            _cell("$index"),
                            _cell(item.series),
                            _cell(item.bookName),
                            _cell(item.classes),
                            _cell(item.subject),
                            _cell(item.qty.toString()),
                            _cell("₹ ${item.rate.toStringAsFixed(2)}"),
                            _cell(item.publication),
                            _cell("₹ ${item.totalAmount.toStringAsFixed(2)}"),
                          ],
                        );
                      }),

                      /// GRAND TOTAL
                      TableRow(
                        decoration: BoxDecoration(
                            color: Colors.blue.shade50),
                        children: [
                          _cell(""),
                          _cell(""),
                          _cell(""),
                          _cell(""),
                          _cell(""),
                          _cell(""),
                          _cell(""),
                          _cell("Grand Total:",
                              bold: true),
                          _cell(
                              "₹ ${data.grandTotal.toStringAsFixed(2)}",
                              bold: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _cell(String text,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
            fontWeight:
            bold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  static Widget _header(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }
}