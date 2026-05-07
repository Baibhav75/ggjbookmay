import 'package:flutter/material.dart';
import '../../services/otp_serviceGenerater.dart';
import '/Model/recovery_pending_list_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingRecoveryCollectSection {
  static void show({
    required BuildContext context,
    required List<RecoveryItem> selectedItems,
  }) {
    if (selectedItems.isEmpty) return;

    double total =
    selectedItems.fold(0.0, (sum, item) => sum + item.amount);

    String vouchers = selectedItems
        .map((e) => e.receiptNo)
        .where((v) => v.isNotEmpty)
        .join(', ');

    String agentName = selectedItems.first.receivedBy.isNotEmpty
        ? selectedItems.first.receivedBy
        : "Agent";

    /// 🔥 Controllers
    TextEditingController amountController =
    TextEditingController(text: total.toStringAsFixed(2));

    TextEditingController mobileController =
    TextEditingController(text: "9523070151");

    TextEditingController vouchersController =
    TextEditingController(text: vouchers);

    TextEditingController remarksController = TextEditingController();
    TextEditingController otpController = TextEditingController();

    /// 🔥 Local State
    String? selectedCashier;
    String? generatedOtp;

    List<String> cashiers = ["GOVIND JAISWAL ", "Rekha jaiswal"];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isSubmitting = false;
        bool showOtpField = false;

        return StatefulBuilder(
          builder: (context, setPopupState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
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
                      /// 🔥 HEADER
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$agentName (Collection Details)",
                            style: GoogleFonts.poppins(
                              color: Colors.deepPurple,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close,
                                color: Colors.grey, size: 24.sp),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),

                      const Divider(),
                      SizedBox(height: 10.h),

                      /// 🔥 FORM
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: "Total Amount",
                              controller: amountController,
                              icon: Icons.currency_rupee,
                              keyboardType:
                              TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: _buildInputField(
                              label: "Agent Mobile",
                              controller: mobileController,
                              icon: Icons.phone_android,
                              keyboardType:
                              TextInputType.phone,
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

                      Text(
                        "Cashier (Office Staff)",
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),

                      SizedBox(height: 5.h),

                      DropdownButtonFormField<String>(
                        value: selectedCashier,
                        hint: Text("-- Select Cashier --",
                            style:
                            GoogleFonts.poppins(fontSize: 13.sp)),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(8.r),
                          ),
                          isDense: true,
                          prefixIcon: Icon(Icons.person,
                              size: 20.sp,
                              color: Colors.deepPurple),
                          contentPadding:
                          EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 12.h),
                        ),
                        items: cashiers
                            .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c,
                              style:
                              GoogleFonts.poppins()),
                        ))
                            .toList(),
                        onChanged: (val) =>
                            setPopupState(
                                    () => selectedCashier = val),
                      ),

                      SizedBox(height: 15.h),

                      _buildInputField(
                        label: "Remarks (Optional)",
                        controller: remarksController,
                        icon: Icons.notes,
                        maxLines: 2,
                      ),

                      SizedBox(height: 15.h),

                      /// 🔥 SEND OTP
                      if (!showOtpField)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (selectedCashier == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select a cashier"),
                                  ),
                                );
                                return;
                              }

                              /// 🔹 Generate OTP HERE (UI side)
                              final random = Random();
                              generatedOtp =
                                  (100000 + random.nextInt(900000)).toString();

                              /// 🔹 Send OTP
                              bool success = await Fast2SmsService.sendOtp(
                                phone: mobileController.text.trim(),
                                otp: generatedOtp!,
                              );

                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("OTP Sent ✅")),
                                );

                                setPopupState(() => showOtpField = true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Failed to send OTP ❌")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "Send OTP",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      /// 🔥 OTP VERIFY
                      if (showOtpField) ...[
                        _buildInputField(
                          label: "Enter OTP",
                          controller: otpController,
                          icon: Icons.lock_outline,
                          keyboardType:
                          TextInputType.number,
                        ),

                        SizedBox(height: 25.h),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () async {
                              /// 🔹 Validate OTP
                              if (otpController.text
                                  .trim() !=
                                  generatedOtp) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Invalid OTP ❌")),
                                );
                                return;
                              }

                              setPopupState(() =>
                              isSubmitting = true);

                              await Future.delayed(
                                  const Duration(
                                      seconds: 1));

                              setPopupState(() =>
                              isSubmitting = false);

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Collection Recorded Successfully ✅"),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.h),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(8.r),
                              ),
                            ),
                            child: isSubmitting
                                ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child:
                              const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : Text("Confirm Collection",
                                style:
                                GoogleFonts.poppins(
                                  fontWeight:
                                  FontWeight.bold,
                                )),
                          ),
                        ),
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

  /// 🔹 INPUT FIELD
  static Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 5.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style:
          GoogleFonts.poppins(fontSize: 14.sp),
          decoration: InputDecoration(
            prefixIcon: Icon(icon,
                size: 20.sp,
                color: Colors.deepPurple),
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(8.r),
            ),
            isDense: true,
            contentPadding:
            EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 12.h),
          ),
        ),
      ],
    );
  }
}