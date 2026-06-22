import 'package:flutter/material.dart';

import '/Model/add_day_book_form_data_model.dart';
import '/Model/get_form_date_cashier_sub_category_model.dart';
import '/Service/add_day_book_form_data_service.dart';
import '/Service/get_form_date_cashier_sub_category_service.dart';
import '/Model/CategoryAccountGroupType.dart';
import '/Service/CategoryAccountGroupTypeService.dart';
import '/appDart/auth_servcie.dart';
import '/Model/add_ladger_khata_response_model.dart';
import '/Service/add_ladger_khata_service.dart';


class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  final AddDayBookFormDataService _formDataService =
      AddDayBookFormDataService();
  final GetFormDateCashierSubCategoryService _subCategoryService =
      GetFormDateCashierSubCategoryService();
  final CategoryMasterService _categoryMasterService =
      CategoryMasterService();
  final AuthService _authService = AuthService();
  final AddLadgerKhataService _addLadgerKhataService = AddLadgerKhataService();

  // Common Controllers
  final TextEditingController voucherController = TextEditingController();
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

  // Customer Block Controllers
  final TextEditingController paymentDateController = TextEditingController();
  final TextEditingController cashierMobileController = TextEditingController();

  // Dropdown States
  String? transactionType;
  String? accountGroup;
  String? accountantName;
  String? typeDropdown;
  String? categoryDropdown;
  String? subCategoryDropdown;
  String? selectedExpenseParty;
  String? paymentModeDropdown;
  String? statusDropdown;

  // Customer Block States
  String? selectedCustomer;
  String? selectedCashier;
  String? selectedAgent;

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSubCategoryLoading = false;
  String? _errorMessage;
  AddDayBookFormDataModel? _formData;
  CategoryMasterModel? _categoryMasterModel;
  List<String> _typeList = [];
  List<GetFormDateCashierSubCategoryItem> _subCategories =
      <GetFormDateCashierSubCategoryItem>[];

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  @override
  void dispose() {
    voucherController.dispose();
    amountController.dispose();
    remarksController.dispose();
    backDateController.dispose();
    companyPartyController.dispose();
    mobileController.dispose();
    expenseVoucherController.dispose();
    receiptVoucherController.dispose();
    partyNameController.dispose();
    billNoController.dispose();
    expenseDateController.dispose();
    paymentDateController.dispose();
    cashierMobileController.dispose();
    super.dispose();
  }

  Future<void> _loadFormData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final formData = await _formDataService.fetchFormData();
      final categoryMasterData = await _categoryMasterService.getCategoryMasterList();

      if (!mounted) return;

      setState(() {
        _formData = formData;
        _categoryMasterModel = categoryMasterData;
        voucherController.text = formData.autoVoucher;
        billNoController.text = formData.expNextBillNo;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _updateTypeList(String? selectedGroupName) {
    if (selectedGroupName == null || _formData == null || _categoryMasterModel == null) {
      _typeList = [];
      typeDropdown = null;
      return;
    }

    final selectedGroup = _formData!.accountGroups.firstWhere(
      (item) => item.name == selectedGroupName,
      orElse: () => AddDayBookLookupItem(id: '', name: ''),
    );

    if (selectedGroup.id.isEmpty) {
      _typeList = [];
      typeDropdown = null;
      return;
    }

    final filteredCategories = _categoryMasterModel!.categoryList
        .where((item) => item.parentId == selectedGroup.id)
        .map((item) => item.categoryName)
        .where((name) => name.toUpperCase() != "COUNTER")
        .toList();

    _typeList = filteredCategories;
    typeDropdown = null;
  }

  List<String> get accountGroupsList {
    return _formData?.accountGroups.map((item) => item.name).toList() ?? <String>[];
  }

  List<String> get accountantList {
    return _formData?.accountants.map((item) => item.name).toList() ?? <String>[];
  }

  List<String> get customerList {
    return _formData?.customerList.map((item) => item.name).toList() ?? <String>[];
  }

  List<String> get cashierList {
    return _formData?.accountants.map((item) => item.name).toList() ?? <String>[];
  }

  List<String> get agentList {
    return _formData?.allEmployees.map((item) => item.name).toList() ?? <String>[];
  }

  List<String> get expenseCategoryList {
    return _formData?.expenseCategories.map((item) => item.name).toList() ??
        <String>[];
  }

  List<String> get expensePartyList {
    return _formData?.expenseParties.map((item) => item.name).toList() ??
        <String>[];
  }

  List<String> get subCategoryList {
    return _subCategories.map((item) => item.subCategoryName).toList();
  }

  Future<void> _loadSubCategories(String categoryName) async {
    final selectedCategory = _formData?.expenseCategories.firstWhere(
      (item) => item.name == categoryName,
      orElse: () => AddDayBookLookupItem(id: '', name: ''),
    );

    final categoryId = selectedCategory?.id ?? '';
    if (categoryId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _subCategories = <GetFormDateCashierSubCategoryItem>[];
        subCategoryDropdown = null;
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isSubCategoryLoading = true;
      _subCategories = <GetFormDateCashierSubCategoryItem>[];
      subCategoryDropdown = null;
    });

    try {
      final response = await _subCategoryService.fetchSubCategories(categoryId);

      if (!mounted) return;
      setState(() {
        _subCategories = response.data;
        _isSubCategoryLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _subCategories = <GetFormDateCashierSubCategoryItem>[];
        _isSubCategoryLoading = false;
      });
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _handleSave() async {
    if (accountGroup == "Customer" && typeDropdown?.toUpperCase() == "SCHOOL") {
      await _submitSchoolPayment();
    } else {
      // Other sections logic will go here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save for this section is not yet implemented.')),
      );
    }
  }

  Future<void> _submitSchoolPayment() async {
    if (selectedCustomer == null ||
        selectedCashier == null ||
        selectedAgent == null ||
        paymentDateController.text.isEmpty ||
        amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final customerId = _formData?.customerList
              .firstWhere((e) => e.name == selectedCustomer,
                  orElse: () => AddDayBookLookupItem(id: '', name: ''))
              .id ?? '';

      final cashierId = _formData?.accountants
              .firstWhere((e) => e.name == selectedCashier,
                  orElse: () => AddDayBookLookupItem(id: '', name: ''))
              .id ?? '';

      final agentId = _formData?.allEmployees
              .firstWhere((e) => e.name == selectedAgent,
                  orElse: () => AddDayBookLookupItem(id: '', name: ''))
              .id ?? '';

      final parts = paymentDateController.text.split('/');
      final formattedDate = parts.length == 3
          ? "${parts[2]}-${parts[1]}-${parts[0]}"
          : paymentDateController.text;

      final response = await _addLadgerKhataService.submitSchoolPayment(
        schoolId: customerId,
        cashierId: cashierId,
        agentId: agentId,
        paymentDate: formattedDate,
        amount: amountController.text,
        remarks: remarksController.text,
        customerMobile: cashierMobileController.text,
      );

      if (mounted) {
        if (response.status) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message), backgroundColor: Colors.green),
          );
          setState(() {
            selectedCustomer = null;
            selectedCashier = null;
            selectedAgent = null;
            paymentDateController.clear();
            amountController.clear();
            remarksController.clear();
            cashierMobileController.clear();
            backDateController.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
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
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadFormData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 44),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadFormData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField("Voucher", voucherController, readOnly: true),
              buildDropdown(
                "Transaction Type",
                transactionType,
                const ["CREDIT", "DEBIT"],
                (v) => setState(() => transactionType = v),
                hint: "-- Select Type --",
              ),
              buildDropdown(
                "Account Group",
                accountGroup,
                accountGroupsList,
                (v) {
                  setState(() {
                    accountGroup = v;
                    _updateTypeList(v);
                  });
                },
                hint: "-- Select Account Group --",
                isHighlighted: true,
              ),
              if (accountGroupsList.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'No account groups found from API.',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              if (accountGroup == "EXPENSES")
                buildDropdown(
                  "Expense Party",
                  selectedExpenseParty,
                  expensePartyList,
                  (v) {
                    setState(() {
                      selectedExpenseParty = v;
                      partyNameController.text = v ?? '';
                    });
                  },
                  hint: "-- Select Expense Party --",
                ),
              if (accountGroup == "EXPENSES" && expensePartyList.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'No expense parties found from API.',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              const SizedBox(height: 8),
              buildDynamicFields(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
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
            suffixIcon:
                const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
            onTap: () => _selectDate(context, backDateController),
          ),
          buildDropdown(
            "Account Name",
            accountantName,
            accountantList,
            (v) => setState(() => accountantName = v),
            hint: "-- Select Accountant --",
          ),
        ],
      );
    }

    if (accountGroup == "Customer") {
      return Column(
        children: [
          if (_typeList.isNotEmpty)
            buildDropdown(
              "Type",
              typeDropdown,
              _typeList,
              (v) => setState(() => typeDropdown = v),
              hint: "-- Select Type --",
            ),
          if (typeDropdown?.toUpperCase() == "SCHOOL") ...[
            buildDropdown(
              "All Customer",
              selectedCustomer,
              customerList,
              (v) => setState(() => selectedCustomer = v),
              hint: "-- Select Customer --",
            ),
            buildDropdown(
              "Collected By (Cashier)",
              selectedCashier,
              cashierList,
              (v) async {
                setState(() {
                  selectedCashier = v;
                  cashierMobileController.text = '';
                });
                if (v != null && v.isNotEmpty) {
                  final response = await _authService.getAccountantMobile(v);
                  if (response != null && mounted) {
                    setState(() {
                      cashierMobileController.text = response.mobile;
                    });
                  }
                }
              },
              hint: "-- Select Cashier --",
            ),
            buildDropdown(
              "Collected Agent",
              selectedAgent,
              agentList,
              (v) async {
                setState(() {
                  selectedAgent = v;
                  cashierMobileController.text = '';
                });
                if (v != null && v.isNotEmpty) {
                  final response = await _authService.getAccountantMobile(v);
                  if (response != null && mounted) {
                    setState(() {
                      cashierMobileController.text = response.mobile;
                    });
                  }
                }
              },
              hint: "-- Select Agent --",
            ),
            buildTextField(
              "Payment Date",
              paymentDateController,
              hintText: "dd/mm/yyyy",
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
              onTap: () => _selectDate(context, paymentDateController),
            ),
          ],
          buildTextField("Amount", amountController),
          buildTextField("Cashier Mobile", cashierMobileController, readOnly: true),
          buildTextField("Remarks", remarksController),
          buildTextField(
            "Back Date",
            backDateController,
            hintText: "dd/mm/yyyy",
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
            onTap: () => _selectDate(context, backDateController),
          ),
          buildDropdown(
            "Account Name",
            accountantName,
            accountantList,
            (v) => setState(() => accountantName = v),
            hint: "-- Select Accountant --",
          ),
        ],
      );
    }

    if (accountGroup == "Assets") {
      return Column(
        children: [
          if (_typeList.isNotEmpty)
            buildDropdown(
              "Type",
              typeDropdown,
              _typeList,
              (v) => setState(() => typeDropdown = v),
              hint: "-- Select Type --",
            ),

          buildTextField("Amount", amountController),
          buildTextField("Remarks", remarksController),
          buildTextField(
            "Back Date",
            backDateController,
            hintText: "dd/mm/yyyy",
            readOnly: true,
            suffixIcon:
                const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
            onTap: () => _selectDate(context, backDateController),
          ),
          buildDropdown(
            "Account Name",
            accountantName,
            accountantList,
            (v) => setState(() => accountantName = v),
            hint: "-- Select Accountant --",
          ),
        ],
      );
    }



    if (accountGroup == "EXPENSES") {
      return Column(
        children: [
          buildTextField(
            "Select OR Type Party Name",
            partyNameController,
            readOnly: true,
          ),
          buildTextField("Bill No", billNoController, readOnly: true),
          buildTextField(
            "Expense Date",
            expenseDateController,
            hintText: "dd/mm/yyyy",
            readOnly: true,
            suffixIcon:
                const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
            onTap: () => _selectDate(context, expenseDateController),
          ),
          buildDropdown(
            "Category",
            categoryDropdown,
            expenseCategoryList,
            (v) {
              setState(() => categoryDropdown = v);
              if (v == null || v.isEmpty) {
                setState(() {
                  _subCategories = <GetFormDateCashierSubCategoryItem>[];
                  subCategoryDropdown = null;
                });
                return;
              }
              _loadSubCategories(v);
            },
            hint: "-- Select Category --",
          ),
          if (expenseCategoryList.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'No expense categories found from API.',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          buildDropdown(
            "Sub Category",
            subCategoryDropdown,
            subCategoryList,
            (v) => setState(() => subCategoryDropdown = v),
            hint: _isSubCategoryLoading
                ? "Loading sub categories..."
                : "-- Select Sub Category --",
          ),
          if (_isSubCategoryLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          buildDropdown(
            "Payment Mode",
            paymentModeDropdown,
            const ["Cash", "UPI", "BANK TRANSFER", "CHEQUE"],
            (v) => setState(() => paymentModeDropdown = v),
            hint: "-- Select Mode --",
          ),
          buildDropdown(
            "Status",
            statusDropdown,
            const ["Pending", "Paid"],
            (v) => setState(() => statusDropdown = v),
            hint: "-- Select Status --",
          ),
          buildTextField("Amount", amountController),
          buildTextField("Remarks", remarksController),
          buildTextField(
            "Back Date",
            backDateController,
            hintText: "dd/mm/yyyy",
            readOnly: true,
            suffixIcon:
                const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
            onTap: () => _selectDate(context, backDateController),
          ),
          buildDropdown(
            "Accountant Name",
            accountantName,
            accountantList,
            (v) => setState(() => accountantName = v),
            hint: "-- Select Accountant --",
          ),
        ],
      );
    }

    return Column(
      children: [
        if (_typeList.isNotEmpty)
          buildDropdown(
            "Type",
            typeDropdown,
            _typeList,
            (v) => setState(() => typeDropdown = v),
            hint: "-- Select Type --",
          ),
        buildTextField("Amount", amountController),
        buildTextField("Remarks", remarksController),
        buildTextField(
          "Back Date",
          backDateController,
          hintText: "dd/mm/yyyy",
          readOnly: true,
          suffixIcon:
              const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
          onTap: () => _selectDate(context, backDateController),
        ),
        buildDropdown(
          "Account Name",
          accountantName,
          accountantList,
          (v) => setState(() => accountantName = v),
          hint: "-- Select Accountant --",
        ),
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

  Widget buildTextField(
    String title,
    TextEditingController controller, {
    String? hintText,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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

  Widget buildDropdown(
    String title,
    String? value,
    List<String> items,
    Function(String?) onChanged, {
    String hint = "-- Select --",
    bool isHighlighted = false,
  }) {
    return buildLabelField(
      title,
      DropdownButtonFormField<String>(
        initialValue: items.contains(value) ? value : null,
        hint: Text(hint),
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: isHighlighted ? Colors.blue.shade200 : Colors.grey.shade300,
              width: isHighlighted ? 2 : 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: isHighlighted ? Colors.blue.shade200 : Colors.grey.shade300,
              width: isHighlighted ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: isHighlighted,
          fillColor: isHighlighted ? Colors.blue.withValues(alpha: 0.05) : null,
        ),
        items: items
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
