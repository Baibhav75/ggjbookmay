import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '/Model/sale_view_mrp_ledger_model.dart';

class SaleLedgerPdf {
  static Future<File> generate(SaleViewMRPLedgerResponse data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [

          /// 🔹 HEADER
          pw.Center(
            child: pw.Text(
              "GJ BOOK WORLD PVT. LTD.",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),

          pw.SizedBox(height: 5),
          pw.Center(child: pw.Text("Sale Ledger Statement")),

          pw.SizedBox(height: 10),

          pw.Text("School: ${data.schoolName}"),
          pw.Text("Address: ${data.address}"),

          pw.SizedBox(height: 10),

          /// 🔹 TABLE
          pw.Table.fromTextArray(
            headers: ["Date", "Particular", "Debit", "Credit", "Balance"],
            data: data.ledger.map((e) {
              return [
                e.date.split("T")[0],
                e.particulars,
                e.debit.toString(),
                e.credit.toString(),
                e.balance.toString(),
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Total Debit: ₹ ${data.totalDebit}"),
          pw.Text("Total Credit: ₹ ${data.totalCredit}"),
          pw.Text("Closing Balance: ₹ ${data.closingBalance}"),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/ledger_${DateTime.now().millisecondsSinceEpoch}.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}