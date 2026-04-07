import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../Model/PurchaseMixReport_model.dart';

class PurchaseMixReportPdf {
  static Future<File> generate(PurchaseMixReportModel model) async {
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
          pw.Center(child: pw.Text("Purchase Mix Report")),

          pw.SizedBox(height: 10),

          pw.Text("Publication: ${model.publication}"),

          pw.SizedBox(height: 10),

          /// TABLE
          pw.Table.fromTextArray(
            headers: ["Book", "Qty", "Rate", "Amount"],
            data: model.data.map((e) {
              return [
                e.bookName,
                e.netQty.toString(),
                e.rate.toStringAsFixed(2),
                e.netAmount.toStringAsFixed(2),
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Total Amount: ₹ ${model.summary.totalAmount}"),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/mix_report.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}