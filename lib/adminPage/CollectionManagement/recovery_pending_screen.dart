import 'package:bookworld/adminPage/CollectionManagement/pending_recovery_collect_section.dart';
import 'package:flutter/material.dart';
import '/Model/recovery_pending_list_model.dart';
import '/service/recovery_pending_service.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecoveryPendingScreen extends StatefulWidget {
  const RecoveryPendingScreen({super.key});

  @override
  State<RecoveryPendingScreen> createState() =>
      _RecoveryPendingScreenState();
}

class _RecoveryPendingScreenState extends State<RecoveryPendingScreen> {
  bool isLoading = true;
  String? errorMessage;
  Set<int> selectedIndexes = {};

  List<RecoveryItem> filteredList = [];
  List<RecoveryItem> originalList = [];

  TextEditingController searchController = TextEditingController();

  double totalAmount = 0.0;

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('d/M/yyyy').format(date);
  }
  String? selectedRecoveryBy;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final value = await RecoveryPendingService.fetchData();

      if (value != null) {
        setState(() {
          originalList = value.data;
          filteredList = value.data;
          totalAmount = value.totalAmount;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "No data found";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      setState(() => filteredList = originalList);
      return;
    }

    final results = originalList.where((item) {
      return item.schoolName
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    setState(() => filteredList = results);
  }

  double getFilteredTotal() {
    return filteredList.fold(0.0, (sum, item) => sum + item.amount);
  }



  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.black54)),
        SizedBox(height: 5.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          style: GoogleFonts.poppins(fontSize: 14.sp),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20.sp, color: Colors.deepPurple),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Recovery"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,

      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : Column(
        children: [
          // 🔍 Search and Action Button
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: filterSearch,
                    decoration: InputDecoration(
                      hintText: "Search School...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: selectedIndexes.isNotEmpty
                      ? () {
                    List<RecoveryItem> selectedItems =
                    selectedIndexes.map((i) => filteredList[i]).toList();

                    PendingRecoveryCollectSection.show(
                      context: context,
                      selectedItems: selectedItems,
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Collect Selected", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // 🔥 Total Amount
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.purple.shade100,
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Pending",
                    style:
                    TextStyle(fontWeight: FontWeight.bold)),
                Text("₹ ${getFilteredTotal().toStringAsFixed(2)}"),
              ],
            ),
          ),

          // 📊 TABLE
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text("Select")), // ✅ NEW
                    DataColumn(label: Text("Sr No")),
                    DataColumn(label: Text("School Name")),
                    DataColumn(label: Text("Address")),
                    DataColumn(label: Text("Amount")),
                    DataColumn(label: Text("Recovery By")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("Receipt")),
                    DataColumn(label: Text("Mode")),
                    DataColumn(label: Text("View")),
                  ],
                  rows: List.generate(filteredList.length,
                          (index) {
                        final item = filteredList[index];

                        return DataRow(
                            selected: selectedIndexes.contains(index),
                            cells: [
                              /// ✅ CHECKBOX CELL
                              DataCell(
                                Checkbox(
                                  value: selectedIndexes.contains(index),
                                  onChanged: (value) {
                                    setState(() {
                                      final currentItem = filteredList[index];

                                      if (value == true) {
                                        if (selectedIndexes.isEmpty) {
                                          selectedIndexes.add(index);
                                          selectedRecoveryBy = currentItem.receivedBy;
                                        } else {
                                          if (currentItem.receivedBy == selectedRecoveryBy) {
                                            selectedIndexes.add(index);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Only same Recovery By allowed"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      } else {
                                        selectedIndexes.remove(index);

                                        if (selectedIndexes.isEmpty) {
                                          selectedRecoveryBy = null;
                                        }
                                      }
                                    });
                                  },
                                ),
                              ),

                              /// Sr No
                              DataCell(Text("${index + 1}")),

                              DataCell(Text(item.schoolName)),
                              DataCell(Text(item.schoolAddress)),
                              DataCell(Text("₹ ${item.amount}")),
                              DataCell(Text(item.receivedBy)),
                              DataCell(Text(item.status)),
                              DataCell(Text(formatDate(item.date))),
                              DataCell(Text(item.receiptNo)),
                              DataCell(Text(item.paymentMode)),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(item.schoolName),
                                        content: Text(
                                            "Amount: ₹${item.amount}\nStatus: ${item.status}"),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ]);
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showOtpDialog(BuildContext context) {
    // Deprecated: Logic moved to _showCollectionPopup unified dialog
  }
}