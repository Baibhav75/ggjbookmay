import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/Model/purchase_invoice_mrp_model.dart';
import '/Service/purchase_invoice_service.dart';
import 'package:share_plus/share_plus.dart';
import '/pdf/invoice_pdf.dart';


class PurchaseInvoicePage extends StatefulWidget {
  final String billNo;

  const PurchaseInvoicePage({super.key, required this.billNo});

  @override
  State<PurchaseInvoicePage> createState() => _PurchaseInvoicePageState();
}

class _PurchaseInvoicePageState extends State<PurchaseInvoicePage> {
  late Future<PurchaseInvoiceMrpModel> invoiceFuture;

  @override
  void initState() {
    super.initState();
    invoiceFuture = PurchaseInvoiceMrpService.getInvoice(widget.billNo);
  }
  Future<void> shareInvoice(PurchaseInvoiceMrpModel invoice) async {
    final file = await PurchaseInvoicePdf.generate(invoice);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Purchase Invoice ${invoice.billNo}",
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Purchase Invoice"),
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final invoice = await invoiceFuture;
              await shareInvoice(invoice);
            },
          ),
        ],
      ),
      body: FutureBuilder<PurchaseInvoiceMrpModel>(
        future: invoiceFuture,
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

          return SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Center(
                child: Container(
                  width: 850, // Fixed width to ensure tabular layout doesn't break
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 16),
                          _buildInvoiceTitle(),
                          const SizedBox(height: 16),
                          _buildInfoTable(invoice),
                          const SizedBox(height: 16),
                          _buildItemsTable(invoice),
                          const SizedBox(height: 24),
                          _buildFooter(invoice),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Icon(Icons.menu_book, size: 40, color: Colors.brown.shade700),
            const Text(
              "GJ\nBOOK WORLD",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(width: 30),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "GJ BOOK WORLD PVT. LTD.",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Text(
                "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 9354918638, 9354918644\nGST No: 09AAGCG0650B1Z2 | CIN No: U22222UP2015PTC068597",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(width: 80), // To balance the header center
      ],
    );
  }

  Widget _buildInvoiceTitle() {
    return Column(
      children: [
        const Divider(color: Colors.black, thickness: 1.5, height: 1.5),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            "Purchase MRP Invoice",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildInfoTable(PurchaseInvoiceMrpModel invoice) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(invoice.date);
    return Table(
      border: TableBorder.all(color: Colors.grey.shade800, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            _infoCell("Invoice No: ", invoice.billNo),
            _infoCell("Supplier: ", invoice.publication),
            _infoCell("Bill Date: ", formattedDate),
          ],
        ),
        TableRow(
          children: [
            _infoCell("Supplier Invoice No: ", "2254"),
            _infoCell("Address: ", "NO"),
            _infoCell("Rec. Date: ", formattedDate),
          ],
        ),
        TableRow(
          children: [
            _infoCell("ChallanNo: ", ""),
            _infoCell("Transport: ", "MITTAL ROADWAYS"),
            _infoCell("GR No: ", "OO37822"),
          ],
        ),
        TableRow(
          children: [
            _infoCell("Recived Box: ", "7"),
            _infoCell("", ""), // Empty cell
            _infoCell("Pending Box: ", ""),
          ],
        ),
      ],
    );
  }

  Widget _infoCell(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTable(PurchaseInvoiceMrpModel invoice) {
    Map<String, List<PurchaseItem>> groupedItems = {};
    for (var item in invoice.data) {
      if (!groupedItems.containsKey(item.series)) {
        groupedItems[item.series] = [];
      }
      groupedItems[item.series]!.add(item);
    }

    List<TableRow> rows = [];

    // Header Row
    rows.add(
      TableRow(
        decoration: BoxDecoration(color: Colors.grey.shade100),
        children: [
          _headerCell("S.N.", isBold: true),
          _headerCell("Book Name (Title)", isBold: true),
          _headerCell("Qty", isBold: true),
          _headerCell("Rate", isBold: true),
          _headerCell("Amount", isBold: true),
          _headerCell("Amt With\nDisc.", isBold: true),
        ],
      ),
    );

    int sn = 1;
    double totalQty = 0;
    double totalAmount = 0;

    groupedItems.forEach((series, items) {
      // Series Header Row
      rows.add(
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: [
            const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: Text(
                "Series: $series",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
              ),
            ),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
          ],
        ),
      );

      // Books in Series
      for (var item in items) {
        double amount = item.qty * item.rate;
        totalQty += item.qty;
        totalAmount += amount;

        rows.add(
          TableRow(
            children: [
              _itemCell(sn.toString(), align: TextAlign.center),
              _itemCell("${item.bookName} - ${item.subject} - Class ${item.classes}"),
              _itemCell(item.qty.toString(), align: TextAlign.center),
              _itemCell(item.rate.toStringAsFixed(2), align: TextAlign.right),
              _itemCell(amount.toStringAsFixed(2), align: TextAlign.right),
              _itemCell(""), // Amt With Disc placeholder
            ],
          ),
        );
        sn++;
      }
    });

    // Subtotal Row
    rows.add(
      TableRow(
        children: [
          const SizedBox(),
          _itemCell("Subtotal:", align: TextAlign.right, isBold: true),
          _itemCell(totalQty.toStringAsFixed(0), align: TextAlign.center, isBold: true),
          const SizedBox(),
          _itemCell("₹ ${totalAmount.toStringAsFixed(2)}", align: TextAlign.right, isBold: true),
          const SizedBox(),
        ],
      ),
    );

    // Disc(%) Row
    rows.add(
      TableRow(
        decoration: BoxDecoration(color: Colors.blue.shade50),
        children: [
          const SizedBox(),
          _itemCell("Disc(%) :", align: TextAlign.right, isBold: true),
          _itemCell("0", align: TextAlign.center, isBold: true), // Placeholder
          const SizedBox(),
          const SizedBox(),
          _itemCell("₹ ${totalAmount.toStringAsFixed(2)}", align: TextAlign.right, isBold: true), // Placeholder
        ],
      ),
    );

    // Grand Total Row
    rows.add(
      TableRow(
        decoration: BoxDecoration(color: Colors.green.shade100),
        children: [
          const SizedBox(),
          _itemCell("Grand Total:", align: TextAlign.right, isBold: true),
          _itemCell(totalQty.toStringAsFixed(0), align: TextAlign.center, isBold: true),
          const SizedBox(),
          _itemCell("₹ ${totalAmount.toStringAsFixed(2)}", align: TextAlign.center, isBold: true),
          const SizedBox(),
        ],
      ),
    );

    // Total Discount Row
    rows.add(
      TableRow(
        decoration: BoxDecoration(color: Colors.lightBlue.shade100),
        children: [
          const SizedBox(),
          _itemCell("Total Discount:", align: TextAlign.right, isBold: true),
          _itemCell("0%", align: TextAlign.center, isBold: true),
          const SizedBox(),
          const SizedBox(),
          _itemCell("₹ ${totalAmount.toStringAsFixed(2)}", align: TextAlign.right, isBold: true),
        ],
      ),
    );

    return Table(
      border: TableBorder.all(color: Colors.grey.shade800, width: 1),
      columnWidths: const {
        0: FixedColumnWidth(40),
        1: FlexColumnWidth(4),
        2: FixedColumnWidth(50),
        3: FixedColumnWidth(70),
        4: FixedColumnWidth(100),
        5: FixedColumnWidth(100),
      },
      children: rows,
    );
  }

  Widget _headerCell(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _itemCell(String text, {TextAlign align = TextAlign.left, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildFooter(PurchaseInvoiceMrpModel invoice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.black87),
                children: [
                  TextSpan(text: "Invoice Created By: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "Admin"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.black87),
                children: [
                  TextSpan(text: "Time Taken: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "1 min 55 sec"), // Placeholder
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                children: [
                  const TextSpan(text: "After Discount: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "₹ ${invoice.grandTotal.toStringAsFixed(2)}"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(text: "Total Discount Amount: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "₹ 0.00"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
