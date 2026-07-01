import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/PurchasePubDiscountLedger_model.dart';
import '../../Service/PurchasePubDiscountLedger_service.dart';

class PurchasePubDiscountLedgerScreen extends StatefulWidget {
  final String partyId;

  const PurchasePubDiscountLedgerScreen({super.key, required this.partyId});

  @override
  State<PurchasePubDiscountLedgerScreen> createState() =>
      _PurchasePubDiscountLedgerScreenState();
}

class _PurchasePubDiscountLedgerScreenState
    extends State<PurchasePubDiscountLedgerScreen> {
  late Future<PurchasePubDiscountLedgerResponse?> future;

  @override
  void initState() {
    super.initState();
    future = PurchasePubDiscountLedgerService.fetchLedger(widget.partyId);
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) return "";
    try {
      DateTime dt = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (e) {
      return dateString;
    }
  }

  String formatCurrency(double amount) {
    if (amount == 0.0) return "";
    return "₹ ${amount.toStringAsFixed(2)}";
  }

  Widget tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget tableCell(String text,
      {TextAlign align = TextAlign.center,
      FontWeight weight = FontWeight.normal,
      Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(fontSize: 13, fontWeight: weight, color: color),
      ),
    );
  }

  Widget reportHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Assuming there's a logo or just text based on the image
            Expanded(
              child: Column(
                children: [
                  const Text(
                    "GJ BOOK WORLD PVT. LTD.",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B4C7E)),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 0551-2320642\nGST No: 09AAGC0650B1Z2 | CIN No: U22222UP2015PTC068597",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.black87, thickness: 1.5),
        const SizedBox(height: 10),
        const Text(
          "VENDOR DISCOUNT LEDGER",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B46C1),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF6c46d5)),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double reportWidth = screenWidth > 800 ? screenWidth - 32 : 900;

    final BorderSide side = const BorderSide(color: Colors.black87, width: 1.0);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Vendor Discount Ledger"),
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<PurchasePubDiscountLedgerResponse?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No Data Found"));
          }
          final data = snapshot.data!;
          final pub = data.publication;
          final todayStr = DateFormat('dd/MM/yyyy').format(DateTime.now());

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: reportWidth,
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
                      reportHeader(),

                      // Party Details Table
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87, width: 1.0),
                        ),
                        child: Column(
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13),
                                          children: [
                                            const TextSpan(
                                                text: "Party : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: pub?.publicationName ??
                                                    ""),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const VerticalDivider(
                                      color: Colors.black87, width: 1),
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13),
                                          children: [
                                            const TextSpan(
                                                text: "Address : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(text: pub?.address ?? ""),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const VerticalDivider(
                                      color: Colors.black87, width: 1),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13),
                                          children: [
                                            const TextSpan(
                                                text: "GST No : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(text: pub?.gstNo ?? ""),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                                color: Colors.black87,
                                height: 1,
                                thickness: 1),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 13),
                                    children: [
                                      const TextSpan(
                                          text: "Date : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: todayStr),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Ledger Data Table
                      Table(
                        border: TableBorder(
                          left: side,
                          right: side,
                          top: side,
                          bottom: side,
                          verticalInside: side,
                          horizontalInside: side,
                        ),
                        columnWidths: const {
                          0: FixedColumnWidth(40), // Checkbox
                          1: FixedColumnWidth(100), // Date
                          2: FlexColumnWidth(2), // Particulars
                          3: FlexColumnWidth(1), // Remark
                          4: FixedColumnWidth(120), // Debit
                          5: FixedColumnWidth(120), // Credit
                          6: FixedColumnWidth(140), // Balance
                        },
                        children: [
                          TableRow(
                            decoration:
                                BoxDecoration(color: Colors.grey.shade200),
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(),
                              ),
                              tableHeader("Date"),
                              tableHeader("Particulars"),
                              tableHeader("Remark"),
                              tableHeader("Debit (₹)"),
                              tableHeader("Credit (₹)"),
                              tableHeader("Balance"),
                            ],
                          ),
                          ...data.ledger.map((item) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black45),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                tableCell(formatDate(item.date)),
                                tableCell(item.particulars,
                                    align: TextAlign.center,
                                    weight: FontWeight.bold,
                                    color: Colors.blue.shade700),
                                tableCell(item.remark ?? ""),
                                tableCell(
                                    item.debit == 0.0
                                        ? ""
                                        : "₹ ${item.debit.toStringAsFixed(2)}",
                                    align: TextAlign.right,
                                    color: Colors.red),
                                tableCell(
                                    item.credit == 0.0
                                        ? ""
                                        : "₹ ${item.credit.toStringAsFixed(2)}",
                                    align: TextAlign.right,
                                    color: Colors.green.shade700),
                                tableCell(
                                    "₹${item.balance.toStringAsFixed(2)} ${item.balanceType}",
                                    align: TextAlign.right,
                                    weight: FontWeight.bold),
                              ],
                            );
                          }),
                          // Total Row
                          TableRow(
                            decoration:
                                BoxDecoration(color: Colors.grey.shade100),
                            children: [
                              const SizedBox(),
                              const SizedBox(),
                              const SizedBox(),
                              tableCell("Total :",
                                  align: TextAlign.right,
                                  weight: FontWeight.bold),
                              tableCell("₹ ${data.totalDebit.toStringAsFixed(2)}",
                                  align: TextAlign.right,
                                  weight: FontWeight.bold,
                                  color: Colors.red),
                              tableCell(
                                  "₹ ${data.totalCredit.toStringAsFixed(2)}",
                                  align: TextAlign.right,
                                  weight: FontWeight.bold,
                                  color: Colors.green.shade700),
                              const SizedBox(),
                            ],
                          ),
                          // Closing Balance Row
                          TableRow(
                            decoration:
                                BoxDecoration(color: Colors.blue.shade50),
                            children: [
                              const SizedBox(),
                              const SizedBox(),
                              const SizedBox(),
                              const SizedBox(),
                              const SizedBox(),
                              tableCell("Closing Balance :",
                                  align: TextAlign.right,
                                  weight: FontWeight.bold),
                              tableCell(
                                  "₹${data.closingBalance.toStringAsFixed(2)} ${data.closingBalanceType}",
                                  align: TextAlign.right,
                                  weight: FontWeight.bold,
                                  color: Colors.green.shade700),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Signatures
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(text: "Checked By : "),
                                TextSpan(
                                  text: ".....................................",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black45),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(text: "Approved By : "),
                                TextSpan(
                                  text: ".....................................",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black45),
                                ),
                              ],
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
