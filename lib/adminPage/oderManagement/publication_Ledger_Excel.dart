import 'package:flutter/material.dart';
import '../../Model/publication_order_model.dart';
import '../../Service/publication_order_service.dart';

class PublicationOrderPage extends StatefulWidget {
  final String senderId;

  const PublicationOrderPage({
    super.key,
    required this.senderId,
  });

  @override
  State<PublicationOrderPage> createState() => _PublicationOrderPageState();
}

class _PublicationOrderPageState extends State<PublicationOrderPage> {
  late Future<PublicationOrderResponse> futureOrder;

  @override
  void initState() {
    super.initState();
    futureOrder = PublicationOrderService.fetchOrder(widget.senderId);
  }

  int getSubtotalQty(List<OrderItem> items) {
    return items.fold(0, (sum, item) => sum + item.qty);
  }

  double getSubtotalAmount(List<OrderItem> items) {
    return items.fold(0, (sum, item) => sum + item.totalAmount);
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
    1: FlexColumnWidth(1.5), // Series
    2: FlexColumnWidth(3.0), // Book Name
    3: FlexColumnWidth(0.8), // Class
    4: FlexColumnWidth(1.2), // Subject
    5: FlexColumnWidth(0.8), // Qty
    6: FlexColumnWidth(1.0), // Rate
    7: FlexColumnWidth(1.2), // Amount
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Background around the invoice
      appBar: AppBar(
        title: const Text("Publication Ledger"),
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<PublicationOrderResponse>(
        future: futureOrder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final items = data.items;
          final details = data.orderDetails;

          final subtotalQty = getSubtotalQty(items);
          final subtotalAmount = getSubtotalAmount(items);

          // Group items by Series
          Map<String, List<OrderItem>> groupedItems = {};
          for (var item in items) {
            groupedItems.putIfAbsent(item.series, () => []).add(item);
          }

          int globalIndex = 1;

          double screenWidth = MediaQuery.of(context).size.width;
          double invoiceWidth = screenWidth > 800 ? screenWidth - 32 : 1000; // Set explicit invoice minimum width

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: invoiceWidth,
                child: Container(
                  // Main Invoice Card
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
                      // Placeholder for logo
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
                            "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 9354918644, 9354918638",
                            style: TextStyle(fontSize: 12, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "GST No: 09AAGCG0650B1Z2 | CIN No: U22222UP2015PTC068597",
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
                      "Publication Order Details",
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
                        infoCell("Order No: ", details.orderNo),
                        infoCell("Supplier: ", details.supplier),
                        infoCell("Bill Date: ", details.billDate),
                      ]),
                      TableRow(children: [
                        infoCell("Booking From : ", details.bookingFrom),
                        infoCell("Address: ", details.address),
                        infoCell("GR No: ", ""),
                      ]),
                      TableRow(children: [
                        infoCell("Transport MoNo: ", ""),
                        infoCell("Remark: ", ""),
                        infoCell("Bundal: ", ""),
                      ]),
                      TableRow(children: [
                        infoCell("Received From : ", ""),
                        infoCell("MobNo: ", ""),
                        infoCell("PaymentType: ", ""),
                      ]),
                      TableRow(children: [
                        infoCell("Amount: ", ""),
                        infoCell("LabourCharge: ", ""),
                        infoCell("DeliveryCharge: ", ""),
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
                          tableHeaderCell("Series"),
                          tableHeaderCell("Book Name"),
                          tableHeaderCell("Class"),
                          tableHeaderCell("Subject"),
                          tableHeaderCell("Qty"),
                          tableHeaderCell("Rate"),
                          tableHeaderCell("Amount"),
                        ],
                      ),
                    ],
                  ),

                  /// ITEMS GROUPS
                  ...groupedItems.entries.map((group) {
                    final seriesName = group.key;
                    final groupItems = group.value;

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
                              Text("Series: $seriesName", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                              Text("Publication: ${details.supplier}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
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
                          children: groupItems.map((item) {
                            int currentIndex = globalIndex++;
                            return TableRow(
                              children: [
                                tableDataCell(currentIndex.toString()),
                                tableDataCell(item.series),
                                tableDataCell(item.bookName),
                                tableDataCell(item.classes.replaceAll('Class ', '')), // Keep compact like UI
                                tableDataCell(item.subject),
                                tableDataCell(item.qty.toString()),
                                tableDataCell(item.rate.toStringAsFixed(2)),
                                tableDataCell(item.totalAmount.toStringAsFixed(2)),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }).toList(),

                  /// TOTALS BOTTOM ROWS
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
                      // Subtotal
                      TableRow(
                        children: [
                          const SizedBox(), const SizedBox(), const SizedBox(), const SizedBox(),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                            child: Text("Subtotal:", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                            child: Text(subtotalQty.toString(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            child: Text("₹\n${subtotalAmount.toStringAsFixed(2)}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      // Grand Total
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFFCFF4D2)), // Soothing green fill
                        children: [
                          const SizedBox(), const SizedBox(), const SizedBox(), const SizedBox(),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                            child: Text("Grand Total:", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                            child: Text(subtotalQty.toString(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                          const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            child: Text("₹\n${subtotalAmount.toStringAsFixed(2)}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green)),
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
                          Text("Admin", style: TextStyle(fontSize: 14, color: Colors.grey.shade800)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Vector Signature Stamp Placeholder
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