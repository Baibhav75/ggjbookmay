import 'package:flutter/material.dart';
import '../model/counter_stock_model.dart';
import '../service/counter_stock_service.dart';
import 'CounterStockDetailsPage.dart';

class CounterStockPage extends StatefulWidget {
  final String counterId;

  const CounterStockPage({
    Key? key,
    required this.counterId,
  }) : super(key: key);

  @override
  State<CounterStockPage> createState() =>
      _CounterStockPageState();
}

class _CounterStockPageState extends State<CounterStockPage> {

  late Future<CounterStockModel> stockFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    stockFuture =
        CounterStockService.fetchCounterStock(widget.counterId);
  }

  Future<void> _refresh() async {
    setState(() {
      _loadData();
    });
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Today's Sale",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A73E8),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<CounterStockModel>(
          future: stockFuture,
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Something went wrong",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            if (!snapshot.hasData ||
                snapshot.data!.billList.isEmpty) {
              return const Center(
                child: Text("No Transactions Found"),
              );
            }

            final data = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [

                /// 🔵 SUMMARY CARD
                _buildSummaryCard(data),

                const SizedBox(height: 25),

                const Text(
                  "Recent Transactions",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                _buildTableHeader(),

                const Divider(height: 1),

                ...List.generate(
                  data.billList.length,
                      (index) => _buildRow(data, index),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 🔵 SUMMARY CARD
  Widget _buildSummaryCard(CounterStockModel data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade400
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.counterName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Total Bills: ${data.totalBills}",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            "Grand Total: ₹${data.grandTotalAmount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔵 TABLE HEADER
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.blue.shade50,
      child: const Row(
        children: [
          Expanded(
              flex: 1,
              child: Text("SrNo",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Text("School Name",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Date",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("View",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  /// 🔵 TABLE ROW
  Widget _buildRow(CounterStockModel data, int index) {
    final bill = data.billList[index];

    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [

              Expanded(
                flex: 1,
                child: Text("${index + 1}"),
              ),

              Expanded(
                flex: 3,
                child: Text(
                  bill.schoolName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Expanded(
                flex: 2,
                child: Text(formatDate(bill.billDate)),
              ),

              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CounterStockDetailsPage(
                              billNo: bill.billNo,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                    const EdgeInsets.symmetric(
                        vertical: 6),
                  ),
                  child: const Text("View"),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}