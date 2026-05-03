import 'package:flutter/material.dart';
import '../../services/otp_service.dart';
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

  void _showCollectionPopup() {
    if (selectedIndexes.isEmpty) return;

    List<RecoveryItem> selectedItems = selectedIndexes.map((i) => filteredList[i]).toList();
    double total = selectedItems.fold(0.0, (sum, item) => sum + item.amount);
    String vouchers = selectedItems.map((e) => e.receiptNo).where((v) => v.isNotEmpty).join(', ');
    String agentName = selectedItems.first.receivedBy.isNotEmpty ? selectedItems.first.receivedBy : "Agent";

    TextEditingController amountController = TextEditingController(text: total.toStringAsFixed(2));
    TextEditingController mobileController = TextEditingController(text: "9523070151");
    TextEditingController vouchersController = TextEditingController(text: vouchers);
    TextEditingController remarksController = TextEditingController();
    TextEditingController otpController = TextEditingController();

    String? selectedCashier;
    List<String> cashiers = ["GOVIND JAISWAL ", "Rekha jaiswal",];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isOtpSent = false;
        bool isSending = false;
        bool isVerifying = false;

        return StatefulBuilder(
          builder: (context, setPopupState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
              child: Container(
                width: 400.w,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isOtpSent ? "Verification" : "$agentName (Details)",
                            style: GoogleFonts.poppins(
                              color: Colors.deepPurple,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey, size: 24.sp),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                      const Divider(),
                      SizedBox(height: 10.h),

                      if (!isOtpSent) ...[
                        // Step 1: Details Form
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                label: "Total Amount",
                                controller: amountController,
                                icon: Icons.currency_rupee,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: _buildInputField(
                                label: "Agent Mobile",
                                controller: mobileController,
                                icon: Icons.phone_android,
                                keyboardType: TextInputType.phone,
                                onChanged: (val) => setPopupState(() {}), // Update button text
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        _buildInputField(
                          label: "Vouchers",
                          controller: vouchersController,
                          icon: Icons.receipt_long,
                          maxLines: 2,
                        ),
                        SizedBox(height: 15.h),
                        Text("Cashier (Office Staff)",
                            style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.black54)),
                        SizedBox(height: 5.h),
                        DropdownButtonFormField<String>(
                          value: selectedCashier,
                          hint: Text("-- Select Cashier --", style: GoogleFonts.poppins(fontSize: 13.sp)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                            isDense: true,
                            prefixIcon: Icon(Icons.person, size: 20.sp, color: Colors.deepPurple),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                          ),
                          items: cashiers.map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.poppins()))).toList(),
                          onChanged: (val) => setPopupState(() => selectedCashier = val),
                        ),
                        SizedBox(height: 15.h),
                        _buildInputField(
                          label: "Remarks (Optional)",
                          controller: remarksController,
                          icon: Icons.notes,
                          maxLines: 2,
                        ),
                        SizedBox(height: 25.h),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isSending ? null : () async {
                              String phone = mobileController.text.trim();
                              if (phone.length != 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Enter valid 10-digit mobile number")),
                                );
                                return;
                              }

                              setPopupState(() => isSending = true);

                              await OtpService.sendOtp(
                                phone: phone,
                                onError: (msg) {
                                  setPopupState(() => isSending = false);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                                },
                                onCodeSent: () {
                                  setPopupState(() {
                                    isSending = false;
                                    isOtpSent = true;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("OTP Sent Successfully")),
                                  );
                                },
                                onAutoVerified: () {
                                  setPopupState(() => isSending = false);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Auto Verified ✅")));
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              elevation: 2,
                            ),
                            child: isSending
                                ? SizedBox(height: 20.h, width: 20.h, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                                : Text(
                              "Send OTP to ${mobileController.text}",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14.sp),
                            ),
                          ),
                        )
                      ] else ...[
                        // Step 2: OTP Verification
                        Center(
                          child: Column(
                            children: [
                              Icon(Icons.mark_email_read_outlined, size: 60.sp, color: Colors.amber),
                              SizedBox(height: 15.h),
                              Text("Enter the OTP sent to", style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.black54)),
                              Text("+91 ${mobileController.text}", style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                              SizedBox(height: 25.h),

                              TextField(
                                controller: otpController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.bold, letterSpacing: 10),
                                maxLength: 6,
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: "000000",
                                  hintStyle: TextStyle(color: Colors.grey.shade300, letterSpacing: 10),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber, width: 2.w)),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple, width: 2.w)),
                                ),
                              ),
                              SizedBox(height: 30.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => setPopupState(() => isOtpSent = false),
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 15.h),
                                        side: const BorderSide(color: Colors.grey),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                      ),
                                      child: Text("Back", style: GoogleFonts.poppins(color: Colors.black)),
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: isVerifying ? null : () async {
                                        if (otpController.text.length < 6) return;

                                        setPopupState(() => isVerifying = true);
                                        bool success = await OtpService.verifyOtp(otpController.text);

                                        if (success) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP Verified ✅")));
                                          // TODO: Call your final collection API here
                                        } else {
                                          setPopupState(() => isVerifying = false);
                                          otpController.clear();
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP ❌")));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: 15.h),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                      ),
                                      child: isVerifying
                                          ? SizedBox(height: 20.h, width: 20.h, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                          : Text("Verify OTP", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              TextButton(
                                onPressed: isSending ? null : () {
                                  // Reuse send logic for resend
                                  setPopupState(() => isSending = true);
                                  OtpService.sendOtp(
                                    phone: mobileController.text,
                                    onError: (m) => setPopupState(() => isSending = false),
                                    onCodeSent: () => setPopupState(() => isSending = false),
                                    onAutoVerified: () => Navigator.pop(context),
                                  );
                                },
                                child: Text("Resend OTP", style: GoogleFonts.poppins(color: Colors.deepPurple, fontWeight: FontWeight.w600)),
                              )
                            ],
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
                  onPressed: selectedIndexes.isNotEmpty ? _showCollectionPopup : null,
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