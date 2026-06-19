import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../Model/view_agent_discount_details_model.dart';

class ViewAgentDiscountPdf {
  static pw.Widget cell(
      String text, {
        pw.TextAlign align = pw.TextAlign.center,
        bool bold = false,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight:
          bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
  
  static Future<void> generateAndShare(
      ViewAgentDiscountDetailsModel model,
      ) async {
    final pdf = pw.Document();

    pw.MemoryImage? logo;

    try {
      final data =
      await rootBundle.load("assets/images/logo.png");

      logo = pw.MemoryImage(
        data.buffer.asUint8List(),
      );
    } catch (_) {}

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(15),
        build: (context) {
          int index = 1;

          Map<String, List<InvoiceItem>> groupedItems =
          {};

          for (var item in model.items) {
            String key =
                "${item.series}|${item.publication}";

            groupedItems.putIfAbsent(
              key,
                  () => [],
            );

            groupedItems[key]!.add(item);
          }

          return [

            /// HEADER
            pw.Row(
              children: [

                if (logo != null)
                  pw.Image(
                    logo,
                    width: 60,
                    height: 60,
                  ),

                pw.SizedBox(width: 20),

                pw.Expanded(
                  child: pw.Column(
                    children: [

                      pw.Text(
                        "GJ BOOK WORLD PVT. LTD.",
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight:
                          pw.FontWeight.bold,
                        ),
                      ),

                      pw.Text(
                        "D-1/20, SECTOR 22, GIDA, GORAKHPUR",
                      ),

                      pw.Text(
                        "GST No: 09AAGCG0650B1Z2",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 10),

            pw.Center(
              child: pw.Text(
                "SALE INVOICE",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight:
                  pw.FontWeight.bold,
                  decoration:
                  pw.TextDecoration.underline,
                ),
              ),
            ),

            pw.SizedBox(height: 15),

            /// INVOICE DETAILS
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    cell(
                      "Invoice No : ${model.invoiceDetails.billNo}",
                      align: pw.TextAlign.left,
                    ),
                    cell(
                      "Party Name : ${model.invoiceDetails.schoolName}",
                      align: pw.TextAlign.left,
                    ),
                    cell(
                      "Bill Date : ${model.invoiceDetails.billDate.split('T').first}",
                      align: pw.TextAlign.left,
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    cell(
                      "Address : ${model.invoiceDetails.address}",
                      align: pw.TextAlign.left,
                    ),
                    cell(
                      "Manager : ${model.invoiceDetails.managerName}",
                      align: pw.TextAlign.left,
                    ),
                    cell(
                      "Agent : ${model.invoiceDetails.agentName}",
                      align: pw.TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 10),

            /// TABLE HEADER
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FlexColumnWidth(4),
                2: const pw.FixedColumnWidth(40),
                3: const pw.FixedColumnWidth(60),
                4: const pw.FixedColumnWidth(70),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  children: [
                    cell("S.N.", bold: true),
                    cell("Book Name", bold: true),
                    cell("Qty", bold: true),
                    cell("Rate", bold: true),
                    cell("Amount", bold: true),
                  ],
                ),
              ],
            ),

            /// GROUPS
            ...groupedItems.entries.map((entry) {
              String series =
              entry.key.split("|")[0];

              String publication =
              entry.key.split("|")[1];

              double subtotal = 0;

              for (var e in entry.value) {
                subtotal += e.totalAmount;
              }

              return pw.Column(
                children: [

                  pw.Container(
                    width: double.infinity,
                    padding:
                    const pw.EdgeInsets.all(5),
                    color: PdfColors.grey100,
                    child: pw.Row(
                      mainAxisAlignment:
                      pw.MainAxisAlignment
                          .spaceBetween,
                      children: [
                        pw.Text(
                          "Series : $series",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "Publication : $publication",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: const pw.FixedColumnWidth(30),
                      1: const pw.FlexColumnWidth(4),
                      2: const pw.FixedColumnWidth(40),
                      3: const pw.FixedColumnWidth(60),
                      4: const pw.FixedColumnWidth(70),
                    },
                    children: [

                      ...entry.value.map(
                            (item) => pw.TableRow(
                          children: [
                            cell("${index++}"),
                            cell(
                              "${item.bookName} (${item.classes})",
                              align:
                              pw.TextAlign.left,
                            ),
                            cell(
                                item.qty.toString()),
                            cell(item.rate
                                .toStringAsFixed(2)),
                            cell(item.totalAmount
                                .toStringAsFixed(2)),
                          ],
                        ),
                      ),

                      pw.TableRow(
                        children: [
                           pw.SizedBox(),
                          cell(
                            "Subtotal",
                            align:
                            pw.TextAlign.right,
                            bold: true,
                          ),
                           pw.SizedBox(),
                           pw.SizedBox(),
                          cell(
                            subtotal
                                .toStringAsFixed(2),
                            bold: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }),

            pw.SizedBox(height: 10),

            /// GRAND TOTAL
            pw.Table(
              border: pw.TableBorder.all(),
              children: [

                summaryRow(
                  "Grand Total",
                  "₹ ${model.summary.grandTotal.toStringAsFixed(2)}",
                  PdfColors.green100,
                ),

                summaryRow(
                  "Discount",
                  "₹ ${model.summary.discountAmount.toStringAsFixed(2)}",
                  PdfColors.cyan100,
                ),

                summaryRow(
                  "Agent Commission",
                  "₹ ${model.summary.totalAgentCommission.toStringAsFixed(2)}",
                  PdfColor.fromHex("#EFE4C1"),
                ),

                summaryRow(
                  "Manager Commission",
                  "₹ ${model.summary.totalManagerCommission.toStringAsFixed(2)}",
                  PdfColor.fromHex("#E6F5DD"),
                ),
              ],
            ),

            pw.SizedBox(height: 40),

            pw.Row(
              mainAxisAlignment:
              pw.MainAxisAlignment
                  .spaceBetween,
              children: [
                pw.Text(
                  "Invoice Created By\n\n______________",
                ),
                pw.Text(
                  "Rechecked By\n\n______________",
                ),
              ],
            ),
          ];
        },
      ),
    );

    final dir = await getTemporaryDirectory();

    final file = File(
      "${dir.path}/Invoice_${model.invoiceDetails.billNo}.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    await Share.shareXFiles(
      [XFile(file.path)],
      text:
      "Sale Invoice ${model.invoiceDetails.billNo}",
    );
  }

  static pw.TableRow summaryRow(
      String title,
      String value,
      PdfColor color,
      ) {
    return pw.TableRow(
      decoration: pw.BoxDecoration(color: color),
      children: [
         pw.SizedBox(),
        cell(title,
            align: pw.TextAlign.right,
            bold: true),
         pw.SizedBox(),
         pw.SizedBox(),
        cell(value, bold: true),
         pw.SizedBox(),
      ],
    );
  }

}