import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import '../../Model/sale_sample_not_for_sale_invoice_model.dart';

class SaleSampleNotForSaleInvoicePdf {
  static Future<File> generate(SaleSampleNotForSaleInvoiceResponse data) async {
    final pdf = pw.Document();

    String formatDate(String date) {
      if (date.isEmpty) return "";
      try {
        if (date.contains("T")) {
          return date.split("T")[0];
        }
        return date;
      } catch (e) {
        return date;
      }
    }

    final inv = data.invoice;
    int index = 1;

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(16),
        build: (context) => [
          /// 🔷 HEADER
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    width: 50,
                    child: pw.Column(
                      children: [
                        pw.Text("GJ",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 14)),
                        pw.Text("BOOK WORLD",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          "GJ BOOK WORLD PVT. LTD.",
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromInt(0xFF2B4C7E),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 9354918638, 9354918644\nGST No: 09AAGCG0650B1Z2| CIN No: U22222UP2015PTC068597",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Divider(),

              pw.Text("Sale Sample NotFor Sale Invoice", style: pw.TextStyle(fontSize: 14, color: PdfColor.fromInt(0xFF2B4C7E))),
              pw.SizedBox(height: 10),

              /// 🔷 INFO
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  row3("Invoice No", inv.billNo,
                      "Party Name", inv.partyName,
                      "Bill Date", formatDate(inv.billDate)),
                  row3("Transport", inv.transport,
                      "Address", inv.address,
                      "Rec. Date", formatDate(inv.recDate)),
                  pw.TableRow(
                    children: [
                      cell(""),
                      cell("Remark: ${inv.remark}"),
                      cell(""),
                    ],
                  ),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 10),

          /// 🔷 MAIN TABLE
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FixedColumnWidth(30),
              1: const pw.FlexColumnWidth(4),
              2: const pw.FixedColumnWidth(40),
              3: const pw.FixedColumnWidth(50),
              4: const pw.FixedColumnWidth(60),
              5: const pw.FixedColumnWidth(70),
            },
            children: [
              /// HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  cell("S.N.", bold: true),
                  cell("Book Name (Title)", bold: true),
                  cell("Qty", bold: true),
                  cell("Rate", bold: true),
                  cell("Amount", bold: true),
                  cell("Amt With Disc.", bold: true),
                ],
              ),

              /// 🔥 DATA
              ...data.seriesGroups.expand((group) {
                List<pw.TableRow> rows = [];

                rows.add(
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey100),
                    children: [
                      cell(""),
                      cell("Series: ${group.series}", bold: true),
                      cell(""),
                      cell(""),
                      cell(""),
                      cell("Publication: ${group.publication}", bold: true),
                    ],
                  ),
                );

                for (var item in group.items) {
                  rows.add(
                    pw.TableRow(
                      children: [
                        cell("${index++}"),
                        cell(
                          "${item.bookName} - ${item.subject} - ${item.classes}",
                        ),
                        cell(item.qty.toStringAsFixed(0)),
                        cell(item.rate.toStringAsFixed(2)),
                        cell(item.amount.toStringAsFixed(2)),
                        cell(""),
                      ],
                    ),
                  );
                }

                /// GROUP SUBTOTAL
                rows.add(
                  pw.TableRow(
                    children: [
                      cell(""),
                      cell("Subtotal", bold: true, align: pw.TextAlign.right),
                      cell(group.seriesQty.toStringAsFixed(0), bold: true),
                      cell(""),
                      cell("Rs ${group.seriesTotal.toStringAsFixed(2)}", bold: true),
                      cell(""),
                    ],
                  ),
                );

                /// GROUP DISCOUNT
                rows.add(
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                    ),
                    children: [
                      cell(""),
                      cell("Disc(%) :", bold: true, align: pw.TextAlign.right),
                      cell(group.seriesDiscount.toStringAsFixed(2), bold: true),
                      cell(""),
                      cell(""),
                      cell(
                        "Rs ${group.afterDiscount.toStringAsFixed(4)}",
                        bold: true,
                      ),
                    ],
                  ),
                );

                return rows;
              }),

              /// 🔥 GRAND TOTAL
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.green200),
                children: [
                  cell(""),
                  cell("Grand Total:", bold: true, align: pw.TextAlign.right),
                  cell(data.grandTotalQty.toStringAsFixed(0), bold: true),
                  cell(""),
                  cell("Rs ${data.grandTotal.toStringAsFixed(2)}", bold: true),
                  cell(""),
                ],
              ),
              
              /// 🔥 TOTAL DISCOUNT
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.cyan100),
                children: [
                  cell(""),
                  cell("Total Discount:", bold: true, align: pw.TextAlign.right),
                  cell("${data.discountPercent.toStringAsFixed(2)}%", bold: true),
                  cell(""),
                  cell(""),
                  cell("Rs ${data.afterDiscountTotal.toStringAsFixed(4)}", bold: true),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Text("Invoice Created By: ${inv.createdBy}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/sample_invoice_${inv.billNo}.pdf");

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget cell(String text, {bool bold = false, pw.TextAlign align = pw.TextAlign.center}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.TableRow row3(
      String l1, String v1,
      String l2, String v2,
      String l3, String v3,
      ) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(text: "$l1: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
                pw.TextSpan(text: v1, style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(text: "$l2: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
                pw.TextSpan(text: v2, style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(text: "$l3: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
                pw.TextSpan(text: v3, style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
