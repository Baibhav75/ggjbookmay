import 'package:flutter/material.dart';
import '../../Model/sale_sample_not_for_sale_invoice_model.dart';
import '../../Service/sale_sample_not_for_sale_invoice_service.dart';

import 'package:share_plus/share_plus.dart';
import '../../pdf/salePdf/sale_sample_not_for_sale_invoice_pdf.dart';

class SaleSampleNotForSaleInvoiceScreen extends StatefulWidget {
  final String billNo;

  const SaleSampleNotForSaleInvoiceScreen({super.key, required this.billNo});

  @override
  State<SaleSampleNotForSaleInvoiceScreen> createState() =>
      _SaleSampleNotForSaleInvoiceScreenState();
}

Future<void> shareInvoice(SaleSampleNotForSaleInvoiceResponse data) async {
  final file = await SaleSampleNotForSaleInvoicePdf.generate(data);

  await Share.shareXFiles(
    [XFile(file.path)],
    text: "Sample Invoice ${data.invoice.billNo}",
  );
}

class _SaleSampleNotForSaleInvoiceScreenState extends State<SaleSampleNotForSaleInvoiceScreen> {
  late Future<SaleSampleNotForSaleInvoiceResponse?> future;

  @override
  void initState() {
    super.initState();
    future = SaleSampleNotForSaleInvoiceService.fetchInvoice(widget.billNo);
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

  Widget invoiceHeader(SaleSampleNotForSaleInvoiceResponse data) {
    final inv = data.invoice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: const [
                Icon(Icons.menu_book_sharp, size: 45, color: Colors.brown),
                Text(
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
          "Sale Sample NotFor Sale Invoice",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Color(0xFF2B4C7E)),
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
              infoCell("Invoice No: ", inv.billNo),
              infoCell("Party Name: ", inv.partyName),
              infoCell("Bill Date: ", inv.billDate.isNotEmpty ? inv.billDate.split("T")[0] : ""),
            ]),
            TableRow(children: [
              infoCell("Transport: ", inv.transport),
              infoCell("Address: ", inv.address),
              infoCell("Rec. Date: ", inv.recDate.isNotEmpty ? inv.recDate.split("T")[0] : ""),
            ]),
            TableRow(children: [
               const SizedBox(),
               infoCell("Remark: ", inv.remark),
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
        title: Text("Invoice ${widget.billNo}"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final data = await future;
              if (data != null) {
                await shareInvoice(data);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<SaleSampleNotForSaleInvoiceResponse?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No Data Found"));
          }
          final data = snapshot.data!;

          int index = 1;

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
                      invoiceHeader(data),
                      const SizedBox(height: 15),
                      
                      // HEADER TABLE
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
                      ...data.seriesGroups.map((group) {
                        return Column(
                          children: [
                            // Series/Publication Row
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
                                    "Series: ${group.series}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color(0xFF2B4C7E),
                                    ),
                                  ),
                                  Text(
                                    "Publication: ${group.publication}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color(0xFF2B4C7E),
                                    ),
                                  ),
                                ],
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
                                ...group.items.map((item) {
                                  return TableRow(
                                    children: [
                                      tableCell("${index++}"),
                                      tableCell(
                                        "${item.bookName} - ${item.subject} - ${item.classes}",
                                        align: TextAlign.left,
                                      ),
                                      tableCell(item.qty.toStringAsFixed(0)),
                                      tableCell(item.rate.toStringAsFixed(2)),
                                      tableCell(item.amount.toStringAsFixed(2)),
                                      tableCell(""),
                                    ],
                                  );
                                }),
                                // Subtotal Row
                                TableRow(
                                  children: [
                                    const SizedBox(),
                                    tableCell("Subtotal:", align: TextAlign.right, weight: FontWeight.bold),
                                    tableCell(group.seriesQty.toStringAsFixed(0), weight: FontWeight.bold),
                                    const SizedBox(),
                                    tableCell("₹ ${group.seriesTotal.toStringAsFixed(2)}", weight: FontWeight.bold),
                                    const SizedBox(),
                                  ],
                                ),
                                // Disc Row
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.blue.shade50),
                                  children: [
                                    const SizedBox(),
                                    tableCell("Disc(%) :", align: TextAlign.right, weight: FontWeight.bold),
                                    tableCell(group.seriesDiscount.toStringAsFixed(2), align: TextAlign.center, weight: FontWeight.bold),
                                    const SizedBox(),
                                    const SizedBox(),
                                    tableCell("₹ ${group.afterDiscount.toStringAsFixed(4)}", weight: FontWeight.bold),
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
                            decoration: BoxDecoration(color: Colors.green.shade200),
                            children: [
                              const SizedBox(),
                              tableCell("Grand Total:", align: TextAlign.right, weight: FontWeight.bold),
                              tableCell(data.grandTotalQty.toStringAsFixed(0), weight: FontWeight.bold),
                              const SizedBox(),
                              tableCell("₹ ${data.grandTotal.toStringAsFixed(2)}", weight: FontWeight.bold),
                              const SizedBox(),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(color: Colors.cyan.shade100),
                            children: [
                              const SizedBox(),
                              tableCell("Total Discount:", align: TextAlign.right, weight: FontWeight.bold),
                              tableCell("${data.discountPercent.toStringAsFixed(2)}%", align: TextAlign.center, weight: FontWeight.bold),
                              const SizedBox(),
                              const SizedBox(),
                              tableCell("₹ ${data.afterDiscountTotal.toStringAsFixed(4)}", weight: FontWeight.bold),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                      Text("Invoice Created By: ${data.invoice.createdBy}", style: const TextStyle(fontWeight: FontWeight.bold)),
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
