import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '/Model/PurchaseMrpLedger_model.dart';

Future<File> generateLedgerPdf(PurchaseMrpLedgerModel model) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return [

          /// 🔹 HEADER
          pw.Center(
            child: pw.Text(
              "GJ BOOK WORLD PVT. LTD.",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),

          pw.SizedBox(height: 5),

          pw.Center(
            child: pw.Text("Purchase Ledger Statement"),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Publication: ${model.publication.publication}"),

          pw.SizedBox(height: 10),

          /// 🔹 TABLE
          pw.Table.fromTextArray(
            headers: ["Date", "Type", "Particulars", "Debit", "Credit"],
            data: model.data.map((e) {
              return [
                e.date.split("T")[0],
                e.type,
                "Invoice ${e.billNo}",
                e.debit.toStringAsFixed(2),
                e.credit.toStringAsFixed(2),
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 10),

          /// 🔹 SUMMARY
          pw.Text("Total Debit: ${model.summary.totalDebit}"),
          pw.Text("Total Credit: ${model.summary.totalCredit}"),
          pw.Text("Balance: ${model.summary.balance}"),
        ];
      },
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/ledger.pdf");

  await file.writeAsBytes(await pdf.save());

  return file;
}