import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '/Model/sale_mix_report_company_p_model.dart';

class SaleMixCompanyProfitPdf {
  static Future<File> generate(SaleMixReportCompanyPModel data) async {
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
          pw.Center(child: pw.Text("Company Profit Report")),

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
              "PurDisc",
              "SaleDisc",
              "ProfitDisc",
              "NetAmt"
            ],
            data: data.data.map((e) {
              return [
                e.bookName,
                e.saleQty.toString(),
                e.returnQty.toString(),
                e.netQty.toString(),
                e.rate.toStringAsFixed(2),
                e.amount.toStringAsFixed(2),
                e.purchaseDiscount.toStringAsFixed(2),
                e.saleDiscount.toStringAsFixed(2),
                e.profitDiscount.toStringAsFixed(2),
                e.netAmount.toStringAsFixed(2),
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Total Sale: ${data.summary.totalSaleQty}"),
          pw.Text("Total Amount: ₹ ${data.summary.totalAmount.toStringAsFixed(2)}"),
          pw.Text("Net Amount: ₹ ${data.summary.totalNetAmount.toStringAsFixed(2)}"),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File(
        "${dir.path}/company_profit_${DateTime.now().millisecondsSinceEpoch}.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}