import 'package:flutter/material.dart';
import '../model/transfer_history_model.dart';
import '../service/transfer_history_service.dart';

class TransferHistory extends StatefulWidget {
  final String employeeId;

  const TransferHistory({Key? key, required this.employeeId})
      : super(key: key);

  @override
  State<TransferHistory> createState() => _TransferHistoryState();
}

class _TransferHistoryState extends State<TransferHistory> {

  late Future<List<TransferHistoryModel>> historyFuture;

  @override
  void initState() {
    super.initState();
    historyFuture =
        TransferHistoryService.fetchTransferHistory(widget.employeeId);
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF6C00),
        title: const Text(
          "Transfer History ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),


      body: FutureBuilder<List<TransferHistoryModel>>(
        future: historyFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Transfer Found"));
          }

          final historyList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: historyList.length,
            itemBuilder: (context, index) {

              final item = historyList[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Amount + Payment Type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹ ${item.amount}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          if (item.payMentType != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.payMentType!,
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text("From: ${item.fromEmpName} (${item.fromEmpId})"),
                      Text("To: ${item.toEmpName} (${item.toEmpId})"),

                      const SizedBox(height: 6),

                      Text("Date: ${formatDate(item.transferDate)}"),

                      const SizedBox(height: 6),

                      if (item.remarks != null)
                        Text("Remarks: ${item.remarks}"),

                      const SizedBox(height: 8),

                      /// Receipt Image
                      if (item.reciptImage != null)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                child: Image.network(
                                  "https://g17bookworld.com${item.reciptImage}",
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "View Receipt",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}