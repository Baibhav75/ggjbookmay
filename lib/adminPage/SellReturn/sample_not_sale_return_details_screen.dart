import 'package:flutter/material.dart';
import '/Model/sample_not_sale_return_details_model.dart';
import '/Service/sample_not_sale_return_details_service.dart';
import '/pdf/salePdf/sample_not_sale_return_pdf.dart';
class SampleNotSaleReturnDetailsScreen extends StatefulWidget {
  final String billNo;

  const SampleNotSaleReturnDetailsScreen({super.key, required this.billNo});

  @override
  State<SampleNotSaleReturnDetailsScreen> createState() =>
      _SampleNotSaleReturnDetailsScreenState();
}

class _SampleNotSaleReturnDetailsScreenState
    extends State<SampleNotSaleReturnDetailsScreen> {
  late Future<SampleNotSaleReturnDetailsModel> future;

  @override
  void initState() {
    super.initState();
    future = SampleNotSaleReturnDetailsService.fetchDetails(widget.billNo);
  }

  Widget tableHeader(String text) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      );

  Widget tableCell(String text,
          {TextAlign align = TextAlign.center,
          FontWeight weight = FontWeight.normal,
          Color? textColor}) =>
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text,
            textAlign: align,
            style: TextStyle(
                fontSize: 13,
                fontWeight: weight,
                color: textColor ?? Colors.black87)),
      );

  String formatDate(String date) {
    try {
      if (date.isEmpty) return "";
      if (date.contains("T")) {
        final d = DateTime.parse(date);
        return "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}";
      }
      final d = DateTime.parse(date);
      return "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}";
    } catch (_) {
      return date;
    }
  }

  Widget invoiceHeader(SampleNotSaleReturnDetailsModel data) {
    String formattedDate = formatDate(data.master.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book_sharp, size: 40, color: Colors.brown),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "GJ BOOK WORLD PVT. LTD.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B4C7E)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 9354918638, 9354918644\nGST No: 09AAGCG0650B1Z2 | CIN No: U22222UP2015PTC068597",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(thickness: 2),
        const Text(
          "Sample Not For Sale Return Invoice",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: Colors.black54),
          children: [
            TableRow(children: [
              tableCell("Invoice No: ${data.master.billNo}", align: TextAlign.left),
              tableCell("Party Name: ${data.master.schoolName}", align: TextAlign.left),
              tableCell("Bill Date: $formattedDate", align: TextAlign.left),
            ]),
            TableRow(children: [
              tableCell("Transport: BY HAND", align: TextAlign.left),
              tableCell("Address: ${data.master.address}", align: TextAlign.left),
              tableCell("Rec. Date: $formattedDate", align: TextAlign.left),
            ]),
            TableRow(children: [
              tableCell("Remark: SAMPLE", align: TextAlign.left),
              const SizedBox(),
              const SizedBox(),
            ])
          ],
        ),
      ],
    );
  }

  List<TableRow> buildSeriesRows(List<Item> items) {
    Map<String, List<Item>> grouped = {};

    for (var item in items) {
      String series = item.series;
      grouped.putIfAbsent(series, () => []).add(item);
    }

    List<TableRow> rows = [];
    int index = 1;

    grouped.forEach((series, list) {
      double subtotalQty = 0;
      double subtotalAmount = 0;
      String publication = list.isNotEmpty ? list.first.publication : "";

      rows.add(
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: [
            const SizedBox(),
            tableCell("Series: $series", align: TextAlign.left, weight: FontWeight.bold),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
            tableCell("Publication: $publication", align: TextAlign.right, weight: FontWeight.bold),
          ],
        ),
      );

      for (var item in list) {
        subtotalQty += item.qty;
        subtotalAmount += item.total;

        rows.add(
          TableRow(
            children: [
              tableCell("${index++}"),
              tableCell("${item.bookName} - ${item.classes}", align: TextAlign.left),
              tableCell(item.qty.toString()),
              tableCell("₹ ${item.rate}"),
              tableCell("₹ ${item.total.toStringAsFixed(2)}"),
              tableCell(""),
            ],
          ),
        );
      }

      rows.add(
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: [
            const SizedBox(),
            tableCell("Subtotal:", align: TextAlign.right, weight: FontWeight.bold),
            tableCell(subtotalQty.toInt().toString(), weight: FontWeight.bold),
            const SizedBox(),
            tableCell("₹ ${subtotalAmount.toStringAsFixed(2)}", weight: FontWeight.bold),
            const SizedBox(),
          ],
        ),
      );

      rows.add(
        TableRow(
          decoration: BoxDecoration(color: Colors.blue.shade50),
          children: [
            const SizedBox(),
            tableCell("Disc(%):", align: TextAlign.right),
            tableCell("0.00", align: TextAlign.center),
            const SizedBox(),
            const SizedBox(),
            tableCell("₹ ${subtotalAmount.toStringAsFixed(4)}"),
          ],
        ),
      );
    });

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sample Invoice"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          FutureBuilder<SampleNotSaleReturnDetailsModel>(
            future: future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              return IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                onPressed: () {
                  SampleNotSaleReturnPdf.generateAndShare(snapshot.data!);
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<SampleNotSaleReturnDetailsModel>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No Data Found"));
          }

          final data = snapshot.data!;

          return LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth > 800
                  ? constraints.maxWidth - 32
                  : 1000;

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: width,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          invoiceHeader(data),
                          const SizedBox(height: 20),
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(40),
                              1: FlexColumnWidth(4),
                              2: FixedColumnWidth(60),
                              3: FixedColumnWidth(80),
                              4: FixedColumnWidth(100),
                              5: FixedColumnWidth(120),
                            },
                            children: [
                              TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade300),
                                children: [
                                  tableHeader("S.N."),
                                  tableHeader("Book Name (Title)"),
                                  tableHeader("Qty"),
                                  tableHeader("Rate"),
                                  tableHeader("Amount"),
                                  tableHeader("Amt With Disc."),
                                ],
                              ),
                              ...buildSeriesRows(data.items),
                              TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.green.shade100),
                                children: [
                                  const SizedBox(),
                                  tableCell("Grand Total:",
                                      align: TextAlign.right,
                                      weight: FontWeight.bold),
                                  tableCell(data.grandTotalQty.toString(),
                                      weight: FontWeight.bold),
                                  const SizedBox(),
                                  tableCell(
                                      "₹ ${data.grandTotal.toStringAsFixed(2)}",
                                      weight: FontWeight.bold),
                                  const SizedBox(),
                                ],
                              ),
                              TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.cyan.shade100),
                                children: [
                                  const SizedBox(),
                                  tableCell("Total Discount:",
                                      align: TextAlign.right,
                                      weight: FontWeight.bold),
                                  tableCell("0.00%", weight: FontWeight.bold),
                                  const SizedBox(),
                                  const SizedBox(),
                                  tableCell(
                                      "₹ ${data.finalAmount.toStringAsFixed(4)}",
                                      weight: FontWeight.bold),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

