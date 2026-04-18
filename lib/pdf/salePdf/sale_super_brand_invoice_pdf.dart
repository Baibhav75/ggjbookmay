import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import '/Model/sale_super_brand_bill_model.dart';

/// 🔥 MAIN FUNCTION
Future<File> generateSaleInvoicePdf(
    SaleSuperBrandBillDetailsModel data) async {
  final pdf = pw.Document();

  final groupedItems = groupItems(data.items);

  int totalQty = data.items.fold(0, (sum, e) => sum + e.qty);

  int globalIndex = 1;

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (context) {
        return pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              /// 🔶 HEADER
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.grey300,
                child: pw.Column(
                  children: [
                    pw.Text("GJ BOOK WORLD PVT. LTD.",
                        style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text("D-1/20, SECTOR 22, GIDA, GORAKHPUR"),
                    pw.Text("Cont. - 9354918638, 9354918644"),
                    pw.Text(
                        "GST No: 09AAGCG0850B1Z2 | CIN No: U22222UP2015PTC068597",
                        style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              ),

              pw.SizedBox(height: 5),

              /// 🔶 TITLE
              pw.Center(
                child: pw.Text(
                  "Sample Sale Invoice",
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
              ),

              pw.SizedBox(height: 5),

              /// 🔶 INFO ROWS
              _pdfRow("Invoice No", data.master.billNo,
                  "Bill Date", data.master.dates.split("T")[0]),

              _pdfRow("Party Name", data.master.schoolName,
                  "Rec Date", data.master.dates.split("T")[0]),

              _pdfRow("Transport", data.master.transport ?? "",
                  "Address", data.master.address ?? ""),

              pw.Divider(),

              /// 🔶 TABLE HEADER
              _pdfTableHeader(),

              /// 🔥 GROUPED DATA
              ...groupedItems.entries.map((entry) {
                final key = entry.key.split("__");
                final series = key[0];
                final publication = key[1];
                final list = entry.value;

                int subQty = list.fold(0, (s, e) => s + e.qty);
                double subAmt =
                list.fold(0, (s, e) => s + e.totalAmount);

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [

                    /// 🔶 SERIES HEADER
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(5),
                      color: PdfColors.grey200,
                      child: pw.Row(
                        mainAxisAlignment:
                        pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Series: $series",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text("Publication: $publication",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ),

                    /// 🔶 ITEMS
                    ...list.map((item) {
                      return _pdfTableRow(
                        "${globalIndex++}",
                        "${item.bookName}\n${item.subject} - ${item.classes}",
                        item.qty.toString(),
                        item.rate.toStringAsFixed(2),
                        item.totalAmount.toStringAsFixed(2),
                        "",
                      );
                    }),

                    /// 🔶 SUBTOTAL
                    _pdfSummary(
                      "Subtotal:",
                      subQty.toString(),
                      subAmt.toStringAsFixed(2),
                      bgColor: PdfColors.grey300,
                    ),
                  ],
                );
              }),

              /// 🔶 DISCOUNT
              _pdfSummary(
                "Disc(%):",
                "0",
                data.billTotalAmount.toStringAsFixed(2),
                bgColor: PdfColors.blue100,
              ),

              /// 🔶 GRAND TOTAL
              _pdfSummary(
                "Grand Total:",
                totalQty.toString(),
                data.billTotalAmount.toStringAsFixed(2),
                bgColor: PdfColors.green100,
                isBold: true,
              ),

              /// 🔶 TOTAL DISCOUNT
              _pdfSummary(
                "Total Discount:",
                "0%",
                data.billTotalAmount.toStringAsFixed(2),
                bgColor: PdfColors.cyan100,
              ),

              pw.SizedBox(height: 10),

              /// 🔶 FOOTER
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text("Invoice Created By: Admin",
                    style: pw.TextStyle(fontSize: 10)),
              ),
            ],
          ),
        );
      },
    ),
  );

  final dir = await getTemporaryDirectory();
  final file =
  File("${dir.path}/sale_invoice_${DateTime.now().millisecondsSinceEpoch}.pdf");

  await file.writeAsBytes(await pdf.save());

  return file;
}

/// 🔥 GROUP FUNCTION
Map<String, List<Item>> groupItems(List<Item> items) {
  Map<String, List<Item>> grouped = {};

  for (var item in items) {
    String key = "${item.series}__${item.publication}";
    grouped.putIfAbsent(key, () => []);
    grouped[key]!.add(item);
  }

  return grouped;
}

/// 🔷 INFO ROW
pw.Widget _pdfRow(String t1, String v1, String t2, String v2) {
  return pw.Row(
    children: [
      pw.Expanded(child: pw.Text("$t1: $v1")),
      pw.Expanded(child: pw.Text("$t2: $v2")),
    ],
  );
}

/// 🔷 TABLE HEADER
pw.Widget _pdfTableHeader() {
  return pw.Row(
    children: [
      _pdfCell("S.N.", flex: 1, isBold: true),
      _pdfCell("Book Name (Title)", flex: 4, isBold: true),
      _pdfCell("Qty", flex: 1, isBold: true),
      _pdfCell("Rate", flex: 1, isBold: true),
      _pdfCell("Amount", flex: 2, isBold: true),
      _pdfCell("Amt With Disc.", flex: 2, isBold: true),
    ],
  );
}

/// 🔷 TABLE ROW
pw.Widget _pdfTableRow(
    String sn,
    String name,
    String qty,
    String rate,
    String amt,
    String disc) {
  return pw.Row(
    children: [
      _pdfCell(sn, flex: 1),
      _pdfCell(name, flex: 4),
      _pdfCell(qty, flex: 1),
      _pdfCell(rate, flex: 1),
      _pdfCell(amt, flex: 2),
      _pdfCell(disc, flex: 2),
    ],
  );
}

/// 🔷 SUMMARY
pw.Widget _pdfSummary(String title, String qty, String amt,
    {PdfColor? bgColor, bool isBold = false}) {
  return pw.Container(
    color: bgColor,
    child: pw.Row(
      children: [
        _pdfCell("", flex: 1),
        _pdfCell(title, flex: 4, isBold: isBold),
        _pdfCell(qty, flex: 1, isBold: isBold),
        _pdfCell("", flex: 1),
        _pdfCell("₹ $amt", flex: 2, isBold: isBold),
        _pdfCell("", flex: 2),
      ],
    ),
  );
}

/// 🔷 CELL
pw.Widget _pdfCell(String text,
    {int flex = 1, bool isBold = false}) {
  return pw.Expanded(
    flex: flex,
    child: pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight:
          isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    ),
  );
}