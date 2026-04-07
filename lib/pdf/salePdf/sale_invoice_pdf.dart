import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '/Model/sale_invoice_details_model.dart';

class SaleInvoicePdf {
  static Future<File> generate(SaleInvoiceDetailsResponse data) async {
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
          pw.Center(child: pw.Text("Sale Invoice")),

          pw.SizedBox(height: 10),

          pw.Text("Invoice No: ${data.billNo}"),
          pw.Text("Party: ${data.schoolName}"),
          pw.Text("Date: ${data.billDate.split("T")[0]}"),

          pw.SizedBox(height: 10),

          /// 🔹 TABLE
          pw.Table.fromTextArray(
            headers: ["Book", "Qty", "Rate", "Amount", "Net"],
            data: data.items.map((e) {
              return [
                e.bookName,
                e.qty.toString(),
                e.rate.toStringAsFixed(2),
                e.amount.toStringAsFixed(2),
                e.netAmount.toStringAsFixed(2),
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Grand Total: ₹ ${data.grandTotal.toStringAsFixed(2)}"),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/sale_invoice_${data.billNo}.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}