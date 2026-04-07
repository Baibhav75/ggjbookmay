import 'package:flutter/material.dart';
import '../model/counter_pending_amount_model.dart';
import '../service/counter_pending_amount_service.dart';
import 'order_detailsPandingAmount_page.dart';

class PendingAmountPage extends StatefulWidget {
  final String counterId;

  const PendingAmountPage({
    Key? key,
    required this.counterId,
  }) : super(key: key);

  @override
  State<PendingAmountPage> createState() => _PendingAmountPageState();
}

class _PendingAmountPageState extends State<PendingAmountPage> {
  CounterPendingAmountModel? pendingData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPendingAmount();
  }

  Future<void> fetchPendingAmount() async {
    try {
      final data =
      await CounterPendingAmountService.getPendingAmount(widget.counterId);

      setState(() {
        pendingData = data;
        isLoading = false;
      });
      print(pendingData!.sales.length); // 👈 kitne items aaye
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Oder", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1A73E8),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pendingData == null
          ? const Center(child: Text("No Data Found"))
          : Column(
        children: [
          /// TOTAL PENDING
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.orange.shade100,
            child: Text(
              "Total Pending Amount : ₹${pendingData!.totalPayAmount}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// TABLE
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowColor:
              MaterialStateProperty.all(Colors.grey.shade200),
              columns: const [
                DataColumn(label: Text("Sr No")),
                DataColumn(label: Text("Counter Name")),
                DataColumn(label: Text("School Name")),
                DataColumn(label: Text("Buyer Name")),
                DataColumn(label: Text("Mobile")),
                DataColumn(label: Text("Amount")),
                DataColumn(label: Text("Discount")),
                DataColumn(label: Text("Class")),
                DataColumn(label: Text("Payment Type")),
                DataColumn(label: Text("Screenshot")),
                DataColumn(label: Text("Order Verify")),
              ],
              rows: List.generate(
                pendingData!.sales.length,
                    (index) {
                  final item = pendingData!.sales[index];

                  return DataRow(
                    cells: [
                      DataCell(Text("${index + 1}")),

                      DataCell(
                        SizedBox(
                          width: 200,
                          child: Text(item.counterName),
                        ),
                      ),

                      DataCell(
                        SizedBox(
                          width: 200,
                          child: Text(item.schoolName),
                        ),
                      ),

                      DataCell(Text(item.purchaserName)),

                      DataCell(Text(item.purchaserMobileNo)),

                      DataCell(Text("₹${item.totalPayAmount}")),
                      DataCell(Text("₹${item.discount}")),
                      DataCell(Text(item.classes)),
                      DataCell(Text(item.paymenttype)),

                      DataCell(
                        item.paymentImage.isEmpty
                            ? const Text("No Image")
                            : const Icon(Icons.image, color: Colors.blue),
                      ),

                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => OrderDetailsPage(
                                counterId: widget.counterId,
                                orderNo: item.orderNo,
                                initialDiscount: item.discount,
                              ),
                            ).then((value) {
                              // Refresh list after dialog is closed
                              fetchPendingAmount();
                            });
                          },
                          child: const Text("Verify"),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
        ],
      ),
    );
  }
}