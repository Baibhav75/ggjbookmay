import 'package:flutter/material.dart';
import '/Model/PurchaseMixReport_model.dart';
import '/service/purchase_mix_report_service.dart';
import 'package:share_plus/share_plus.dart';
import '/pdf/purchase_mix_report_pdf.dart';


class PurchaseMixReportScreen extends StatefulWidget {
  final String publicationId;

  const PurchaseMixReportScreen({super.key, required this.publicationId});

  @override
  State<PurchaseMixReportScreen> createState() =>
      _PurchaseMixReportScreenState();
}

class _PurchaseMixReportScreenState
    extends State<PurchaseMixReportScreen> {
  final service = PurchaseMixReportService();

  PurchaseMixReportModel? model;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await service.getReport(widget.publicationId);
    setState(() {
      model = data;
      isLoading = false;
    });
  }

  Future<void> shareReport() async {
    if (model == null) return;

    final file = await PurchaseMixReportPdf.generate(model!);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Purchase Mix Report",
    );
  }

  // 🔥 SERIES GROUPING
  List<TableRow> _buildSeriesWiseRows(List<PurchaseItem> data) {
    Map<String, List<PurchaseItem>> grouped = {};

    for (var item in data) {
      grouped.putIfAbsent(item.seriesName, () => []).add(item);
    }

    List<TableRow> rows = [];

    grouped.forEach((series, items) {
      // SERIES HEADER
      rows.add(
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFE3F2FD)),
          children: [
            _cell("SERIES: $series", isBold: true),
            ...List.generate(6, (_) => _cell("")),
          ],
        ),
      );

      int totalQty = 0;
      double totalAmount = 0;

      for (var item in items) {
        totalQty += item.netQty;
        totalAmount += item.netAmount;

        rows.add(
          _tableRow([
            item.bookName,
            item.purchaseQty.toString(),
            item.returnQty.toString(),
            item.netQty.toString(),
            item.rate.toStringAsFixed(2),
            item.amount.toStringAsFixed(2),
            item.netAmount.toStringAsFixed(2),
          ]),
        );
      }

      // SUBTOTAL
      rows.add(
        _tableRow(
          [
            "Subtotal",
            totalQty.toString(),
            "",
            totalQty.toString(),
            "",
            totalAmount.toStringAsFixed(2),
            totalAmount.toStringAsFixed(2),
          ],
          isSubtotal: true,
        ),
      );
    });

    return rows;
  }

  // 🔹 HEADER
  Widget _reportHeader() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: const [
                Icon(Icons.menu_book, size: 45, color: Colors.brown),
                SizedBox(height: 4),
                Text("BOOK WORLD",
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  const Text(
                    "GJ BOOK WORLD PVT. LTD.",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B4C7E)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "D-1/20, SECTOR 22, GIDA, GORAKHPUR",
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text("Contact: 9354918638"),
                  const SizedBox(height: 10),
                  const Text(
                    "Mix Report",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2B4C7E)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Publication: ${model!.publication}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(thickness: 1.2),
      ],
    );
  }

  // 🔹 TABLE
  Widget _reportTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Table(
          border: TableBorder.all(color: Colors.black54),
          columnWidths: const {
            0: FixedColumnWidth(250),
            1: FixedColumnWidth(80),
            2: FixedColumnWidth(80),
            3: FixedColumnWidth(80),
            4: FixedColumnWidth(80),
            5: FixedColumnWidth(100),
            6: FixedColumnWidth(100),
          },
          children: [
            // HEADER
            _tableRow(
              [
                "Book Name",
                "Purchase",
                "Return",
                "Net",
                "Rate",
                "Amount",
                "Net Amt"
              ],
              isHeader: true,
            ),

            // DATA
            ..._buildSeriesWiseRows(model!.data),

            // GRAND TOTAL
            _tableRow(
              [
                "Grand Total",
                model!.summary.totalPurchaseQty.toString(),
                model!.summary.totalReturnQty.toString(),
                model!.summary.totalPurchaseQty.toString(),
                "",
                model!.summary.totalAmount.toStringAsFixed(2),
                model!.summary.totalNetAmount.toStringAsFixed(2),
              ],
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 FOOTER
  Widget _reportFooter() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
              "MRP Purchase: ₹${model!.summary.totalAmount.toStringAsFixed(2)}"),
          Text(
              "Total Paid: ₹${model!.summary.totalPaidAmount.toStringAsFixed(2)}"),
          Text(
              "Closing Amount: ₹${model!.summary.closingAmount.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  // 🔹 TABLE ROW
  TableRow _tableRow(
      List<String> cells, {
        bool isHeader = false,
        bool isSubtotal = false,
        bool isTotal = false,
      }) {
    Color bg = Colors.white;

    if (isHeader) bg = Colors.grey.shade300;
    if (isSubtotal) bg = Colors.orange.shade100;
    if (isTotal) bg = Colors.green.shade200;

    return TableRow(
      decoration: BoxDecoration(color: bg),
      children: cells
          .map((e) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          e,
          style: TextStyle(
            fontWeight: isHeader || isSubtotal || isTotal
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ))
          .toList(),
    );
  }

  // 🔹 CELL
  Widget _cell(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }

  // 🔹 BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "View MixReport ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: shareReport,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : model == null
          ? const Center(child: Text("No Data"))
          : SingleChildScrollView(
        child: Column(
          children: [
            _reportHeader(),
            _reportTable(),
            _reportFooter(),
          ],
        ),
      ),
    );
  }
}