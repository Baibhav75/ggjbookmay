import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../model/view_company_discount_model.dart';

class ViewCompanyDiscountPdf {
  static Future<File> generate(ViewCompanyDiscountModel data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [

            /// 🔹 HEADER
            pw.Center(
              child: pw.Text(
                "GJ BOOK WORLD PVT. LTD.",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 5),
            pw.Center(child: pw.Text("Purchase Discount Invoice")),

            pw.SizedBox(height: 10),

            pw.Text("Invoice No: ${data.billNo}"),
            pw.Text("Supplier: ${data.publication}"),
            pw.Text("Date: ${data.date.split("T")[0]}"),

            pw.SizedBox(height: 10),

            /// 🔹 TABLE
            pw.Table.fromTextArray(
              headers: ["Book", "Qty", "Rate", "Amount", "After Disc"],
              data: data.data.map((e) {
                double discAmt = e.totalAmount * (e.discount / 100);
                double finalAmt = e.totalAmount - discAmt;

                return [
                  e.bookName,
                  e.qty.toString(),
                  e.rate.toString(),
                  e.totalAmount.toStringAsFixed(2),
                  finalAmt.toStringAsFixed(2),
                ];
              }).toList(),
            ),

          ];
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/discount_${data.billNo}.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}