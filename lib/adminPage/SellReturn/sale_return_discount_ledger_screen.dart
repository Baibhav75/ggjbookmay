import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../pdf/SaleReturn/sale_return_discount_ledger_pdf.dart';
import '/Model/sale_return_discount_ledger_model.dart';
import '../../Service/sale_return_discount_ledger_service.dart';
import 'SaleReturnMRPDescountInvoice.dart';

class SaleReturnDiscountLedgerScreen extends StatefulWidget {

  final String schoolId;

  const SaleReturnDiscountLedgerScreen({
    super.key,
    required this.schoolId,
  });

  @override
  State<SaleReturnDiscountLedgerScreen> createState() =>
      _SaleReturnDiscountLedgerScreenState();
}

class _SaleReturnDiscountLedgerScreenState
    extends State<SaleReturnDiscountLedgerScreen> {

  late Future<SaleReturnDiscountLedgerResponse?> future;

  @override
  void initState() {
    super.initState();
    future = SaleReturnDiscountLedgerService.fetchLedger(widget.schoolId);
  }

  Widget cell(
      String text, {
        bool bold = false,
        TextAlign align = TextAlign.center,
        Color? color,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 12,
          color: color ?? Colors.black87,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sale Return Discount Ledger"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {

                final data = await future;

                if (data != null) {
                  await shareLedgerPdf(data);
                }
              },
            ),
          ]
      ),
      body: FutureBuilder<SaleReturnDiscountLedgerResponse?>(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!;
          String statementDate = "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1000,
                child: Container(
                  color: Colors.white,
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
                          const SizedBox(width: 120),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Divider(color: Colors.black, thickness: 1),
                      const SizedBox(height: 12),

                      Center(
                        child: Text(
                          "SALE RETURN DISCOUNT LEDGER STATEMENT",
                          style: TextStyle(
                            color: Colors.indigo.shade900,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// PARTY INFO
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(right: BorderSide(color: Colors.black87)),
                                    ),
                                    child: _infoCell("Party Name: ", data.school.accName, valueBold: true, align: TextAlign.center),
                                  ),
                                ),
                                Expanded(
                                  child: _infoCell("Address: ", data.school.address, align: TextAlign.center),
                                ),
                              ],
                            ),
                            const Divider(height: 1, thickness: 1, color: Colors.black87),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black87, fontSize: 12),
                                  children: [
                                    const TextSpan(text: "Date: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                                    TextSpan(text: statementDate, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// MAIN LEDGER TABLE
                      Table(
                        border: TableBorder.all(color: Colors.black87),
                        columnWidths: const {
                          0: FixedColumnWidth(100),
                          1: FlexColumnWidth(3),
                          2: FixedColumnWidth(140),
                          3: FixedColumnWidth(140),
                          4: FixedColumnWidth(160),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                            ),
                            children: [
                              cell("Date", bold: true),
                              cell("Particulars", bold: true),
                              cell("Debit", bold: true, align: TextAlign.right),
                              cell("Credit", bold: true, align: TextAlign.right),
                              cell("Balance", bold: true, align: TextAlign.right),
                            ],
                          ),

                          ...data.data.map((e) {
                            final isReturn = e.type.toLowerCase().contains("sale return");

                            return TableRow(
                              children: [
                                cell(e.date),
                                GestureDetector(
                                  onTap: isReturn
                                      ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ViewSaleReturnDetailScreen(
                                          billNo: e.vchNo,
                                        ),
                                      ),
                                    );
                                  }
                                      : null,
                                  child: cell(
                                    e.particulars,
                                    color: isReturn ? Colors.blue : Colors.black87,
                                    align: TextAlign.center,
                                    bold: isReturn,
                                  ),
                                ),
                                cell(
                                  e.debit == null || e.debit == 0 ? "" : "₹ ${e.debit!.toStringAsFixed(2)}",
                                  align: TextAlign.right,
                                ),
                                cell(
                                  e.credit == null || e.credit == 0 ? "" : "₹ ${e.credit!.toStringAsFixed(2)}",
                                  align: TextAlign.right,
                                ),
                                cell(
                                  "₹ ${e.balance.toStringAsFixed(2)}",
                                  align: TextAlign.right,
                                ),
                              ],
                            );
                          }),

                          /// TOTAL ROW
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                            ),
                            children: [
                              cell(""),
                              cell("TOTAL", bold: true, align: TextAlign.right),
                              cell(
                                "₹ ${data.totalDebit.toStringAsFixed(2)}",
                                bold: true, align: TextAlign.right
                              ),
                              cell(
                                "₹ ${data.totalCredit.toStringAsFixed(2)}",
                                bold: true, align: TextAlign.right
                              ),
                              cell(""),
                            ],
                          ),

                          /// CLOSING BALANCE ROW
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                            ),
                            children: [
                              cell(""),
                              cell("Closing Balance", bold: true, align: TextAlign.right),
                              cell(""),
                              cell(""),
                              cell(
                                "₹ ${data.closingBalance.toStringAsFixed(2)}",
                                bold: true, align: TextAlign.right,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
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

  Future<void> shareLedgerPdf(
      SaleReturnDiscountLedgerResponse data) async {

    final file =
    await SaleReturnDiscountLedgerPdf.generate(data);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Sale Return Discount Ledger",
    );
  }
}