// TODO Implement this library.
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '/Model/sale_mix_report_mrp_model.dart';

class SaleMixReportPdf {
  static Future<File> generate(SaleMixReportMrpModel data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [

          /// HEADER
          pw.Center(
            child: pw.Text(
              "GJ BOOK WORLD PVT. LTD.",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),

          pw.SizedBox(height: 5),
          pw.Center(child: pw.Text("Sale Mix Report")),

          pw.SizedBox(height: 10),

          pw.Text("School: ${data.schoolName}"),

          pw.SizedBox(height: 10),

          /// TABLE
          pw.Table.fromTextArray(
            headers: [
              "Book",
              "Sale",
              "Return",
              "Net",
              "Rate",
              "Amount",
              "Disc%",
              "Net Amt"
            ],
            data: data.data.map((e) {
              return [
                e.bookName,
                e.saleQty.toString(),
                e.returnQty.toString(),
                e.netQty.toString(),
                e.rate.toStringAsFixed(2),
                e.amount.toStringAsFixed(2),
                e.discount.toStringAsFixed(2),
                e.netAmount.toStringAsFixed(2),
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Grand Total: ₹ ${data.totalNetAmount.toStringAsFixed(2)}"),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File(
        "${dir.path}/sale_mix_${DateTime.now().millisecondsSinceEpoch}.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}