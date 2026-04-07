import 'package:flutter/material.dart';
import '/Model/purchase_details_discount_invoice_model.dart';
import '/Service/purchase_details_discount_invoice_service.dart';
import 'package:share_plus/share_plus.dart';
import '/pdf/purchase_discount_invoice_pdf.dart';

class PurchaseDetailsDiscountInvoiceScreen extends StatefulWidget {
  final String billNo;

  const PurchaseDetailsDiscountInvoiceScreen({super.key, required this.billNo});

  @override
  State<PurchaseDetailsDiscountInvoiceScreen> createState() =>
      _PurchaseDetailsDiscountInvoiceScreenState();
}

class _PurchaseDetailsDiscountInvoiceScreenState
    extends State<PurchaseDetailsDiscountInvoiceScreen> {
  late Future<PurchaseDetailsDiscountInvoiceModel> future;

  @override
  void initState() {
    super.initState();
    future =
        PurchaseDetailsDiscountInvoiceService.fetchInvoice(widget.billNo);
  }

  Future<void> shareInvoice(PurchaseDetailsDiscountInvoiceModel data) async {
    final file = await PurchaseDiscountInvoicePdf.generate(data);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Invoice ${data.billNo}",
    );
  }

  // ================= COMMON =================

  Widget tableHeader(String text) => Padding(
    padding: const EdgeInsets.all(8),
    child: Text(text,
        textAlign: TextAlign.center,
        style:
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
  );

  Widget tableCell(String text,
      {TextAlign align = TextAlign.center,
        FontWeight weight = FontWeight.normal}) =>
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text,
            textAlign: align,
            style: TextStyle(fontSize: 12, fontWeight: weight)),
      );

  Widget infoCell(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: label,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            TextSpan(text: value, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget invoiceHeader(PurchaseDetailsDiscountInvoiceModel data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: const [
                Icon(Icons.menu_book_sharp, size: 45, color: Colors.brown),
                Text("BOOK WORLD",
                    style:
                    TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 40),
            Column(
              children: const [
                Text(
                  "GJ BOOK WORLD PVT. LTD.",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B4C7E)),
                ),
                SizedBox(height: 8),
                Text(
                  "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 9354918638, 9354918644",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(thickness: 2),
        const SizedBox(height: 10),

        const Text("Purchase Discount Invoice",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),

        const SizedBox(height: 10),

        Table(
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              infoCell("Invoice No: ", data.billNo),
              infoCell("Supplier: ", data.publication),
              infoCell("Bill Date: ", data.date.split("T")[0]),
            ]),
            TableRow(children: [
              infoCell("Supplier Invoice No: ", ""),
              infoCell("Address: ", "D-247/8 SECTOR63, NOIDA 201301"),
              infoCell("Rec. Date: ", data.date.split("T")[0]),
            ]),
            TableRow(children: [
              infoCell("Challan No: ", ""),
              infoCell("Transport: ", "SAFE EXPRESS"),
              infoCell("GR No: ", ""),
            ]),
          ],
        ),
      ],
    );
  }

  // ================= GROUP =================

  Map<String, List<PurchaseItem>> groupData(List<PurchaseItem> list) {
    final map = <String, List<PurchaseItem>>{};
    for (var item in list) {
      map.putIfAbsent(item.series, () => []).add(item);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 800
        ? MediaQuery.of(context).size.width - 32
        : 1000;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Purchase Invoice ${widget.billNo}"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share), // 🔥 PDF icon
            onPressed: () async {
              final data = await future;
              await shareInvoice(data);
            },
          ),
        ],

      ),

      body: FutureBuilder<PurchaseDetailsDiscountInvoiceModel>(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final grouped = groupData(data.data);

          int index = 1;
          double totalQty = 0;
          double totalAmount = 0;
          double totalDiscountAmount = 0;
          double totalAmtWithDisc = 0;

          for (var item in data.data) {
            totalQty += item.qty;
            totalAmount += item.totalAmount;
            
            double itemDiscAmount = item.totalAmount * (item.publicationDiscount / 100);
            double itemAmtWithDisc = item.totalAmount - itemDiscAmount;
            
            totalDiscountAmount += itemDiscAmount;
            totalAmtWithDisc += itemAmtWithDisc;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: width,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.white,
                  child: Column(
                    children: [
                      invoiceHeader(data),
                      const SizedBox(height: 15),

                      /// TABLE
                      Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FixedColumnWidth(40),
                          1: FlexColumnWidth(4),
                          2: FixedColumnWidth(50),
                          3: FixedColumnWidth(70),
                          4: FixedColumnWidth(90),
                          5: FixedColumnWidth(100),
                        },
                        children: [
                          TableRow(
                            decoration:
                            BoxDecoration(color: Colors.grey.shade200),
                            children: [
                              tableHeader("S.N."),
                              tableHeader("Book Name (Title)"),
                              tableHeader("Qty"),
                              tableHeader("Rate"),
                              tableHeader("Amount"),
                              tableHeader("Amt With Disc."),
                            ],
                          ),

                          ...grouped.entries.expand((entry) {
                            final series = entry.key;
                            final items = entry.value;

                            double subQty = 0;
                            double subAmount = 0;
                            double subDiscAmount = 0;
                            double subAmtWithDisc = 0;

                            List<TableRow> rows = [
                              TableRow(
                                decoration:
                                BoxDecoration(color: Colors.grey.shade50),
                                children: [
                                  const SizedBox(),
                                  tableCell("Series: $series",
                                      align: TextAlign.left,
                                      weight: FontWeight.bold),
                                  const SizedBox(),
                                  const SizedBox(),
                                  const SizedBox(),
                                  const SizedBox(),
                                ],
                              ),
                            ];

                            for (var e in items) {
                              subQty += e.qty;
                              subAmount += e.totalAmount;
                              
                              double itemDiscAmount = e.totalAmount * (e.publicationDiscount / 100);
                              double itemAmtWithDisc = e.totalAmount - itemDiscAmount;
                              
                              subDiscAmount += itemDiscAmount;
                              subAmtWithDisc += itemAmtWithDisc;

                              rows.add(TableRow(children: [
                                tableCell("${index++}"),
                                tableCell(
                                    "${e.bookName} - ${e.subject} - ${e.classes}",
                                    align: TextAlign.left),
                                tableCell(e.qty.toString()),
                                tableCell(e.rate.toStringAsFixed(2)),
                                tableCell(e.totalAmount.toStringAsFixed(2)),
                                tableCell(itemAmtWithDisc.toStringAsFixed(2)),
                              ]));
                            }

                            double avgDiscSeries = subAmount > 0 ? (subDiscAmount / subAmount) * 100 : 0;

                            /// SUBTOTAL
                            rows.add(
                              TableRow(
                                decoration:
                                BoxDecoration(color: Colors.orange.shade50),
                                children: [
                                  const SizedBox(),
                                  tableCell("Subtotal:",
                                      align: TextAlign.right,
                                      weight: FontWeight.bold),
                                  tableCell(subQty.toString(),
                                      weight: FontWeight.bold),
                                  const SizedBox(),
                                  tableCell("₹ ${subAmount.toStringAsFixed(2)}",
                                      weight: FontWeight.bold),
                                  const SizedBox(),
                                ],
                              ),
                            );

                            /// DISC(%) FOR SERIES
                            rows.add(
                              TableRow(
                                decoration: BoxDecoration(color: Colors.blue.shade50),
                                children: [
                                  const SizedBox(),
                                  tableCell("Disc(%):",
                                      align: TextAlign.right, weight: FontWeight.bold),
                                  tableCell(avgDiscSeries.toStringAsFixed(1), weight: FontWeight.bold),
                                  const SizedBox(),
                                  const SizedBox(),
                                  tableCell("₹ ${subAmtWithDisc.toStringAsFixed(2)}", weight: FontWeight.bold),
                                ],
                              ),
                            );

                            return rows;
                          }),

                          /// GRAND TOTAL
                          TableRow(
                            decoration:
                            BoxDecoration(color: Colors.green.shade100),
                            children: [
                              const SizedBox(),
                              tableCell("Grand Total:",
                                  align: TextAlign.right,
                                  weight: FontWeight.bold),
                              tableCell(totalQty.toString(),
                                  weight: FontWeight.bold),
                              const SizedBox(),
                              tableCell("₹ ${totalAmount.toStringAsFixed(2)}",
                                  weight: FontWeight.bold),
                              const SizedBox(),
                            ],
                          ),

                          /// TOTAL DISCOUNT
                          TableRow(
                            decoration: BoxDecoration(color: Colors.cyan.shade100),
                            children: [
                              const SizedBox(),
                              tableCell("Total Discount:",
                                  align: TextAlign.right, weight: FontWeight.bold),
                              tableCell(totalAmount > 0 ? "${((totalDiscountAmount / totalAmount) * 100).toStringAsFixed(1)}%" : "0%", weight: FontWeight.bold),
                              const SizedBox(),
                              const SizedBox(),
                              tableCell("₹ ${totalAmtWithDisc.toStringAsFixed(2)}", weight: FontWeight.bold),
                            ],
                          ),

                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// LEFT SIDE
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Invoice Created By: Admin",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text("Time Taken: 1 min 1 sec",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),

                          /// RIGHT SIDE
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("After Discount: ₹ ${totalAmtWithDisc.toStringAsFixed(2)}",
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                              const SizedBox(height: 5),
                              Text(
                                "Total Discount Amount: ₹ ${totalDiscountAmount.toStringAsFixed(2)}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
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