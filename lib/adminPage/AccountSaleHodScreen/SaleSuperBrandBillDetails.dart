import 'package:flutter/material.dart';

import '../../Model/sale_super_brand_bill_model.dart';
import '../../Service/SaleSuperBrandBillDetailsService.dart';
import 'package:printing/printing.dart';
import '/pdf/salePdf/sale_super_brand_invoice_pdf.dart';

class SaleSuperBrandBillDetailsScreen extends StatefulWidget {
  final String billNo;

  const SaleSuperBrandBillDetailsScreen({super.key, required this.billNo});

  @override
  State<SaleSuperBrandBillDetailsScreen> createState() =>
      _SaleSuperBrandBillDetailsScreenState();
}

class _SaleSuperBrandBillDetailsScreenState
    extends State<SaleSuperBrandBillDetailsScreen> {
  late Future<SaleSuperBrandBillDetailsModel?> futureBill;

  Map<String, List<Item>> groupItems(List<Item> items) {
    Map<String, List<Item>> grouped = {};

    for (var item in items) {
      String key = "${item.series}__${item.publication}";

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }

      grouped[key]!.add(item);
    }

    return grouped;
  }

  @override
  void initState() {
    super.initState();
    futureBill = SaleSuperBrandBillService().fetchBill(widget.billNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sample Sale Invoice"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final data = await futureBill;
              if (data == null) return;

              final file = await generateSaleInvoicePdf(data);

              await Printing.sharePdf(
                bytes: await file.readAsBytes(),
                filename: "sale_invoice.pdf",
              );
            },
          )
        ],
      ),
      body: FutureBuilder<SaleSuperBrandBillDetailsModel?>(
        future: futureBill,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final groupedItems = groupItems(data.items);

          int totalQty = data.items.fold(0, (sum, e) => sum + e.qty);

          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔶 HEADER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/icon/gj5.png',
                              height: 40,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.menu_book, size: 40),
                            ),
                            const Text("BOOK WORLD",
                                style: TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                "GJ BOOK WORLD PVT. LTD.",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              ),
                              SizedBox(height: 5),
                              Text(
                                  "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 9354918638, 9354918644\nGST No: 09AAGCG0850B1Z2| CIN No: U22222UP2015PTC068597",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black87)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Colors.black),

                  /// 🔶 TITLE
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        "Sample Sale Invoice",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const Divider(height: 1, color: Colors.black),

                  /// 🔶 TOP INFO GRID
                  Row(
                    children: [
                      _borderCell("Invoice No: ${data.master.billNo}",
                          flex: 2, alignCenter: true),
                      _borderCell("Party Name: ${data.master.schoolName}",
                          flex: 4, alignCenter: true),
                      _borderCell("Bill Date: ${data.master.dates.split("T")[0]}",
                          flex: 2, alignCenter: true),
                    ],
                  ),
                  Row(
                    children: [
                      _borderCell(
                          "Transport: ${data.master.transport ?? "BY ISUZU"}",
                          flex: 2, alignCenter: true),
                      _borderCell(
                          "Address: ${data.master.address ?? "TARAMANDAL"}",
                          flex: 4, alignCenter: true),
                      _borderCell(
                          "Rec. Date: ${data.master.dates.split("T")[0]}",
                          flex: 2, alignCenter: true),
                    ],
                  ),
                  Row(
                    children: [
                      _borderCell("Remark: ", flex: 8, alignCenter: true),
                    ],
                  ),

                  /// 🔶 TABLE HEADER
                  _tableHeader(),

                  /// 🔥 GROUPED UI
                  ...groupedItems.entries.map((entry) {
                    final key = entry.key.split("__");
                    final series = key[0];
                    final publication = key[1];
                    final groupList = entry.value;

                    int subQty = groupList.fold(0, (sum, e) => sum + e.qty);
                    double subAmount =
                        groupList.fold(0, (sum, e) => sum + e.totalAmount);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔶 SERIES HEADER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.5),
                            color: Colors.grey.shade100,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Series: $series",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              Text("Publication: $publication",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ],
                          ),
                        ),

                        /// 🔶 ITEMS
                        ...groupList.asMap().entries.map((e) {
                          int index = e.key;
                          var item = e.value;

                          return _tableRow("${index + 1}", item);
                        }),

                        /// 🔶 SUBTOTAL
                        _summaryRow(
                          "Subtotal:",
                          subQty.toString(),
                          amount: "₹ ${subAmount.toStringAsFixed(2)}",
                          amtWithDisc: "",
                          bgColor: Colors.white,
                        ),
                      ],
                    );
                  }).toList(),

                  /// 🔶 DISCOUNT
                  _summaryRow(
                    "Disc(%) :",
                    "0",
                    amount: "",
                    amtWithDisc: "₹ ${data.billTotalAmount.toStringAsFixed(2)}",
                    bgColor: const Color(0xFFE8F0FE), // Light blue tint
                  ),

                  /// 🔶 GRAND TOTAL
                  _summaryRow(
                    "Grand Total:",
                    totalQty.toString(),
                    amount: "₹ ${data.billTotalAmount.toStringAsFixed(2)}",
                    amtWithDisc: "",
                    bgColor: const Color(0xFFD4EDDA), // Light green tint
                    isBold: true,
                  ),

                  /// 🔶 TOTAL DISCOUNT
                  _summaryRow(
                    "Total Discount:",
                    "0%",
                    amount: "",
                    amtWithDisc: "₹ ${data.billTotalAmount.toStringAsFixed(2)}",
                    bgColor: const Color(0xFFE1F5FE), // Light cyan tint
                  ),

                  const SizedBox(height: 10),

                  /// 🔶 FOOTER
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Invoice Created By: Admin",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔷 TABLE HEADER
  Widget _tableHeader() {
    return Row(
      children: [
        _borderCell("S.N.", flex: 1, isHeader: true, alignCenter: true),
        _borderCell("Book Name (Title)",
            flex: 4, isHeader: true, alignCenter: true),
        _borderCell("Qty", flex: 1, isHeader: true, alignCenter: true),
        _borderCell("Rate", flex: 1, isHeader: true, alignCenter: true),
        _borderCell("Amount", flex: 2, isHeader: true, alignCenter: true),
        _borderCell("Amt With Disc.",
            flex: 2, isHeader: true, alignCenter: true),
      ],
    );
  }

  /// 🔷 TABLE ROW
  Widget _tableRow(String sn, Item item) {
    return Row(
      children: [
        _borderCell(sn, flex: 1, alignCenter: true),
        _borderCell(
          "${item.bookName} - ${item.classes}",
          flex: 4,
        ),
        _borderCell(item.qty.toString(), flex: 1, alignCenter: true),
        _borderCell(item.rate.toStringAsFixed(2), flex: 1, alignCenter: true),
        _borderCell(item.totalAmount.toStringAsFixed(2),
            flex: 2, alignCenter: true),
        _borderCell("", flex: 2, alignCenter: true),
      ],
    );
  }

  /// 🔷 SUMMARY ROW
  Widget _summaryRow(String title, String qty,
      {String? amount,
      String? amtWithDisc,
      Color? bgColor,
      bool isBold = false}) {
    return Container(
      color: bgColor,
      child: Row(
        children: [
          _borderCell("", flex: 1),
          _borderCell(title, flex: 4, isBold: isBold, rightAlign: true),
          _borderCell(qty, flex: 1, isBold: isBold, alignCenter: true),
          _borderCell("", flex: 1),
          _borderCell(amount ?? "", flex: 2, isBold: isBold, alignCenter: true),
          _borderCell(amtWithDisc ?? "",
              flex: 2, isBold: isBold, alignCenter: true),
        ],
      ),
    );
  }

  /// 🔷 BORDER CELL
  Widget _borderCell(String text,
      {int flex = 1,
      bool isHeader = false,
      bool isBold = false,
      bool alignCenter = false,
      bool rightAlign = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
        ),
        alignment: alignCenter
            ? Alignment.center
            : (rightAlign ? Alignment.centerRight : Alignment.centerLeft),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight:
                (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
