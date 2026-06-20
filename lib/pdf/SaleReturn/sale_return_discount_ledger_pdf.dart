import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../Model/sale_return_discount_ledger_model.dart';

class SaleReturnDiscountLedgerPdf {

  static Future<File> generate(
      SaleReturnDiscountLedgerResponse data) async {

    final pdf = pw.Document();

    pdf.addPage(

      pw.MultiPage(

        pageFormat: PdfPageFormat.a4.landscape,

        build: (context) => [

          /// HEADER
          pw.Center(
            child: pw.Column(
              children: [

                pw.Text(
                  "GJ BOOK WORLD PVT. LTD.",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 5),

                pw.Text(
                  "D-1/20 SECTOR 22 GIDA GORAKHPUR",
                ),

                pw.Text(
                  "Cont. - 9354918638, 9354918644",
                ),

                pw.Text(
                  "GST No: 09AAGCG0650B1Z2",
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Center(
            child: pw.Text(
              "SALE RETURN DISCOUNT LEDGER STATEMENT",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 15),

          /// SCHOOL INFO
          pw.Table(
            border: pw.TableBorder.all(),
            children: [

              pw.TableRow(
                children: [

                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Party Name : ${data.school.accName}",
                    ),
                  ),

                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Address : ${data.school.address}",
                    ),
                  ),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 15),

          /// LEDGER TABLE
          pw.Table(
            border: pw.TableBorder.all(),

            children: [

              /// HEADER
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [

                  header("Date"),
                  header("Particulars"),
                  header("Debit"),
                  header("Credit"),
                  header("Balance"),
                ],
              ),

              ...data.data.map(
                    (e) => pw.TableRow(
                  children: [

                    rowCell(e.date),

                    rowCell(
                      e.particulars,
                    ),

                    rowCell(
                      e.debit == null
                          ? ""
                          : e.debit!
                          .toStringAsFixed(2),
                    ),

                    rowCell(
                      e.credit == null
                          ? ""
                          : e.credit!
                          .toStringAsFixed(2),
                    ),

                    rowCell(
                      e.balance
                          .toStringAsFixed(2),
                    ),
                  ],
                ),
              ),

              /// TOTAL
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey200,
                ),
                children: [

                  rowCell(""),

                  rowCell(
                    "TOTAL",
                    bold: true,
                  ),

                  rowCell(
                    data.totalDebit
                        .toStringAsFixed(2),
                    bold: true,
                  ),

                  rowCell(
                    data.totalCredit
                        .toStringAsFixed(2),
                    bold: true,
                  ),

                  rowCell(""),
                ],
              ),

              /// CLOSING
              pw.TableRow(
                children: [

                  rowCell(""),

                  rowCell(
                    "Closing Balance",
                    bold: true,
                  ),

                  rowCell(""),

                  rowCell(""),

                  rowCell(
                    data.closingBalance
                        .toStringAsFixed(2),
                    bold: true,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    final dir =
    await getTemporaryDirectory();

    final file = File(
      "${dir.path}/sale_return_discount_ledger.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    return file;
  }

  static pw.Widget header(
      String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight:
          pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget rowCell(
      String text, {
        bool bold = false,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: bold
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
        ),
      ),
    );
  }
}