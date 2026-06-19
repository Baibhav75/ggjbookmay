import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Model/view_agent_discount_details_model.dart';
import '../../appDart/auth_servcie.dart';
import '../../pdf/salePdf/view_agent_discount_pdf.dart';

class ViewAgentDiscountDetailsScreen extends StatefulWidget {
  final String billNo;

  const ViewAgentDiscountDetailsScreen({
    super.key,
    required this.billNo,
  });

  @override
  State<ViewAgentDiscountDetailsScreen> createState() =>
      _ViewAgentDiscountDetailsScreenState();
}

class _ViewAgentDiscountDetailsScreenState
    extends State<ViewAgentDiscountDetailsScreen> {
  late Future<ViewAgentDiscountDetailsModel?> future;

  @override
  void initState() {
    super.initState();
    future = AuthService.getInvoiceDetails(widget.billNo);
  }

  String formatDate(String date) {
    try {
      return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
    } catch (_) {
      return "";
    }
  }

  Widget infoCell(String label, String value, {TextAlign align = TextAlign.center}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        textAlign: align,
      ),
    );
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

  Widget invoiceHeader(InvoiceDetails invoice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 70,
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 50,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.menu_book,
                      size: 50,
                    ),
                  ),
                ),
                const Text(
                  "BOOK WORLD",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "GJ BOOK WORLD PVT. LTD.",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2B4C7E)),
                ),
                SizedBox(height: 8),
                Text(
                  "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 9354918638, 9354918644\nGST No: 09AAGCG0650B1Z2| CIN No: U22222UP2015PTC068597",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.black, thickness: 2),
        const SizedBox(height: 10),
        const Text(
          "SALE INVOICE",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Color(0xFF2B4C7E), decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 15),
        Table(
          border: TableBorder.all(color: Colors.black87),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(children: [
              infoCell("Invoice No: ", invoice.billNo),
              infoCell("Party Name: ", invoice.schoolName),
              infoCell("Bill Date: ", formatDate(invoice.billDate)),
            ]),
            TableRow(children: [
              infoCell("Address: ", invoice.address),
              infoCell("Area Manager Name: ", invoice.managerName),
              infoCell("Agent Name: ", invoice.agentName),
            ]),
            TableRow(children: [
              infoCell("Transport: ", invoice.transport),
              const SizedBox(),
              const SizedBox(),
            ]),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double invoiceWidth = screenWidth > 800 ? screenWidth - 32 : 1000;

    const Map<int, TableColumnWidth> colWidths = {
      0: FixedColumnWidth(50),
      1: FlexColumnWidth(4),
      2: FixedColumnWidth(60),
      3: FixedColumnWidth(80),
      4: FixedColumnWidth(100),
      5: FixedColumnWidth(120),
    };

    final BorderSide side = const BorderSide(color: Colors.black87, width: 1.0);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "View Agent Discount Details",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {

              final model =
              await future;

              if (model == null) return;

              await ViewAgentDiscountPdf
                  .generateAndShare(model);
            },
          ),
        ],
      ),
      body: FutureBuilder<ViewAgentDiscountDetailsModel?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No Data Found"));
          }

          final response = snapshot.data!;
          final invoice = response.invoiceDetails;
          final summary = response.summary;
          final items = response.items;

          Map<String, List<InvoiceItem>> groupedItems = {};
          for (var item in items) {
            String key = "${item.series}|${item.publication}";
            if (!groupedItems.containsKey(key)) {
              groupedItems[key] = [];
            }
            groupedItems[key]!.add(item);
          }

          int index = 1;

          // Estimate global percentages to apply to groups
          double globalDiscountPercent = summary.discountPercent;
          double globalAgentCommPercent = summary.afterDiscountTotal > 0 
              ? (summary.totalAgentCommission / summary.afterDiscountTotal * 100) 
              : 0.0;
          double globalManagerCommPercent = summary.afterDiscountTotal > 0 
              ? (summary.totalManagerCommission / summary.afterDiscountTotal * 100) 
              : 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: invoiceWidth,
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
                      invoiceHeader(invoice),
                      const SizedBox(height: 15),

                      // TABLE HEADER
                      Table(
                        border: TableBorder.all(color: Colors.black87),
                        columnWidths: colWidths,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.grey.shade200),
                            children: [
                              tableHeader("S.N."),
                              tableHeader("Book Name (Title)"),
                              tableHeader("Qty"),
                              tableHeader("Rate"),
                              tableHeader("Amount"),
                              tableHeader("Amt With Disc."),
                            ],
                          ),
                        ],
                      ),

                      // GROUPS
                      ...groupedItems.entries.map((entry) {
                        String series = entry.key.split('|')[0];
                        String publication = entry.key.split('|')[1];
                        List<InvoiceItem> group = entry.value;

                        int groupQty = 0;
                        double groupAmount = 0;

                        for (var item in group) {
                          groupQty += item.qty;
                          groupAmount += item.totalAmount;
                        }

                        double groupDiscount = groupAmount * (globalDiscountPercent / 100);
                        double groupAfterDisc = groupAmount - groupDiscount;
                        double groupAgentComm = groupAfterDisc * (globalAgentCommPercent / 100);
                        double groupManagerComm = groupAfterDisc * (globalManagerCommPercent / 100);

                        return Column(
                          children: [
                            // Series and Publication row (no vertical borders)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                border: Border(left: side, right: side, bottom: side),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Series: $series",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color(0xFF2B4C7E),
                                    ),
                                  ),
                                  Text(
                                    "Publication: $publication",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color(0xFF2B4C7E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Group Items and Subtotals Table
                            Table(
                              border: TableBorder(
                                left: side, right: side, bottom: side,
                                verticalInside: side, horizontalInside: side,
                              ),
                              columnWidths: colWidths,
                              children: [
                                // Item Rows
                                ...group.map((item) {
                                  return TableRow(
                                    children: [
                                      tableCell("${index++}"),
                                      tableCell(
                                        "${item.bookName} - ${item.classes}",
                                        align: TextAlign.left,
                                      ),
                                      tableCell(item.qty.toStringAsFixed(0)),
                                      tableCell(item.rate.toStringAsFixed(2)),
                                      tableCell(item.totalAmount.toStringAsFixed(2)),
                                      tableCell(item.totalAmount.toStringAsFixed(4)), // Amt With Disc per item
                                    ],
                                  );
                                }),
                                // Subtotal Row
                                TableRow(
                                  children: [
                                    const SizedBox(),
                                    tableCell("Subtotal:", align: TextAlign.right, weight: FontWeight.bold),
                                    tableCell(groupQty.toString(), weight: FontWeight.bold),
                                    const SizedBox(),
                                    tableCell("₹ ${groupAmount.toStringAsFixed(2)}", weight: FontWeight.bold),
                                    const SizedBox(),
                                  ],
                                ),
                                // Disc Row
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.blue.shade50),
                                  children: [
                                    const SizedBox(),
                                    tableCell("Disc (${globalDiscountPercent.toStringAsFixed(2)} %):", align: TextAlign.right, weight: FontWeight.bold),
                                    const SizedBox(),
                                    const SizedBox(),
                                    const SizedBox(),
                                    tableCell("₹ ${groupAfterDisc.toStringAsFixed(4)}", weight: FontWeight.bold),
                                  ],
                                ),
                                // Agent Comm Row
                                TableRow(
                                  decoration: const BoxDecoration(color: Color(0xffefe4c1)),
                                  children: [
                                    const SizedBox(),
                                    tableCell("Agent Commission (${globalAgentCommPercent.toStringAsFixed(2)} %):", align: TextAlign.right, weight: FontWeight.bold),
                                    const SizedBox(),
                                    const SizedBox(),
                                    tableCell("₹ ${groupAgentComm.toStringAsFixed(2)}", weight: FontWeight.bold),
                                    const SizedBox(),
                                  ],
                                ),
                                // Area Mgr Comm Row
                                TableRow(
                                  decoration: const BoxDecoration(color: Color(0xffe6f5dd)),
                                  children: [
                                    const SizedBox(),
                                    tableCell("Area Manager Commission (${globalManagerCommPercent.toStringAsFixed(2)} %):", align: TextAlign.right, weight: FontWeight.bold),
                                    const SizedBox(),
                                    const SizedBox(),
                                    tableCell("₹ ${groupManagerComm.toStringAsFixed(2)}", weight: FontWeight.bold),
                                    const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),

                      // GRAND TOTALS
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
                              const SizedBox(),
                              tableCell("Grand Total:", align: TextAlign.right, weight: FontWeight.bold),
                              tableCell(summary.totalQty.toString(), weight: FontWeight.bold),
                              const SizedBox(),
                              tableCell("₹ ${summary.grandTotal.toStringAsFixed(2)}", weight: FontWeight.bold),
                              const SizedBox(),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(color: Colors.cyan.shade50),
                            children: [
                              const SizedBox(),
                              tableCell("Total Discount (${summary.discountPercent.toStringAsFixed(2)} %):", align: TextAlign.right, weight: FontWeight.bold),
                              const SizedBox(),
                              const SizedBox(),
                              const SizedBox(),
                              tableCell("₹ ${summary.afterDiscountTotal.toStringAsFixed(4)}", weight: FontWeight.bold),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(color: Colors.red.shade50),
                            children: [
                              const SizedBox(),
                              tableCell("Total Agent Commission:", align: TextAlign.right, weight: FontWeight.bold),
                              const SizedBox(),
                              const SizedBox(),
                              tableCell("₹ ${summary.totalAgentCommission.toStringAsFixed(2)}", weight: FontWeight.bold),
                              const SizedBox(),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(color: Colors.orange.shade50),
                            children: [
                              const SizedBox(),
                              tableCell("Total Manager Commission:", align: TextAlign.right, weight: FontWeight.bold),
                              const SizedBox(),
                              const SizedBox(),
                              tableCell("₹ ${summary.totalManagerCommission.toStringAsFixed(2)}", weight: FontWeight.bold),
                              const SizedBox(),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              "Invoice Created By: __________________",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Rechecked By: __________________",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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