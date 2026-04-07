import 'package:flutter/material.dart';
import '/Model/PurchaseMrpLedger_model.dart';
import '/service/purchase_mrp_ledger_service.dart';
import 'package:share_plus/share_plus.dart';
import '/adminPage/PurchaseReturn/purchase_ledger_pdf.dart';



class PurchaseMrpLedgerScreen extends StatefulWidget {
  final String publicationId;

  const PurchaseMrpLedgerScreen({super.key, required this.publicationId});

  @override
  State<PurchaseMrpLedgerScreen> createState() =>
      _PurchaseMrpLedgerScreenState();
}

class _PurchaseMrpLedgerScreenState
    extends State<PurchaseMrpLedgerScreen> {
  final service = PurchaseMrpLedgerService();

  PurchaseMrpLedgerModel? model;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await service.getLedger(widget.publicationId);
    setState(() {
      model = data;
      isLoading = false;
    });
  }

  Future<void> sharePdf() async {
    if (model == null) return;

    final file = await generateLedgerPdf(model!);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Purchase Ledger Report",
    );
  }

  // 🔹 HEADER
  Widget _header() {
    return Column(
      children: [
        /// 🔹 COMPANY
        const Text(
          "GJ BOOK WORLD PVT. LTD.",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),

        const Text(
          "D-1/20, SECTOR 22, GIDA, GORAKHPUR",
          style: TextStyle(fontSize: 14),
        ),
        const Text(
          "Contact: 9354918638",
          style: TextStyle(fontSize: 14),
        ),

        const SizedBox(height: 10),
        const Divider(),

        /// 🔹 TITLE
        const Text(
          "Purchase Ledger Statement",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),

        const SizedBox(height: 5),

        /// 🔹 PUBLICATION
        Text(
          "Publication: ${model!.publication.publication}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        /// 🔹 DATE
        Text(
          "Date: ${DateTime.now().toString().split(" ")[0]}",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  double _calculateBalance(int index) {
    double balance = 0;

    for (int i = 0; i <= index; i++) {
      balance += model!.data[i].credit;
      balance -= model!.data[i].debit;
    }

    return balance;
  }

  // 🔹 TABLE
  Widget _table() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Table(
        border: TableBorder.all(color: Colors.black87),
        columnWidths: const {
          0: FixedColumnWidth(110),
          1: FixedColumnWidth(150),
          2: FixedColumnWidth(260),
          3: FixedColumnWidth(100),
          4: FixedColumnWidth(100),
          5: FixedColumnWidth(120),
        },
        children: [
          _row(
            ["Date", "Type/Vch No", "Particulars", "Debit", "Credit", "Balance"],
            isHeader: true,
          ),

          ...List.generate(model!.data.length, (index) {
            final e = model!.data[index];

            return _row([
              e.date.split("T")[0],
              e.type,
              "Invoice No. ${e.billNo} & Dt. ${e.date.split("T")[0]}",
              e.debit == 0 ? "" : "₹${e.debit.toStringAsFixed(2)}",
              e.credit == 0 ? "" : "₹${e.credit.toStringAsFixed(2)}",
              "₹${_calculateBalance(index).toStringAsFixed(2)}",
            ]);
          }),

          _row(
            [
              "",
              "",
              "Total :",
              "₹${model!.summary.totalDebit.toStringAsFixed(2)}",
              "₹${model!.summary.totalCredit.toStringAsFixed(2)}",
              "",
            ],
            isTotal: true,
          ),

          _row(
            [
              "",
              "",
              "Closing Balance :",
              "",
              "",
              "₹${model!.summary.balance.toStringAsFixed(2)}",
            ],
            isClosing: true,
          ),
        ],
      ),
    );
  }

  // 🔹 ROW DESIGN
  TableRow _row(
      List<String> cells, {
        bool isHeader = false,
        bool isTotal = false,
        bool isClosing = false,
      }) {
    Color bg = Colors.white;

    if (isHeader) bg = Colors.grey.shade300;
    if (isTotal) bg = Colors.grey.shade200;
    if (isClosing) bg = const Color(0xFFDDE3EC);

    return TableRow(
      decoration: BoxDecoration(color: bg),
      children: cells.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Text(
            e,
            style: TextStyle(
              fontSize: 12,
              fontWeight:
              (isHeader || isTotal || isClosing)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  // 🔹 BUILD

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: const Text("Purchase MRP Ledger"),

          backgroundColor: const Color(0xFF6B46C1),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: sharePdf,
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : model == null
            ? const Center(child: Text("No Data"))
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: 900, // ✅ SAME AS MIX REPORT
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        /// 🔥 HEADER (SAME STYLE)
                        _header(),

                        const SizedBox(height: 16),

                        /// 🔥 TABLE
                        _table(),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

}