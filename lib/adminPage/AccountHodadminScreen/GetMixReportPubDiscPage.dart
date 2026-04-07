import 'package:flutter/material.dart';
import '../../Service/GetMixReportPubDiscService.dart';
import '/Model/GetMixReportPubDisc_model.dart';
import 'package:share_plus/share_plus.dart';
import '/pdf/mix_report_pub_disc_pdf.dart';

class GetMixReportPubDiscPage extends StatefulWidget {
  final String publicationId;

  const GetMixReportPubDiscPage({super.key, required this.publicationId});

  @override
  State<GetMixReportPubDiscPage> createState() =>
      _GetMixReportPubDiscPageState();
}
Future<void> shareReport(GetMixReportPubDiscModel report) async {
  final file = await MixReportPubDiscPdf.generate(report);

  await Share.shareXFiles(
    [XFile(file.path)],
    text: "Mix Report Publication Discount",
  );
}

class _GetMixReportPubDiscPageState
    extends State<GetMixReportPubDiscPage> {

  late Future<GetMixReportPubDiscModel?> reportFuture;

  @override
  void initState() {
    super.initState();
    reportFuture =
        GetMixReportPubDiscService.fetchReport(widget.publicationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Mix Report Publication Discount"),
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final report = await reportFuture;
              if (report != null) {
                await shareReport(report);
              }
            },
          ),
        ],

      ),
      body: FutureBuilder<GetMixReportPubDiscModel?>(
        future: reportFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No Data Found"));
          }

          final report = snapshot.data!;

          return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Container(
                width: 900,
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        /// 🔥 HEADER
                        Column(
                          children: const [
                            Text(
                              "GJ BOOK WORLD PVT. LTD.",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "D-1/20, SECTOR 22, GIDA, GORAKHPUR",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              "Contact: 9354918638",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        const Divider(),

                        /// 🔥 TITLE
                        const Text(
                          "Mix Report Publication Discount",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),

                        const SizedBox(height: 5),

                        /// 🔥 PUBLICATION
                        Text(
                          "Publication: ${report.publication}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 16),

                        /// 🔥 TABLE
                        _buildTable(report),

                      ],
                    ),
                  ),
                ),
              ),
            ),
              ),
          );

        },
      ),
    );
  }

  /// 🔥 TABLE DESIGN (Image जैसा)
  Widget _buildTable(GetMixReportPubDiscModel report) {
    double grandQty = 0;
    double grandAmount = 0;
    double grandNetAmount = 0;

    Map<String, List<MixReportItem>> grouped = {};

    for (var item in report.data) {
      if (!grouped.containsKey(item.series)) {
        grouped[item.series] = [];
      }
      grouped[item.series]!.add(item);
    }
    double subQty = 0;
    double subAmount = 0;
    double subNetAmount = 0;

    List<TableRow> rows = [];

    /// 🔹 HEADER ROW
    rows.add(
      TableRow(
        decoration: BoxDecoration(color: Colors.grey.shade300),
        children: const [
          _HeaderCell("Book Name"),
          _HeaderCell("Purchase Qty"),
          _HeaderCell("Return Qty"),
          _HeaderCell("Net Qty"),
          _HeaderCell("Rate"),
          _HeaderCell("Amount"),
          _HeaderCell("Discount %"),
          _HeaderCell("Net Amount"),
        ],
      ),
    );

    /// 🔹 DATA
    grouped.forEach((series, items) {

      /// SERIES HEADER
      grouped.forEach((series, items) {

        double subQty = 0;
        double subAmount = 0;
        double subNetAmount = 0;

        /// 🔹 SERIES HEADER
        rows.add(
          TableRow(
            decoration: BoxDecoration(color: Colors.blueGrey.shade100),
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Series: $series",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...List.generate(7, (_) => const SizedBox()),
            ],
          ),
        );

        /// 🔹 ITEMS
        for (var item in items) {

          subQty += item.netQty;
          subAmount += item.amount;
          subNetAmount += item.netAmount;

          rows.add(
            TableRow(
              children: [
                _cell(item.bookName),
                _cell(item.purchaseQty.toString(), center: true),
                _cell(item.returnQty.toString(), center: true),
                _cell(item.netQty.toString(), center: true),
                _cell(item.rate.toStringAsFixed(2), right: true),
                _cell(item.amount.toStringAsFixed(2), right: true),
                _cell(item.discount.toStringAsFixed(2), center: true),
                _cell(item.netAmount.toStringAsFixed(2), right: true),
              ],
            ),
          );
        }


        /// 🔥 SUBTOTAL ROW
        rows.add(
          TableRow(
            decoration: BoxDecoration(color: Colors.orange.shade100),
            children: [
              _cell("Subtotal", right: true),
              _cell(subQty.toString(), center: true),
              _cell("", center: true),
              _cell(subQty.toString(), center: true),
              _cell("", right: true),
              _cell(subAmount.toStringAsFixed(2), right: true),
              _cell("0.00%", center: true),
              _cell(subNetAmount.toStringAsFixed(2), right: true),
            ],
          ),
        );

        /// 🔥 ADD TO GRAND TOTAL
        grandQty += subQty;
        grandAmount += subAmount;
        grandNetAmount += subNetAmount;

      });

      rows.add(
        TableRow(
          decoration: BoxDecoration(color: Colors.green.shade200),
          children: [
            _cell("Grand Total", right: true),
            _cell(grandQty.toString(), center: true),
            _cell("", center: true),
            _cell(grandQty.toString(), center: true),
            _cell("", right: true),
            _cell(grandAmount.toStringAsFixed(2), right: true),
            _cell("0.00%", center: true),
            _cell(grandNetAmount.toStringAsFixed(2), right: true),
          ],
        ),

      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 TABLE
        Table(
          border: TableBorder.all(color: Colors.black),
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1.2),
            6: FlexColumnWidth(1),
            7: FlexColumnWidth(1.2),
          },
          children: rows,
        ),

        const SizedBox(height: 20),

        /// 🔥 SUMMARY SECTION
        _buildSummary(grandNetAmount),
      ],
    );
  }

  Widget _buildSummary(double totalAmount) {
    double totalPaid = 0; // 🔥 future API से आएगा
    double closingAmount = totalAmount - totalPaid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Divider(thickness: 1),

        /// 🔹 LEFT SIDE
        Text(
          "MRP Purchase: ₹ ${totalAmount.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        /// 🔹 RIGHT SIDE
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Text(
                  "Total Paid: ₹ ${totalPaid.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 5),

                Text(
                  "Closing Amount: ₹ ${closingAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// 🔥 HEADER CELL
class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}

/// 🔥 NORMAL CELL
Widget _cell(String text,
    {bool center = false, bool right = false}) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Text(
      text,
      textAlign:
      center ? TextAlign.center : right ? TextAlign.right : TextAlign.left,
      style: const TextStyle(fontSize: 13),
    ),
  );
}