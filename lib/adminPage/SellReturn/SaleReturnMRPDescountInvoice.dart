import 'package:flutter/material.dart';
import '';
import '../../Model/view_sale_return_detail_model.dart';
import '../../Service/view_sale_return_detail_service.dart';
class ViewSaleReturnDetailScreen extends StatefulWidget {


  final String billNo;

  const ViewSaleReturnDetailScreen({
    super.key,
    required this.billNo,
  });

  @override
  State<ViewSaleReturnDetailScreen> createState() =>
      _ViewSaleReturnDetailScreenState();
}

class _ViewSaleReturnDetailScreenState
    extends State<ViewSaleReturnDetailScreen> {

  late Future<ViewSaleReturnDetailResponse?> future;

  @override
  void initState() {
    super.initState();
    future = ViewSaleReturnDetailService.fetchDetail(widget.billNo);
  }

  Widget cell(
      String text, {
        bool bold = false,
        TextAlign align = TextAlign.center,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 11,
          color: Colors.black87,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _infoCell(String title, String value, {bool valueBold = false, TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: RichText(
        textAlign: align,
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 12),
          children: [
            TextSpan(text: title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
            TextSpan(text: value, style: TextStyle(fontWeight: valueBold ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  final Map<int, TableColumnWidth> _tableWidths = const {
    0: FixedColumnWidth(40),
    1: FlexColumnWidth(),
    2: FixedColumnWidth(40),
    3: FixedColumnWidth(60),
    4: FixedColumnWidth(85),
    5: FixedColumnWidth(45),
    6: FixedColumnWidth(70),
    7: FixedColumnWidth(100),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text(
          "Sale Return Invoice",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<ViewSaleReturnDetailResponse?>(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          int srNo = 1;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Column(
                            children: const [
                              Text("GJ", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black87)),
                              Icon(Icons.menu_book, size: 28, color: Colors.black87),
                              Text("BOOK WORLD", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "GJ BOOK WORLD PVT. LTD.",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo.shade900),
                              ),
                              const SizedBox(height: 6),
                              const Text("D-1/20, SECTOR 22, GIDA, GORAKHPUR", style: TextStyle(fontSize: 13, color: Colors.black87)),
                              const Text("Cont. - 9354918638, 9354918644", style: TextStyle(fontSize: 13, color: Colors.black87)),
                              const Text("GST No: 09AAGCG0650B1Z2 | CIN No: U22222UP2015PTC068597", style: TextStyle(fontSize: 13, color: Colors.black54)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 120), // To balance the left logo
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(color: Colors.black, thickness: 1),
                    const SizedBox(height: 12),

                    const Center(
                      child: Text(
                        "SALE RETURN DISCOUNT INVOICE",
                        style: TextStyle(
                          color: Color(0xFFF93248), // Match the bright red from the image
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// PARTY INFO
                    Table(
                      border: TableBorder.all(color: Colors.black87),
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(1.2),
                      },
                      children: [
                        TableRow(
                          children: [
                            _infoCell("Invoice No: ", data.invoice.billNo, align: TextAlign.center),
                            _infoCell("Party Name: ", data.invoice.partyName, valueBold: true, align: TextAlign.center),
                            _infoCell("Bill Date: ", data.invoice.billDate, align: TextAlign.center),
                          ],
                        ),
                        TableRow(
                          children: [
                            _infoCell("Transport: ", data.invoice.transport, align: TextAlign.center),
                            _infoCell("Address: ", data.invoice.address, align: TextAlign.center),
                            _infoCell("Rec. Date: ", data.invoice.recDate, align: TextAlign.center),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// MAIN TABLE HEADER
                    Table(
                      border: TableBorder.all(color: Colors.black87),
                      columnWidths: _tableWidths,
                      children: [
                        TableRow(
                          children: [
                            cell("S.N.", bold: true),
                            cell("Book Name (Title)", bold: true),
                            cell("Qty", bold: true),
                            cell("Rate", bold: true),
                            cell("Amount", bold: true),
                            cell("Disc\n%", bold: true),
                            cell("Disc\nAmt", bold: true),
                            cell("Net Amount", bold: true),
                          ],
                        ),
                      ],
                    ),

                    /// SERIES LOOP
                    ...data.seriesGroups.map((group) {
                      return Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.black87),
                                right: BorderSide(color: Colors.black87),
                                bottom: BorderSide(color: Colors.black87),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Series: ${group.series}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),
                                ),
                                Text(
                                  "Publication: ${group.publication}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Table(
                            border: const TableBorder(
                              left: BorderSide(color: Colors.black87),
                              right: BorderSide(color: Colors.black87),
                              bottom: BorderSide(color: Colors.black87),
                              verticalInside: BorderSide(color: Colors.black87),
                              horizontalInside: BorderSide(color: Colors.black87),
                            ),
                            columnWidths: _tableWidths,
                            children: [
                              ...group.items.map((item) {
                                return TableRow(
                                  children: [
                                    cell("${srNo++}"),
                                    cell(item.bookName, align: TextAlign.left),
                                    cell("${item.qty}"),
                                    cell(item.rate.toStringAsFixed(2)),
                                    cell("₹ ${item.amount.toStringAsFixed(2)}"),
                                    cell("${item.discount.toStringAsFixed(2)}\n%"),
                                    cell("₹\n${item.discountAmt.toStringAsFixed(4)}"),
                                    cell("₹ ${item.netAmount.toStringAsFixed(4)}"),
                                  ],
                                );
                              }),
                              /// SERIES SUBTOTAL
                              TableRow(
                                children: [
                                  cell(""),
                                  cell("Subtotal:", align: TextAlign.right, bold: true),
                                  cell("${group.seriesQty}", bold: true),
                                  cell(""),
                                  cell("₹\n${group.seriesTotal.toStringAsFixed(2)}", bold: true),
                                  cell(""),
                                  cell("₹\n${group.seriesDiscountAmount.toStringAsFixed(4)}", bold: true),
                                  cell("₹\n${group.seriesNetAmount.toStringAsFixed(4)}", bold: true),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }),

                    /// GRAND TOTAL
                    Table(
                      border: const TableBorder(
                        left: BorderSide(color: Colors.black87),
                        right: BorderSide(color: Colors.black87),
                        bottom: BorderSide(color: Colors.black87),
                        verticalInside: BorderSide(color: Colors.black87),
                        horizontalInside: BorderSide(color: Colors.black87),
                      ),
                      columnWidths: _tableWidths,
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFFCCFFCC), // Light green background from the image
                          ),
                          children: [
                            cell(""),
                            cell("Grand Total:", align: TextAlign.right, bold: true),
                            cell("${data.grandTotalQty}", bold: true),
                            cell(""),
                            cell("₹ ${data.grandTotal.toStringAsFixed(2)}", bold: true),
                            cell(""),
                            cell("₹ ${data.totalDiscountAmount.toStringAsFixed(2)}", bold: true),
                            cell("₹ ${data.finalAmount.toStringAsFixed(2)}", bold: true),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}