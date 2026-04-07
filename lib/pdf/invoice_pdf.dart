import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../Model/purchase_invoice_mrp_model.dart';

class PurchaseInvoicePdf {
  static Future<File> generate(PurchaseInvoiceMrpModel invoice) async {
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

          pw.Center(child: pw.Text("Purchase MRP Invoice")),

          pw.SizedBox(height: 10),

          pw.Text("Invoice No: ${invoice.billNo}"),
          pw.Text("Supplier: ${invoice.publication}"),

          pw.SizedBox(height: 10),

          /// 🔹 TABLE
          pw.Table.fromTextArray(
            headers: ["Book", "Qty", "Rate", "Amount"],
            data: invoice.data.map((e) {
              return [
                e.bookName,
                e.qty.toString(),
                e.rate.toString(),
                (e.qty * e.rate).toStringAsFixed(2),
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Grand Total: ₹ ${invoice.grandTotal}"),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/invoice_${invoice.billNo}.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}