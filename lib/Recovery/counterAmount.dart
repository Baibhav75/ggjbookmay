import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Service/HrmViewEmployee_service.dart';
import '../Model/HrmViewEmplyeeModel.dart';
import '../Service/send_transfer_otp_service.dart';
import '../Model/send_transfer_otp_model.dart';
import '../Service/verify_transfer_otp_service.dart';

class CounterAmountPage extends StatefulWidget {


  final String agentName;
  final double pendingAmount;
  final String employeeId;

  const CounterAmountPage({
    Key? key,
    required this.agentName,
    required this.pendingAmount,
    required this.employeeId,
  }) : super(key: key);

  @override
  State<CounterAmountPage> createState() => _CounterAmountPageState();
}

class _CounterAmountPageState extends State<CounterAmountPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _amountController;
  final TextEditingController _remarkController = TextEditingController();

  String? selectedPaymentType;
  String? selectedEmployeeId;
  String? selectedEmployeeName;
  File? receiptImage;

  bool isSendingOtp = false;
  bool isVerifyingOtp = false;

  final List<String> paymentTypeList = [ "Cash" ,"Account"];
  List<EmployeeList> employeeList = [];
  bool isLoadingEmployees = true;

  final HrmViewEmployeeService _employeeService = HrmViewEmployeeService();

  final ImagePicker _picker = ImagePicker();


  final SendTransferOtpService _otpService =
  SendTransferOtpService();

  final VerifyTransferOtpService _verifyOtpService =
  VerifyTransferOtpService();

  @override
  void initState() {
    super.initState();

    // ✅ Pending amount auto fill
    _amountController =
        TextEditingController(text: widget.pendingAmount.toStringAsFixed(2));

    _fetchEmployees();
    print("Agent Employee ID: ${widget.employeeId}");
  }

  Future<void> _fetchEmployees() async {
    try {
      final model = await _employeeService.fetchEmployees();
      if (model != null && model.employeeList != null) {
        setState(() {
          employeeList = model.employeeList!;
          isLoadingEmployees = false;
        });
      } else {
        setState(() {
          isLoadingEmployees = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching employees: $e");
      setState(() {
        isLoadingEmployees = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        receiptImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Counter Amount",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      /// Agent Name
                      _buildTextField(
                        initialValue: widget.agentName,
                        label: "Agent Name",
                        icon: Icons.person_outline,
                        readOnly: true,
                      ),

                      const SizedBox(height: 20),

                      /// Employee Dropdown
                      isLoadingEmployees
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(strokeWidth: 3),
                              ),
                            )
                          : _buildDropdown(
                              value: selectedEmployeeId,
                              label: "Select Employee",
                              icon: Icons.badge_outlined,
                              items: employeeList.map((e) {
                                return DropdownMenuItem(
                                  value: e.employeid,
                                  child: Text(e.employeeName ?? "Unknown"),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedEmployeeId = value;
                                  selectedEmployeeName = employeeList
                                      .firstWhere((e) => e.employeid == value)
                                      .employeeName;
                                });
                              },
                              validator: (value) =>
                                  value == null ? "Required" : null,
                            ),

                      const SizedBox(height: 20),

                      /// Amount
                      _buildTextField(
                        controller: _amountController,
                        label: "Transfer Amount",
                        icon: Icons.currency_rupee_outlined,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Required";
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      /// Payment Type
                      _buildDropdown(
                        value: selectedPaymentType,
                        label: "Payment Type",
                        icon: Icons.account_balance_wallet_outlined,
                        items: paymentTypeList.map((e) {
                          return DropdownMenuItem(value: e, child: Text(e));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentType = value;
                            if (value != "Account") receiptImage = null;
                          });
                        },
                        validator: (value) => value == null ? "Required" : null,
                      ),

                      if (selectedPaymentType == "Account") ...[
                        const SizedBox(height: 20),
                        _buildImagePicker(),
                      ],

                      const SizedBox(height: 20),

                      /// Remark
                      _buildTextField(
                        controller: _remarkController,
                        label: "Remark (Optional)",
                        icon: Icons.notes_outlined,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? initialValue,
    TextEditingController? controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple.shade300, size: 22),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple.shade300, size: 22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Receipt Attachment",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
            ),
            child: receiptImage == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text("Upload Receipt Image", style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(receiptImage!, fit: BoxFit.cover),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => setState(() => receiptImage = null),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.indigo],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isSendingOtp ? null : _handleSendOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isSendingOtp
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text(
                "Verify & Send OTP",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
      ),
    );
  }

  Future<void> _handleSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedEmployeeId == null) {
      _showSnackbar("Please select an employee");
      return;
    }

    if (selectedPaymentType == "Account" && receiptImage == null) {
      _showSnackbar("Please upload a receipt image");
      return;
    }

    setState(() => isSendingOtp = true);

    final response = await _otpService.sendTransferOtp(
      fromEmpId: widget.employeeId,
      toEmpId: selectedEmployeeId!,
      amount: _amountController.text,
      remarks: _remarkController.text,
      imageFile: receiptImage,
    );

    setState(() => isSendingOtp = false);

    if (response != null && response.status == "Success") {
      _showSnackbar(response.message ?? "OTP Sent Successfully", success: true);
      _showOtpDialog();
    } else {
      _showSnackbar("Failed to send OTP. Please try again.");
    }
  }

  void _showSnackbar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green.shade600 : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _saveFormAfterOtp(String otp) async {
    setState(() => isVerifyingOtp = true);

    final response = await _verifyOtpService.verifyTransferOtp(
      fromEmpId: widget.employeeId,
      toEmpId: selectedEmployeeId!,
      amount: _amountController.text,
      otp: otp,
    );

    setState(() => isVerifyingOtp = false);

    if (response != null && response.status == "Success") {
      _showSnackbar(response.message ?? "Submitted Successfully", success: true);
      Navigator.pop(context); // Go back after success
    } else {
      _showSnackbar(response?.message ?? "Invalid OTP or Verification Failed");
    }

    print("Agent: ${widget.agentName}");
    print("Employee Name: $selectedEmployeeName");
    print("Employee ID: $selectedEmployeeId");
    print("Amount: ${_amountController.text}");
    print("Payment Type: $selectedPaymentType");
    print("Remark: ${_remarkController.text}");
  }

  void _showOtpDialog() {
    TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Column(
            children: [
              Icon(Icons.mark_email_read_outlined, size: 48, color: Colors.deepPurple),
              SizedBox(height: 16),
              Text("Verification", textAlign: TextAlign.center),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Please enter the 6-digit OTP sent to your registered mobile number.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
                decoration: InputDecoration(
                  hintText: "000000",
                  hintStyle: TextStyle(color: Colors.grey.shade300, letterSpacing: 8),
                  counterText: "",
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text("Cancel", style: TextStyle(color: Colors.grey.shade600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (otpController.text.length == 6) {
                        Navigator.pop(dialogContext);
                        _saveFormAfterOtp(otpController.text);
                      } else {
                        _showSnackbar("Enter valid 6 digit OTP");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Verify", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}