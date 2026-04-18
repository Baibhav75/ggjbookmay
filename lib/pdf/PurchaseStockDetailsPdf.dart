import '/Model/Purchasestock_register_model.dart';

/// ✅ PDF IMPORTS
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// 🔥 GROUP BY SERIES
Map<String, List<StockItem>> groupBySeries(List<StockItem> items) {
  Map<String, List<StockItem>> grouped = {};

  for (var item in items) {
    grouped.putIfAbsent(item.seriesName, () => []);
    grouped[item.seriesName]!.add(item);
  }

  return grouped;
}

/// 🔥 NUMBER FORMAT
String formatNumber(num value) {
  String str = value.abs().toStringAsFixed(2);
  List<String> parts = str.split(".");
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String mathFunc(Match match) => '${match[1]},';
  String formatted = parts[0].replaceAllMapped(reg, mathFunc);
  String result = formatted + "." + parts[1];
  return value < 0 ? "-$result" : result;
}

/// 🔥 MAIN PDF FUNCTION
Future<void> generateAndSharePdf(StockRegisterModel data) async {
  final pdf = pw.Document();
  final grouped = groupBySeries(data.data);

  num grandRate = data.data.fold(0, (sum, e) => sum + e.rate);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(10),
      build: (context) {
        return [

          /// 🔶 HEADER
          pw.Row(
            children: [
              pw.Container(
                width: 50,
                height: 50,
                alignment: pw.Alignment.center,
                child: pw.Text("LOGO"),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text("GJ BOOK WORLD PVT. LTD.",
                        style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 9354918638",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.Divider(),

          /// 🔶 TITLE
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text("Mix Report",
                    style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline)),
                pw.Text("Publication: ${data.publicationName}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),

          pw.SizedBox(height: 10),

          /// 🔶 TABLE HEADER
          _pdfHeaderRow(),

          /// 🔶 DATA
          ...grouped.entries.map((entry) {
            final series = entry.key;
            final list = entry.value;

            num subPur = list.fold(0, (s, e) => s + e.purchaseQty);
            num subPurRet = list.fold(0, (s, e) => s + e.purchaseReturnQty);
            num subSale = list.fold(0, (s, e) => s + e.saleQty);
            num subSaleRet = list.fold(0, (s, e) => s + e.saleReturnQty);
            num subStock = list.fold(0, (s, e) => s + e.stock);
            num subRate = list.fold(0, (s, e) => s + e.rate);
            num subAmount = list.fold(0, (s, e) => s + e.amount);

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                /// SERIES
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(5),
                  color: PdfColors.grey200,
                  child: pw.Text("Series: $series",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold)),
                ),

                /// ROWS
                ...list.map((e) {
                  return _pdfRow([
                    e.bookName,
                    e.purchaseQty.toString(),
                    e.purchaseReturnQty.toString(),
                    e.saleQty.toString(),
                    e.saleReturnQty.toString(),
                    e.stock.toString(),
                    formatNumber(e.rate),
                    formatNumber(e.amount),
                  ]);
                }),

                /// SUBTOTAL
                _pdfSummaryRow(
                  "Subtotal:",
                  subPur,
                  subPurRet,
                  subSale,
                  subSaleRet,
                  subStock,
                  subRate,
                  subAmount,
                ),
              ],
            );
          }),

          /// GRAND TOTAL
          _pdfSummaryRow(
            "Grand Subtotal:",
            data.totals.totalPurchase,
            data.totals.totalPurchaseReturn,
            data.totals.totalSale,
            data.totals.totalSaleReturn,
            data.totals.totalStock,
            grandRate,
            data.totals.totalAmount,
          ),

          pw.SizedBox(height: 10),

          /// FOOTER
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text("MRP Purchase: ₹${formatNumber(data.totals.totalAmount)}"),
                pw.Text("Gross Profit: ₹${formatNumber(data.totals.totalAmount)}"),
              ],
            ),
          ),
        ];
      },
    ),
  );

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: "Stock_Register.pdf",
  );
}

/// 🔶 HEADER ROW
pw.Widget _pdfHeaderRow() {
  return pw.Row(
    children: [
      _pdfCell("Book Name", flex: 4, bold: true),
      _pdfCell("Purchase", bold: true),
      _pdfCell("Pur Return", bold: true),
      _pdfCell("Sale", bold: true),
      _pdfCell("Sale Return", bold: true),
      _pdfCell("Stock", bold: true),
      _pdfCell("Rate", bold: true),
      _pdfCell("Amount", flex: 2, bold: true),
    ],
  );
}

/// 🔶 ROW
pw.Widget _pdfRow(List<String> data) {
  return pw.Row(
    children: [
      _pdfCell(data[0], flex: 4),
      _pdfCell(data[1]),
      _pdfCell(data[2]),
      _pdfCell(data[3]),
      _pdfCell(data[4]),
      _pdfCell(data[5]),
      _pdfCell(data[6]),
      _pdfCell(data[7], flex: 2),
    ],
  );
}

/// 🔶 SUMMARY
pw.Widget _pdfSummaryRow(
    String title,
    num pur,
    num purRet,
    num sale,
    num saleRet,
    num stock,
    num rate,
    num amount,
    ) {
  return pw.Row(
    children: [
      _pdfCell(title, flex: 4, bold: true),
      _pdfCell(pur.toString(), bold: true),
      _pdfCell(purRet.toString(), bold: true),
      _pdfCell(sale.toString(), bold: true),
      _pdfCell(saleRet.toString(), bold: true),
      _pdfCell(stock.toString(), bold: true),
      _pdfCell(formatNumber(rate), bold: true),
      _pdfCell(formatNumber(amount), flex: 2, bold: true),
    ],
  );
}

/// 🔶 CELL
pw.Widget _pdfCell(String text,
    {int flex = 1, bool bold = false}) {
  return pw.Expanded(
    flex: flex,
    child: pw.Container(
      padding: const pw.EdgeInsets.all(4),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 0.5),
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight:
          bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    ),
  );
}