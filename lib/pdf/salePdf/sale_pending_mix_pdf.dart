import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '/Model/sale_pending_mix_order_model.dart';

class SalePendingMixPdf {
  static Future<File> generate(SalePendingMixOrderModel data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [

          /// HEADER
          pw.Center(
            child: pw.Text(
              "Sale and Order Pending Mix Report",
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 5),
          pw.Center(child: pw.Text(data.schoolName)),

          pw.SizedBox(height: 10),

          /// TABLE
          pw.Table.fromTextArray(
            headers: ["Book", "Order", "Sale", "Pending", "Rate"],
            data: data.data.map((e) {
              return [
                e.bookName,
                e.totalOrder.toString(),
                e.sale.toString(),
                e.pending,
                e.rate.toStringAsFixed(2),
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Total Order: ${data.summary.totalOrder}"),
          pw.Text("Total Sale: ${data.summary.totalSale}"),
          pw.Text("Total Pending: ${data.summary.totalPending}"),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File(
        "${dir.path}/pending_mix_${DateTime.now().millisecondsSinceEpoch}.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}