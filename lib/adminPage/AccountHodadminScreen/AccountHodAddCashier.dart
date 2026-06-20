import 'package:flutter/material.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  // Common Controllers
  final TextEditingController voucherController = TextEditingController(text: "LDG-002185");
  final TextEditingController amountController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController backDateController = TextEditingController();

  // ADD LEDGER KHATA Controllers
  final TextEditingController companyPartyController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController expenseVoucherController = TextEditingController();
  final TextEditingController receiptVoucherController = TextEditingController();

  // Expenses Controllers
  final TextEditingController partyNameController = TextEditingController();
  final TextEditingController billNoController = TextEditingController();
  final TextEditingController expenseDateController = TextEditingController();

  // Dropdown States
  String? transactionType;
  String? accountGroup;
  String? accountantName;
  String? typeDropdown;
  String? categoryDropdown;
  String? subCategoryDropdown;
  String? paymentModeDropdown;
  String? statusDropdown;

  final List<String> accountGroupsList = [
    "ADD LEDGER KHATA",
    "Assets",
    "Customer",
    "Employee",
    "Expenses",
    "Investor",
    "Other",
    "Purchase Party",
    "Suspense"
  ];

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cashier"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField("Voucher", voucherController),
                buildDropdown(
                  "Transaction Type",
                  transactionType,
                  ["Payment", "Receipt", "Contra", "Journal"],
                  (v) => setState(() => transactionType = v),
                  hint: "-- Select Type --",
                ),
                buildDropdown(
                  "Account Group",
                  accountGroup,
                  accountGroupsList,
                  (v) => setState(() => accountGroup = v),
                  hint: "-- Select Account Group --",
                  isHighlighted: true,
                ),
                
                const SizedBox(height: 8),
                
                buildDynamicFields(),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Save Logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDynamicFields() {
    if (accountGroup == null) return const SizedBox.shrink();

    if (accountGroup == "ADD LEDGER KHATA") {
      return Column(
        children: [
          buildTextField("Company / Party", companyPartyController),
          buildTextField("Mobile Number", mobileController),
          buildTextField("Expense Voucher No", expenseVoucherController),
          buildTextField("Receipt Voucher No", receiptVoucherController),
          buildLabelField(
            "Attach File",
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text("Choose File"),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                side: BorderSide(color: Colors.grey.shade300),
                foregroundColor: Colors.black87,
              ),
            ),
          ),
          buildTextField("Amount", amountController),
          buildTextField("Remarks", remarksController),
          buildTextField(
            "Back Date", 
            backDateController, 
            hintText: "dd/mm/yyyy", 
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
            onTap: () => _selectDate(context, backDateController),
          ),
          buildDropdown("Account Name", accountantName, ["Admin", "Staff"], (v) => setState(() => accountantName = v), hint: "-- Select Accountant --"),
        ],
      );
    }

    if (accountGroup == "Assets") {
      return Column(
        children: [
          buildTextField("Amount", amountController),
          buildTextField("Remarks", remarksController),
          buildTextField(
            "Back Date", 
            backDateController, 
            hintText: "dd/mm/yyyy", 
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
            onTap: () => _selectDate(context, backDateController),
          ),
          buildDropdown("Account Name", accountantName, ["Admin", "Staff"], (v) => setState(() => accountantName = v), hint: "-- Select Accountant --"),
        ],
      );
    }

    if (accountGroup == "Expenses") {
      return Column(
        children: [
          buildTextField("Select OR Type Party Name", partyNameController),
          buildTextField("Bill No", billNoController),
          buildTextField(
            "Expense Date", 
            expenseDateController, 
            hintText: "dd/mm/yyyy", 
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
            onTap: () => _selectDate(context, expenseDateController),
          ),
          buildDropdown("Category", categoryDropdown, ["Category 1", "Category 2"], (v) => setState(() => categoryDropdown = v), hint: "-- Select Category --"),
          buildDropdown("Sub Category", subCategoryDropdown, ["Sub 1", "Sub 2"], (v) => setState(() => subCategoryDropdown = v), hint: "-- Select Sub Category --"),
          buildDropdown("Payment Mode", paymentModeDropdown, ["Cash", "Online"], (v) => setState(() => paymentModeDropdown = v), hint: "-- Select Mode --"),
          buildDropdown("Status", statusDropdown, ["Pending", "Paid"], (v) => setState(() => statusDropdown = v), hint: "-- Select Status --"),
          buildTextField("Amount", amountController),
          buildTextField("Remarks", remarksController),
          buildTextField(
            "Back Date", 
            backDateController, 
            hintText: "dd/mm/yyyy", 
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
            onTap: () => _selectDate(context, backDateController),
          ),
          buildDropdown("Accountant Name", accountantName, ["Admin", "Staff"], (v) => setState(() => accountantName = v), hint: "-- Select Accountant --"),
        ],
      );
    }

    // Default for Customer, Employee, Investor, Other, Purchase Party, Suspense
    return Column(
      children: [
        buildDropdown("Type", typeDropdown, ["Type A", "Type B"], (v) => setState(() => typeDropdown = v), hint: "-- Select Type --"),
        buildTextField("Amount", amountController),
        buildTextField("Remarks", remarksController),
        buildTextField(
          "Back Date", 
          backDateController, 
          hintText: "dd/mm/yyyy", 
          readOnly: true,
          suffixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
          onTap: () => _selectDate(context, backDateController),
        ),
        buildDropdown("Account Name", accountantName, ["Admin", "Staff"], (v) => setState(() => accountantName = v), hint: "-- Select Accountant --"),
      ],
    );
  }

  Widget buildLabelField(String title, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(child: field),
        ],
      ),
    );
  }

  Widget buildTextField(String title, TextEditingController controller, {String? hintText, Widget? suffixIcon, bool readOnly = false, VoidCallback? onTap}) {
    return buildLabelField(
      title,
      TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String title, String? value, List<String> items, Function(String?) onChanged, {String hint = "-- Select --", bool isHighlighted = false}) {
    return buildLabelField(
      title,
      DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint),
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: isHighlighted ? Colors.blue.shade200 : Colors.grey.shade300, width: isHighlighted ? 2 : 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: isHighlighted ? Colors.blue.shade200 : Colors.grey.shade300, width: isHighlighted ? 2 : 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: isHighlighted,
          fillColor: isHighlighted ? Colors.blue.withOpacity(0.05) : null,
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}