import 'package:flutter/material.dart';
import '../../Model/billno_invoice_model.dart';
import '../../Service/billno_invoice_service.dart';

class ViewOrderDetails extends StatefulWidget {
  final String billNo;

  const ViewOrderDetails({super.key, required this.billNo});

  @override
  State<ViewOrderDetails> createState() => _ViewOrderDetailsState();
}

class _ViewOrderDetailsState extends State<ViewOrderDetails> {
  late Future<BillNoInvoiceModel> _invoiceFuture;

  @override
  void initState() {
    super.initState();
    _invoiceFuture = BillNoInvoiceService.fetchInvoice(widget.billNo);
  }

  Widget infoCell(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
            TextSpan(text: value, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget tableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 12),
      ),
    );
  }

  Widget tableDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  final itemColumnWidths = const {
    0: FlexColumnWidth(0.6), // S.N
    1: FlexColumnWidth(3.0), // Book Name
    2: FlexColumnWidth(1.2), // Subject
    3: FlexColumnWidth(1.0), // Class
    4: FlexColumnWidth(0.8), // Qty
    5: FlexColumnWidth(1.0), // Rate
    6: FlexColumnWidth(1.2), // Amount
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double invoiceWidth = screenWidth > 800 ? screenWidth - 32 : 1000;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Invoice ${widget.billNo}"),
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<BillNoInvoiceModel>(
        future: _invoiceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No Data Found"));
          }

          final invoice = snapshot.data!;
          final header = invoice.data.header;
          int globalIndex = 1;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: invoiceWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER SECTION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: const [
                              Icon(Icons.menu_book_sharp, size: 45, color: Colors.brown),
                              Text("BOOK WORLD", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                "GJ BOOK WORLD PVT. LTD.",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: 1.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 7905891950, 8303173798",
                                style: TextStyle(fontSize: 12, color: Colors.black87),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "GST No: 09AAGCG6058B1Z2 | CIN No: U22222UP2015PTC068597",
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(color: Colors.black26, thickness: 1),
                      const SizedBox(height: 12),

                      /// TITLE
                      const Center(
                        child: Text(
                          "Sale MRP Invoice",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// INFO DETAILS TABLE
                      Table(
                        border: TableBorder.all(color: Colors.black87, width: 0.8),
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1.6),
                          2: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            infoCell("Invoice No: ", header.invoiceNo),
                            infoCell("Party Name: ", header.schoolName),
                            infoCell("Bill Date: ", header.billDate.toString().split(' ')[0]),
                          ]),
                          TableRow(children: [
                            infoCell("Transport : ", header.transport),
                            infoCell("Address: ", header.address),
                            infoCell("GR No: ", ""),
                          ]),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// ITEMS TABLE HEADER
                      Table(
                        border: TableBorder.all(color: Colors.black87, width: 0.8),
                        columnWidths: itemColumnWidths,
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFFF7F7F7)),
                            children: [
                              tableHeaderCell("S.N."),
                              tableHeaderCell("Book Name"),
                              tableHeaderCell("Subject"),
                              tableHeaderCell("Class"),
                              tableHeaderCell("Qty"),
                              tableHeaderCell("Rate"),
                              tableHeaderCell("Amount"),
                            ],
                          ),
                        ],
                      ),

                      /// ITEMS GROUPS
                      ...invoice.data.publications.map((pub) {
                        return Column(
                          children: [
                            // Group Span Header
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Colors.black87, width: 0.8),
                                  right: BorderSide(color: Colors.black87, width: 0.8),
                                  bottom: BorderSide(color: Colors.black87, width: 0.8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Series: ${pub.series}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                                  Text("Publication: ${pub.publicationName}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                                ],
                              ),
                            ),
                            // Items List
                            Table(
                              border: const TableBorder(
                                left: BorderSide(color: Colors.black87, width: 0.8),
                                right: BorderSide(color: Colors.black87, width: 0.8),
                                bottom: BorderSide(color: Colors.black87, width: 0.8),
                                verticalInside: BorderSide(color: Colors.black87, width: 0.8),
                                horizontalInside: BorderSide(color: Colors.black87, width: 0.8),
                              ),
                              columnWidths: itemColumnWidths,
                              children: [
                                ...pub.items.map((item) {
                                  int currentIndex = globalIndex++;
                                  return TableRow(
                                    children: [
                                      tableDataCell(currentIndex.toString()),
                                      tableDataCell(item.bookName),
                                      tableDataCell(item.subject),
                                      tableDataCell(item.className.replaceAll('Class ', '')),
                                      tableDataCell(item.qty.toString()),
                                      tableDataCell(item.rate.toStringAsFixed(2)),
                                      tableDataCell(item.amount.toStringAsFixed(2)),
                                    ],
                                  );
                                }).toList(),
                                // Subtotal Row for Publication
                                TableRow(
                                  children: [
                                    const SizedBox(), const SizedBox(), const SizedBox(),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                      child: Text("Subtotal:", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                      child: Text(pub.totalQty.toString(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                    const SizedBox(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                                      child: Text("₹ ${pub.subTotal.toStringAsFixed(2)}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),

                      /// GRAND TOTAL BOTTOM ROW
                      Table(
                        border: const TableBorder(
                          left: BorderSide(color: Colors.black87, width: 0.8),
                          right: BorderSide(color: Colors.black87, width: 0.8),
                          bottom: BorderSide(color: Colors.black87, width: 0.8),
                          verticalInside: BorderSide(color: Colors.black87, width: 0.8),
                          horizontalInside: BorderSide(color: Colors.black87, width: 0.8),
                        ),
                        columnWidths: itemColumnWidths,
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFFCFF4D2)), // Soothing green
                            children: [
                              const SizedBox(), const SizedBox(), const SizedBox(),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                child: Text("Grand Total:", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                child: Text(invoice.data.summary.grandQty.toString(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                              const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                                child: Text("₹ ${invoice.data.summary.grandTotal.toStringAsFixed(2)}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green)),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),

                      /// SIGNATORY FOOTER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Invoice Created By:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 8),
                              const Text("SUJITA SHARMA", style: TextStyle(fontSize: 14, color: Colors.black54)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black26, width: 1.5),
                                ),
                                alignment: Alignment.center,
                                child: Transform.rotate(
                                  angle: -0.1,
                                  child: const Text(
                                    "AUTHORISED\nSIGNATORY",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 8, color: Colors.black38, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
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