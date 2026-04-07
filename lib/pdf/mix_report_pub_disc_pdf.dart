import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../Model/GetMixReportPubDisc_model.dart';

class MixReportPubDiscPdf {
  static Future<File> generate(GetMixReportPubDiscModel report) async {
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
          pw.Center(child: pw.Text("Mix Report Publication Discount")),

          pw.SizedBox(height: 10),

          pw.Text("Publication: ${report.publication}"),

          pw.SizedBox(height: 10),

          /// 🔹 TABLE
          pw.Table.fromTextArray(
            headers: [
              "Book",
              "Qty",
              "Rate",
              "Amount",
              "Disc%",
              "Net"
            ],
            data: report.data.map((e) {
              return [
                e.bookName,
                e.netQty.toString(),
                e.rate.toStringAsFixed(2),
                e.amount.toStringAsFixed(2),
                e.discount.toStringAsFixed(2),
                e.netAmount.toStringAsFixed(2),
              ];
            }).toList(),
          ),

        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/mix_pub_disc.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}