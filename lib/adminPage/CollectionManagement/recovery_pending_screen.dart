import 'package:flutter/material.dart';
import '/Model/recovery_pending_list_model.dart';
import '/service/recovery_pending_service.dart';

class RecoveryPendingScreen extends StatefulWidget {
  const RecoveryPendingScreen({super.key});

  @override
  State<RecoveryPendingScreen> createState() =>
      _RecoveryPendingScreenState();
}

class _RecoveryPendingScreenState extends State<RecoveryPendingScreen> {
  late Future<RecoveryPendingListModel?> future;

  @override
  void initState() {
    super.initState();
    future = RecoveryPendingService.fetchData();
  }

  Widget th(String text) => Padding(
    padding: const EdgeInsets.all(8),
    child: Text(text,
        textAlign: TextAlign.center,
        style:
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
  );

  Widget td(String text,
      {TextAlign align = TextAlign.center}) =>
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text,
            textAlign: align,
            style: const TextStyle(fontSize: 12)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Recovery"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<RecoveryPendingListModel?>(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 1200,
                color: Colors.white,
                child: Column(
                  children: [

                    /// TABLE
                    Table(
                      border: TableBorder.all(color: Colors.black87),
                      columnWidths: const {
                        0: FixedColumnWidth(50),
                        1: FixedColumnWidth(200),
                        2: FixedColumnWidth(220),
                        3: FixedColumnWidth(100),
                        4: FixedColumnWidth(140),
                        5: FixedColumnWidth(100),
                        6: FixedColumnWidth(100),
                        7: FixedColumnWidth(120),
                        8: FixedColumnWidth(100),
                        9: FixedColumnWidth(120),
                      },
                      children: [

                        /// HEADER
                        TableRow(
                          decoration:
                          BoxDecoration(color: Colors.grey.shade200),
                          children: [
                            th("Sr No"),
                            th("School Name"),
                            th("Address"),
                            th("Amount"),
                            th("Recovery By"),
                            th("Payment"),
                            th("Status"),
                            th("Receipt No"),
                            th("Mode"),
                            th("Action"),
                          ],
                        ),

                        /// DATA
                        ...List.generate(data.data.length, (index) {
                          final e = data.data[index];

                          return TableRow(children: [
                            td((index + 1).toString()),
                            td(e.schoolName, align: TextAlign.left),
                            td(e.schoolAddress, align: TextAlign.left),
                            td("₹${e.amount.toStringAsFixed(0)}"),
                            td(e.receivedBy),
                            td(e.date.split("T")[0]),
                            td(e.status),
                            td(e.receiptNo),
                            td(e.paymentMode),

                            /// ACTION BUTTON
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: Action
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                ),
                                child: const Text("Collect",
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ]);
                        }),

                        /// TOTAL
                        TableRow(
                          decoration: BoxDecoration(
                              color: Colors.green.shade100),
                          children: [
                            td(""),
                            td("Total",
                                align: TextAlign.right),
                            td(""),
                            td("₹${data.totalAmount.toStringAsFixed(0)}"),
                            ...List.generate(6, (_) => const SizedBox()),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}