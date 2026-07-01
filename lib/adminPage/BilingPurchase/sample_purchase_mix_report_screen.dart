import 'package:flutter/material.dart';
import '../../Model/sample_purchase_mix_report_model.dart';
import '../../Service/sample_purchase_mix_report_service.dart';

class SamplePurchaseMixReportScreen extends StatefulWidget {
  final String publicationId;

  const SamplePurchaseMixReportScreen({super.key, required this.publicationId});

  @override
  State<SamplePurchaseMixReportScreen> createState() =>
      _SamplePurchaseMixReportScreenState();
}

class _SamplePurchaseMixReportScreenState extends State<SamplePurchaseMixReportScreen> {
  late Future<SamplePurchaseMixReportResponse?> future;

  @override
  void initState() {
    super.initState();
    future = SamplePurchaseMixReportService.fetchReport(widget.publicationId);
  }

  Widget tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget tableCell(String text, {TextAlign align = TextAlign.center, FontWeight weight = FontWeight.normal}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(fontSize: 12, fontWeight: weight),
      ),
    );
  }

  Widget reportHeader(SamplePurchaseMixReportResponse data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "GJ BOOK WORLD PVT. LTD.",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        const Text(
          "D-1/20, SECTOR 22, GIDA, GORAKHPUR\n9354918638, 9354918644",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.black26, thickness: 1),
        const SizedBox(height: 10),
        const Text(
          "SAMPLE PURCHASE MIX REPORT",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Text(
          data.publicationName.toUpperCase(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2B4C7E)),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double reportWidth = screenWidth > 800 ? screenWidth - 32 : 900;

    const Map<int, TableColumnWidth> colWidths = {
      0: FlexColumnWidth(4),
      1: FixedColumnWidth(80),
      2: FixedColumnWidth(100),
      3: FixedColumnWidth(100),
      4: FixedColumnWidth(80),
      5: FixedColumnWidth(120),
    };

    final BorderSide side = const BorderSide(color: Colors.black87, width: 1.0);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Mix Report"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<SamplePurchaseMixReportResponse?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No Data Found"));
          }
          final data = snapshot.data!;

          Map<String, List<SamplePurchaseMixReportData>> groupedItems = {};
          for (var item in data.data) {
            if (!groupedItems.containsKey(item.seriesName)) {
              groupedItems[item.seriesName] = [];
            }
            groupedItems[item.seriesName]!.add(item);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: reportWidth,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey.withOpacity(0.2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reportHeader(data),
                      
                      // HEADER TABLE
                      Table(
                        border: TableBorder.all(color: Colors.black87),
                        columnWidths: colWidths,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.grey.shade300),
                            children: [
                              tableHeader("Book Name"),
                              tableHeader("Qty"),
                              tableHeader("Rate"),
                              tableHeader("Amount"),
                              tableHeader("Disc %"),
                              tableHeader("Net Amount"),
                            ],
                          ),
                        ],
                      ),
                      
                      // GROUPS
                      ...groupedItems.entries.map((entry) {
                        String seriesName = entry.key;
                        List<SamplePurchaseMixReportData> group = entry.value;

                        int groupQty = 0;
                        double groupAmount = 0;
                        double groupNetAmount = 0;

                        for (var item in group) {
                          groupQty += item.qty;
                          groupAmount += item.amount;
                          groupNetAmount += item.netAmount;
                        }

                        return Column(
                          children: [
                            // Series Row
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border: Border(left: side, right: side, bottom: side),
                              ),
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "SERIES : $seriesName",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Item & Subtotal Table
                            Table(
                              border: TableBorder(
                                left: side, right: side, bottom: side,
                                verticalInside: side, horizontalInside: side,
                              ),
                              columnWidths: colWidths,
                              children: [
                                ...group.map((item) {
                                  return TableRow(
                                    children: [
                                      tableCell(item.bookName, align: TextAlign.left, weight: FontWeight.bold),
                                      tableCell(item.qty.toString()),
                                      tableCell(item.rate.toStringAsFixed(2)),
                                      tableCell(item.amount.toStringAsFixed(2)),
                                      tableCell(item.discountPercent.toStringAsFixed(2)),
                                      tableCell(item.netAmount.toStringAsFixed(2)),
                                    ],
                                  );
                                }),
                                // Subtotal Row
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.orange.shade100.withOpacity(0.5)),
                                  children: [
                                    tableCell("Subtotal", align: TextAlign.right, weight: FontWeight.bold),
                                    tableCell(groupQty.toString(), weight: FontWeight.bold),
                                    const SizedBox(),
                                    tableCell(groupAmount.toStringAsFixed(2), weight: FontWeight.bold),
                                    const SizedBox(),
                                    tableCell(groupNetAmount.toStringAsFixed(2), weight: FontWeight.bold),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),

                      // GRAND TOTAL TABLE
                      Table(
                        border: TableBorder(
                          left: side, right: side, bottom: side,
                          verticalInside: side, horizontalInside: side,
                        ),
                        columnWidths: colWidths,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.green.shade100),
                            children: [
                              tableCell("Grand Total", align: TextAlign.right, weight: FontWeight.bold),
                              tableCell(data.totalQty.toString(), weight: FontWeight.bold),
                              const SizedBox(),
                              tableCell(data.totalAmount.toStringAsFixed(2), weight: FontWeight.bold),
                              const SizedBox(),
                              tableCell(data.totalNetAmount.toStringAsFixed(2), weight: FontWeight.bold),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
