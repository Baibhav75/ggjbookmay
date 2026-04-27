import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '/Model/sample_not_sale_return_details_model.dart';

class SampleNotSaleReturnPdf {

  static Future<void> generateAndShare(
      SampleNotSaleReturnDetailsModel data) async {

    final pdf = pw.Document();

    /// GROUP SERIES (same as UI)
    Map<String, List<Item>> grouped = {};
    for (var item in data.items) {
      grouped.putIfAbsent(item.series, () => []).add(item);
    }

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [

          /// 🔴 HEADER
          pw.Row(
            children: [
              pw.Text(
                "GJ",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("GJ BOOK WORLD PVT. LTD.",
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue)),
                    pw.Text(
                        "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 9354918638, 9354918644\nGST No: 09AAGCG0650B1Z2"),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 10),
          pw.Divider(thickness: 2),

          pw.Center(
            child: pw.Text(
              "Sample Not For Sale Return Invoice",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                decoration: pw.TextDecoration.underline,
              ),
            ),
          ),

          pw.SizedBox(height: 10),

          /// 🟦 INFO TABLE
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(children: [
                _cell("Invoice No: ${data.master.billNo}"),
                _cell("Party: ${data.master.schoolName}"),
                _cell("Date: ${_formatDate(data.master.date)}"),
              ]),
              pw.TableRow(children: [
                _cell("Transport: BY HAND"),
                _cell("Address: ${data.master.address}"),
                _cell("Rec Date: ${_formatDate(data.master.date)}"),
              ]),
              pw.TableRow(children: [
                _cell("Remark: SAMPLE"),
                pw.SizedBox(),
                pw.SizedBox(),
              ]),
            ],
          ),

          pw.SizedBox(height: 15),

          /// 📊 TABLE
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(4),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(2),
              4: const pw.FlexColumnWidth(2),
              5: const pw.FlexColumnWidth(2),
            },
            children: [

              /// HEADER
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _cell("S.N.", bold: true),
                  _cell("Book Name", bold: true),
                  _cell("Qty", bold: true),
                  _cell("Rate", bold: true),
                  _cell("Amount", bold: true),
                  _cell("Amt With Disc.", bold: true),
                ],
              ),

              /// SERIES DATA
              ...grouped.entries.expand((entry) {
                final series = entry.key;
                final items = entry.value;

                double subQty = 0;
                double subAmount = 0;

                List<pw.TableRow> rows = [];

                /// SERIES HEADER
                rows.add(
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      pw.SizedBox(),
                      _cell("Series: $series", bold: true),
                      pw.SizedBox(),
                      pw.SizedBox(),
                      pw.SizedBox(),
                      pw.SizedBox(),
                    ],
                  ),
                );

                int index = 1;

                for (var item in items) {
                  subQty += item.qty;
                  subAmount += item.total;

                  rows.add(
                    pw.TableRow(
                      children: [
                        _cell(index.toString()),
                        _cell("${item.bookName} - ${item.classes}"),
                        _cell(item.qty.toString()),
                        _cell(" ${item.rate}"),
                        _cell(" ${item.total}"),
                        _cell(""),
                      ],
                    ),
                  );
                  index++;
                }

                /// SUBTOTAL
                rows.add(
                  pw.TableRow(
                    children: [
                      pw.SizedBox(),
                      _cell("Subtotal:", bold: true),
                      _cell(subQty.toInt().toString()),
                      pw.SizedBox(),
                      _cell(" ${subAmount.toStringAsFixed(2)}"),
                      pw.SizedBox(),
                    ],
                  ),
                );

                return rows;
              }),

              /// GRAND TOTAL
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.green100),
                children: [
                  pw.SizedBox(),
                  _cell("Grand Total:", bold: true),
                  _cell(data.grandTotalQty.toString()),
                  pw.SizedBox(),
                  _cell(" ${data.grandTotal}"),
                  pw.SizedBox(),
                ],
              ),

              /// FINAL AMOUNT
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                children: [
                  pw.SizedBox(),
                  _cell("Final Amount:", bold: true),
                  pw.SizedBox(),
                  pw.SizedBox(),
                  pw.SizedBox(),
                  _cell(" ${data.finalAmount}"),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    /// SAVE + SHARE
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/sample_invoice.pdf");

    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)]);
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal),
      ),
    );
  }

  static String _formatDate(String raw) {
    try {
      final d = DateTime.parse(raw);
      return "${d.day}-${d.month}-${d.year}";
    } catch (_) {
      return raw;
    }
  }
}