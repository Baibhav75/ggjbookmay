import 'package:flutter/material.dart';
import '../../pdf/PurchaseStockDetailsPdf.dart';
import '/Service/PurchaseStock_register_service.dart';
import '/Model/Purchasestock_register_model.dart';


class StockRegisterScreen extends StatefulWidget {
  final String publicationId;

  const StockRegisterScreen({super.key, required this.publicationId});

  @override
  State<StockRegisterScreen> createState() => _StockRegisterScreenState();
}

class _StockRegisterScreenState extends State<StockRegisterScreen> {
  late Future<StockRegisterModel?> futureData;

  @override
  void initState() {
    super.initState();
    futureData = StockRegisterService().fetchStock(widget.publicationId);
  }

  /// 🔥 GROUP BY SERIES
  Map<String, List<StockItem>> groupBySeries(List<StockItem> items) {
    Map<String, List<StockItem>> grouped = {};

    for (var item in items) {
      grouped.putIfAbsent(item.seriesName, () => []);
      grouped[item.seriesName]!.add(item);
    }

    return grouped;
  }

  String formatNumber(num value) {
    String str = value.abs().toStringAsFixed(2);
    List<String> parts = str.split(".");
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]},';
    String formatted = parts[0].replaceAllMapped(reg, mathFunc);
    String result = formatted + "." + parts[1];
    return value < 0 ? "-$result" : result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Register"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final data = await futureData;
              if (data != null) {
                await generateAndSharePdf(data);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<StockRegisterModel?>(
        future: futureData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final grouped = groupBySeries(data.data);

          num grandRate = data.data.fold(0, (sum, e) => sum + e.rate);

          double screenWidth = MediaQuery.of(context).size.width;
          double tableWidth = screenWidth < 1000 ? 1000 : screenWidth - 16;

          return SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: tableWidth,
                margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔶 HEADER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/icon/gj5.png',
                              height: 40,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.menu_book, size: 40),
                            ),
                            const Text("BOOK WORLD",
                                style: TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                "GJ BOOK WORLD PVT. LTD.",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87),
                              ),
                              SizedBox(height: 5),
                              Text(
                                  "D-1/20, SECTOR 22, GIDA, GORAKHPUR\nCont. - 9354918638, 9354918644\nGST No: 09AAGCG0850B1Z2| CIN No: U22222UP2015PTC068597",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black87)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Colors.black, thickness: 1),

                  /// 🔶 TITLE
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            "Mix Report",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Publication: ${data.publicationName}",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87), 
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// 🔶 TABLE
                  _tableHeader(),

                  /// 🔶 GROUPED DATA
                  ...grouped.entries.map((entry) {
                    final series = entry.key;
                    final list = entry.value;

                    num subPur = list.fold(0, (sum, e) => sum + e.purchaseQty);
                    num subPurRet = list.fold(0, (sum, e) => sum + e.purchaseReturnQty);
                    num subSale = list.fold(0, (sum, e) => sum + e.saleQty);
                    num subSaleRet = list.fold(0, (sum, e) => sum + e.saleReturnQty);
                    num subStock = list.fold(0, (sum, e) => sum + e.stock);
                    num subRate = list.fold(0, (sum, e) => sum + e.rate);
                    num subAmount = list.fold(0, (sum, e) => sum + e.amount);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔶 SERIES HEADER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.5),
                            color: Colors.grey.shade100,
                          ),
                          child: Text(
                            "Series: $series",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),

                        /// 🔶 ITEMS
                        ...list.map((e) {
                          return Row(
                            children: [
                              _borderCell(e.bookName, flex: 4, alignCenter: true),
                              _borderCell("${e.purchaseQty}", flex: 1, alignCenter: true),
                              _borderCell("${e.purchaseReturnQty}", flex: 1, alignCenter: true),
                              _borderCell("${e.saleQty}", flex: 1, alignCenter: true),
                              _borderCell("${e.saleReturnQty}", flex: 1, alignCenter: true),
                              _borderCell("${e.stock}", flex: 1, alignCenter: true, textColor: e.stock < 0 ? Colors.red : Colors.green),
                              _borderCell(formatNumber(e.rate), flex: 1, rightAlign: true),
                              _borderCell(formatNumber(e.amount), flex: 2, rightAlign: true),
                            ],
                          );
                        }).toList(),

                        /// 🔶 SUBTOTAL ROW
                        _summaryRow(
                          "Subtotal:",
                          subPur.toString(),
                          subPurRet.toString(),
                          subSale.toString(),
                          subSaleRet.toString(),
                          subStock.toString(),
                          formatNumber(subRate),
                          formatNumber(subAmount),
                          bgColor: Colors.white,
                        ),
                      ],
                    );
                  }).toList(),

                  /// 🔶 GRAND TOTAL ROW
                  _summaryRow(
                    "Grand Subtotal:",
                    data.totals.totalPurchase.toString(),
                    data.totals.totalPurchaseReturn.toString(),
                    data.totals.totalSale.toString(),
                    data.totals.totalSaleReturn.toString(),
                    data.totals.totalStock.toString(),
                    formatNumber(grandRate),
                    formatNumber(data.totals.totalAmount),
                    bgColor: Colors.grey.shade100,
                  ),

                  /// 🔶 FOOTER SUMMARY (MRP & GP)
                  Container(
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "MRP Purchase: ₹${formatNumber(data.totals.totalAmount)}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Gross Profit: ₹${formatNumber(data.totals.totalAmount)}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              )
            ),
            )
          );

        },
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      color: Colors.grey.shade100,
      child: Row(
        children: [
          _borderCell("Book Name", flex: 4, bold: true, alignCenter: true),
          _borderCell("Purchase", flex: 1, bold: true, alignCenter: true),
          _borderCell("Pur.\nReturn", flex: 1, bold: true, alignCenter: true),
          _borderCell("Sale", flex: 1, bold: true, alignCenter: true),
          _borderCell("Sale\nReturn", flex: 1, bold: true, alignCenter: true),
          _borderCell("Stock", flex: 1, bold: true, alignCenter: true),
          _borderCell("Rate", flex: 1, bold: true, rightAlign: true),
          _borderCell("Amount", flex: 2, bold: true, rightAlign: true),
        ],
      ),
    );
  }

  Widget _summaryRow(
      String title,
      String pur,
      String purRet,
      String sale,
      String saleRet,
      String stock,
      String rate,
      String amount, {
        Color? bgColor,
      }) {
    return Container(
      color: bgColor,
      child: Row(
        children: [
          _borderCell(title, flex: 4, bold: true, rightAlign: true),
          _borderCell(pur, flex: 1, bold: true, alignCenter: true),
          _borderCell(purRet, flex: 1, bold: true, alignCenter: true),
          _borderCell(sale, flex: 1, bold: true, alignCenter: true),
          _borderCell(saleRet, flex: 1, bold: true, alignCenter: true),
          _borderCell(stock, flex: 1, bold: true, alignCenter: true),
          _borderCell(rate, flex: 1, bold: true, rightAlign: true),
          _borderCell(amount, flex: 2, bold: true, rightAlign: true),
        ],
      ),
    );
  }

  Widget _borderCell(
      String text, {
        int flex = 1,
        bool bold = false,
        bool alignCenter = false,
        bool rightAlign = false,
        Color textColor = Colors.black87,
      }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
        ),
        alignment: alignCenter
            ? Alignment.center
            : (rightAlign ? Alignment.centerRight : Alignment.centerLeft),
        child: Text(
          text,
          textAlign: alignCenter ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: 10,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
