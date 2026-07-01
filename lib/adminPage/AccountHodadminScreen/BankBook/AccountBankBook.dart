import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Model/CategoryAccountGroupType.dart';
import '../../../Model/bankBook_get_child_groups_model.dart';
import '../../../Model/bank_book_form_model.dart';
import '../../../Model/add_day_book_form_data_model.dart';
import '../../../Model/sell_school_list_model.dart';
import '../../../Model/get_cashier_child_select_model.dart';
import '../../../Model/get_cashier_child_select_vendor_model.dart';
import '../../../Service/CategoryAccountGroupTypeService.dart';
import '../../../Service/add_day_book_form_data_service.dart';
import '../../../Service/sell_school_list_service.dart';
import '../../../Service/get_cashier_child_select_service.dart';
import '../../../Service/bank_book_save_service.dart';
import '../../../appDart/auth_servcie.dart';

class AccountBankBook extends StatefulWidget {
  const AccountBankBook({Key? key}) : super(key: key);

  @override
  State<AccountBankBook> createState() => _AccountBankBookState();
}

class _AccountBankBookState extends State<AccountBankBook> {
  // Common Controllers
  final TextEditingController voucherController = TextEditingController();
 
  final TextEditingController bankNameController = TextEditingController();

  final TextEditingController accountNumberController = TextEditingController();

  final TextEditingController billNoController = TextEditingController();
  final CategoryMasterService categoryService = CategoryMasterService();

  final TextEditingController ifscController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController partyNameController = TextEditingController();

  final TextEditingController expenseDateController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController backDatesController = TextEditingController();

  // Dropdown States
  String? selectedAccountName;
  String? selectedBank;
  String? selectedFromBank;
  String? selectedToBank;

  bool isBulkPayment = false;
  final TextEditingController bulkLabelController = TextEditingController();
  final TextEditingController complaintDetailsController =
      TextEditingController();
  final TextEditingController lossAmountController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  
  // Publication list fetched from GetPublications API
  String? selectedPublication;
  List<GetCashierChildSelectItem> publicationList = [];

  // Vendor list fetched from GetVendor API
  List<GetCashierChildSelectVendorItem> vendorList = [];
  
  // Schools & Amounts rows: each row has a selectedSchool name + amount controller
  List<Map<String, dynamic>> schoolAmountList = [
    {"selectedSchool": null, "amount": TextEditingController()},
  ];

  // School list from API
  List<SellSchool> schoolList = [];

  String? transactionType = 'CREDIT';
  String? selectedEmployeeName;
  String? selectedLossType;
  String? selectedSubCategory;
  String? selectedPaymentMode;
  String? selectedStatus;
  String? selectedParty;
  String? selectedInvestor;

  List<AddDayBookLookupItem> investorList = [];

  String? selectedPurchaseParty;
  String? selectedCategory;
  List<ParentGroup> parentGroupList = [];
  String? selectedParentGroup;

  /// Normalized group name for safe comparison (lowercase + trimmed) comparison
  List<dynamic> get _currentPartyList => _groupName == 'expenses' ? expensePartyList : partyList;
  String get _groupName => selectedParentGroup?.toLowerCase().trim() ?? '';

  // New state for accountants list
  List<AddDayBookLookupItem> accountantList = [];
  String? selectedAccountant;

  // Account Name dynamic list
  List<AddDayBookLookupItem> accountNameList = [];

  // All employees list
  List<AddDayBookLookupItem> employeeList = [];

  // Complaint image picked file
  XFile? _complaintImage;

  List<BankModel> bankList = [];

  List<ChildGroup> partyList = []; // Original party list for non‑expenses groups
  List<AddDayBookLookupItem> expensePartyList = []; // Expense parties for EXPENSES group



  @override
  void dispose() {
    voucherController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    branchController.dispose();
    partyNameController.dispose();
    billNoController.dispose();
    expenseDateController.dispose();
    balanceController.dispose();
    amountController.dispose();
    remarksController.dispose();
    backDatesController.dispose();
    bulkLabelController.dispose();
    complaintDetailsController.dispose();
    lossAmountController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    for (var item in schoolAmountList) {
      item['amount']?.dispose();
    }
    super.dispose();
  }

  Future<void> loadInitialData() async {
    // Bank Book API
    final bankResult = await AuthService().getBankBookFormData();

    if (bankResult != null) {
      voucherController.text = bankResult.data.autoVoucher;
      billNoController.text = bankResult.data.expNextBillNo;

      bankList = bankResult.data.banks;
    }

    // Account Group API
    final categoryResult = await categoryService.getCategoryMasterList();

    if (categoryResult != null) {
      parentGroupList = categoryResult.parentGroups;
    }

    // Fetch accountants + accountNameList + employeeList via day book service
    final dayBookResult = await AddDayBookFormDataService().fetchFormData();
    accountantList = dayBookResult.accountants;
    accountNameList = dayBookResult.accountants;
    // Populate investors list
    investorList = dayBookResult.investors;
    employeeList = dayBookResult.allEmployees;
    // Load expense parties for EXPENSES group
    expensePartyList = dayBookResult.expenseParties;

    // Fetch school list for dropdown
    try {
      final schoolResult = await SellSchoolListService.fetchSchools();
      schoolList = schoolResult.schools;
    } catch (_) {}

    // Fetch publications from GetPublications API
    try {
      final pubResult = await GetCashierChildSelectService().fetchPublications();
      publicationList = pubResult.data;
    } catch (_) {}

    // Fetch vendors from GetVendor API
    try {
      final vendorResult = await GetCashierChildSelectService().fetchVendors();
      vendorList = vendorResult.data;
    } catch (_) {}

    setState(() {});
  }

  Future<void> getBankDetails(String bankId) async {
    final result = await AuthService().getBankById(bankId);

    print("BankId : $bankId");
    print(result);

    if (result != null) {
      setState(() {
        bankNameController.text = result.data.bankName;
        accountNumberController.text = result.data.accountNumber;
        ifscController.text = result.data.ifsc;
        branchController.text = result.data.branch;
      });

      print(ifscController.text);
      print(branchController.text);
    }
  }

  Future<void> loadPartyList(String parentId) async {
    final result = await AuthService().getChildGroups(parentId);

    if (result != null) {
      setState(() {
        partyList = result.data;
        selectedParty = null;
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
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _complaintImage = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Bank Book"),
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
                buildTextField("Voucher No", voucherController, readOnly: true),
                buildDropdown(
                  "Select Bank",
                  selectedBank,
                  bankList.map((e) => e.bankName).toList(),
                  (v) async {
                    if (v == null) return;

                    setState(() {
                      selectedBank = v;
                    });

                    final bank = bankList.firstWhere((e) => e.bankName == v);

                    // Fill from first API
                    bankNameController.text = bank.bankName;
                    accountNumberController.text = bank.accountNumber;

                    // Hit GetBankById API
                    await getBankDetails(bank.bankId);

                    // Fetch Balance
                    final balanceResult = await AuthService().getBankBalance(
                      bank.bankId,
                    );
                    if (balanceResult != null) {
                      setState(() {
                        balanceController.text = balanceResult.balance
                            .toString();
                      });
                    } else {
                      setState(() {
                        balanceController.text = "0.0";
                      });
                    }
                  },
                  hint: "-- Select Bank --",
                ),

                buildTextField("Bank Name", bankNameController, readOnly: true),

                buildTextField(
                  "Account Number",
                  accountNumberController,
                  readOnly: true,
                ),

                buildTextField("IFSC", ifscController, readOnly: true),

                buildTextField("Branch", branchController, readOnly: true),
                buildDropdown(
                  "Transaction Type",
                  transactionType,
                  ['CREDIT', 'DEBIT'],
                  (v) => setState(() => transactionType = v),
                  hint: "-- Select Type --",
                ),
                if (transactionType == 'DEBIT')
                  buildTextField("Current Balance", balanceController, readOnly: true,  textColor: Colors.red,),
                buildDropdown(
                  "Account Group",
                  selectedParentGroup,
                  parentGroupList.map((e) => e.name).toList(),
                  (v) async {
                    if (v == null) return;

                    setState(() {
                      selectedParentGroup = v;
                      selectedParty = null;
                      partyList.clear();
                      selectedAccountName = null;
                      selectedFromBank = null;
                      selectedToBank = null;
                      isBulkPayment = false;
                      selectedEmployeeName = null;
                      selectedLossType = null;
                      selectedSubCategory = null;
                      selectedPaymentMode = null;
                      selectedStatus = null;
                    });

                    final parent = parentGroupList.firstWhere(
                      (e) => e.name == v,
                    );

                    print("=========== Parent Group ===========");
                    print("Name : ${parent.name}");
                    print("Id   : ${parent.id}");
                    print("===================================");

                    final result = await AuthService().getChildGroups(
                      parent.id,
                    );

                    if (result != null && result.status) {
                      setState(() {
                        partyList = result.data;
                      });
                    }
                  },
                  hint: "-- Select Account Group --",
                ),
                buildDropdown(
                  "Party Name",
                  selectedParty,
                  _currentPartyList.map<String>((e) => e.name).toList(),
                  (v) {
                    setState(() {
                      selectedParty = v;
                      selectedPurchaseParty = null; // reset when party changes
                    });
                  },
                  hint: "-- Select Party --",
                ),
                if (_groupName == 'assets') ...[
                  buildTextField("Amount", amountController),
                  buildTextField("Remarks", remarksController),
                  buildTextField(
                    "BackDates",
                    backDatesController,
                    hintText: "dd/mm/yyyy",
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.black54,
                    ),
                    onTap: () => _selectDate(context, backDatesController),
                  ),
                  buildDropdown(
                    "Account Name",
                    selectedAccountName,
                    accountNameList.map((e) => e.name).toList(),
                    (v) => setState(() => selectedAccountName = v),
                    hint: "-- Select Account Name --",
                  ),
                ] else if (_groupName == 'contra') ...[
                  buildDropdown(
                    "From Bank",
                    selectedFromBank,
                    bankList.map((e) => e.bankName).toList(),
                    (v) => setState(() => selectedFromBank = v),
                    hint: "-- Select From Bank --",
                  ),
                  buildDropdown(
                    "To Bank",
                    selectedToBank,
                    bankList.map((e) => e.bankName).toList(),
                    (v) => setState(() => selectedToBank = v),
                    hint: "-- Select To Bank --",
                  ),
                  buildTextField("Amount", amountController),
                  buildTextField("Remarks", remarksController),
                  buildTextField(
                    "BackDates",
                    backDatesController,
                    hintText: "dd/mm/yyyy",
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.black54,
                    ),
                    onTap: () => _selectDate(context, backDatesController),
                  ),
                  buildDropdown(
                    "Account Name",
                    selectedAccountName,
                    accountNameList.map((e) => e.name).toList(),
                    (v) => setState(() => selectedAccountName = v),
                    hint: "-- Select Account Name --",
                  ),
                ] else if (_groupName == 'customer') ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 140,
                          child: Text(
                            "Bulk Payment?",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Checkbox(
                          value: isBulkPayment,
                          onChanged: (v) {
                            setState(() {
                              isBulkPayment = v ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "Check karo agar multiple schools ka combined payment hai",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isBulkPayment) ...[
                    buildTextField(
                      "Bulk Label (List mein dikhega)",
                      bulkLabelController,
                      hintText: "e.g. Paytm Collection, Monthly Fee...",
                    ),
                    buildSchoolsAndAmountsTable(),
                  ],
                  buildTextField("Amount", amountController),
                  buildTextField("Remarks", remarksController),
                  buildTextField(
                    "BackDates",
                    backDatesController,
                    hintText: "dd/mm/yyyy",
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.black54,
                    ),
                    onTap: () => _selectDate(context, backDatesController),
                  ),
                  buildDropdown(
                    "Account Name",
                    selectedAccountName,
                    accountNameList.map((e) => e.name).toList(),
                    (v) => setState(() => selectedAccountName = v),
                    hint: "-- Select Account Name --",
                  ),
                ] else if (_groupName == 'purchase party') ...[
                  // Hide Bulk Payment when Party Name = VENDOR
                  if (selectedParty?.toUpperCase() != 'VENDOR') ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 140,
                            child: Text(
                              "Bulk Payment?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Checkbox(
                            value: isBulkPayment,
                            onChanged: (v) {
                              setState(() {
                                isBulkPayment = v ?? false;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              "Check karo agar multiple schools ka combined payment hai",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isBulkPayment) ...[
                      buildTextField(
                        "Bulk Label (List mein dikhega)",
                        bulkLabelController,
                        hintText: "e.g. Paytm Collection, Monthly Fee...",
                      ),
                      buildSchoolsAndAmountsTable(),
                    ],
                  ],

                  // Select Purchase Party dropdown:
                  // PUBLICATION → publications from API
                  // VENDOR      → vendors from API
                  // otherwise   → child groups from partyList
                  buildDropdown(
                    "Select Purchase Party",
                    selectedPurchaseParty,
                    selectedParty?.toUpperCase() == 'PUBLICATION'
                        ? publicationList.map<String>((e) => e.name).toList()
                        : selectedParty?.toUpperCase() == 'VENDOR'
                            ? vendorList.map<String>((e) => e.name).toList()
                            : partyList.map<String>((e) => e.name).toList(),
                    (v) => setState(() => selectedPurchaseParty = v),
                    hint: "-- Select Purchase Party --",
                  ),
                  buildTextField("Amount", amountController),
                  buildTextField("Remarks", remarksController),
                  buildTextField(
                    "BackDates",
                    backDatesController,
                    hintText: "dd/mm/yyyy",
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.black54,
                    ),
                    onTap: () => _selectDate(context, backDatesController),
                  ),
                  buildDropdown(
                    "Account Name",
                    selectedAccountName,
                    accountNameList.map((e) => e.name).toList(),
                    (v) => setState(() => selectedAccountName = v),
                    hint: "-- Select Account Name --",
                  ),
                ] else if (_groupName == 'investor') ...[
                  buildDropdown(
                    "Select Investor",
                    selectedInvestor,
                    investorList.map((e) => e.name).toList(),
                    (v) {
                      setState(() {
                        selectedInvestor = v;
                      });
                    },
                    hint: "-- Select Investor --",
                  ),

                  buildTextField("Amount", amountController),

                  buildTextField("Remarks", remarksController, maxLines: 3),

                  buildTextField(
                    "BackDates",
                    backDatesController,
                    hintText: "dd/mm/yyyy",
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      size: 18,
),
                    onTap: () => _selectDate(context, backDatesController),
                  ),
                  buildDropdown(
                    "Category",
                    selectedAccountant,
                    accountantList.map((e) => e.name).toList(),
                    (v) => setState(() => selectedAccountant = v),
                    hint: "-- Select Category --",
                  ),
                ] else if (_groupName == 'employee') ...[
                  if (selectedParty?.toUpperCase() == 'COMPLAINT LOSS') ...[
                    buildTextField(
                      "Complaint Details",
                      complaintDetailsController,
                      hintText: "Complaint likho...",
                      maxLines: 3,
                    ),
                    buildDropdown(
                      "Loss Type",
                      selectedLossType,
                      ['Loss Hua Hai', 'No Loss'], // Dummy data
                      (v) => setState(() => selectedLossType = v),
                      hint: "-- Select Loss Type --",
                    ),
                    if (selectedLossType != 'No Loss')
                      buildTextField(
                        "Loss Amount (₹)",
                        lossAmountController,
                        hintText: "0.00",
                      ),
                    buildLabelField(
                      "Complaint Image",
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.upload_file, size: 16),
                                label: const Text("Choose File"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  foregroundColor: Colors.black87,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _complaintImage != null
                                      ? _complaintImage!.name
                                      : "No file chosen",
                                  style: TextStyle(
                                    color: _complaintImage != null
                                        ? Colors.green.shade700
                                        : Colors.black87,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (_complaintImage != null)
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      size: 18, color: Colors.red),
                                  tooltip: "Remove image",
                                  onPressed: () {
                                    setState(() => _complaintImage = null);
                                  },
                                ),
                            ],
                          ),
                          if (_complaintImage != null) ...[
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                File(_complaintImage!.path),
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ] else ...[
                    buildDropdown(
                      "Select Employee",
                      selectedEmployeeName,
                      employeeList.map((e) => e.name).toList(),
                      (v) => setState(() => selectedEmployeeName = v),
                      hint: "-- Select Employee --",
                    ),
                    buildTextField("Amount", amountController),
                  ],
                  buildTextField("Remarks", remarksController),
                  buildTextField(
                    "BackDates",
                    backDatesController,
                    hintText: "dd/mm/yyyy",
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.black54,
                    ),
                    onTap: () => _selectDate(context, backDatesController),
                  ),
                  buildDropdown(
                    "Account Name",
                    selectedAccountName,
                    accountNameList.map((e) => e.name).toList(),
                    (v) => setState(() => selectedAccountName = v),
                    hint: "-- Select Account Name --",
                  ),
                ] else if (_groupName == 'expenses') ...[
                  buildTextField("Mobile", mobileController),
                  buildTextField("Email", emailController),
                  buildTextField("Address", addressController, maxLines: 2),
                  buildTextField("Bill No", billNoController),
                  buildTextField(
                    "Expense Date",
                    expenseDateController,
                    hintText: "dd/mm/yyyy",
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.black54,
                    ),
                    onTap: () => _selectDate(context, expenseDateController),
                  ),
                  buildDropdown(
                    "Category",
                    selectedAccountant,
                    accountantList.map((e) => e.name).toList(),
                    (v) => setState(() => selectedAccountant = v),
                    hint: "-- Select Accountant --",
                  ),
                  buildDropdown(
                    "Sub Category",
                    selectedSubCategory,
                    ['Sub Category 1', 'Sub Category 2'], // Dummy data
                    (v) => setState(() => selectedSubCategory = v),
                    hint: "-- Select Sub Category --",
                  ),
                  buildDropdown(
                    "Payment Mode",
                    selectedPaymentMode,
                    ['Cash', 'Card', 'Online'], // Dummy data
                    (v) => setState(() => selectedPaymentMode = v),
                    hint: "-- Select Payment Mode --",
                  ),
                  buildDropdown(
                    "Status",
                    selectedStatus,
                    ['Paid', 'Unpaid', 'Pending'], // Dummy data
                    (v) => setState(() => selectedStatus = v),
                    hint: "-- Select Status --",
                  ),
                  buildTextField("Amount", amountController),
                  buildTextField("Remarks", remarksController),
                  buildDropdown(
                    "Account Name",
                    selectedAccountName,
                    accountNameList.map((e) => e.name).toList(),
                    (v) => setState(() => selectedAccountName = v),
                    hint: "-- Select Account Name --",
                  ),
                ],
                if (_groupName != 'assets' &&
                    _groupName != 'contra' &&
                    _groupName != 'customer' &&
                    _groupName != 'purchase party' &&
                    _groupName != 'employee' &&
                    _groupName != 'investor' &&
                    _groupName != 'expenses') ...[

                  buildTextField(
                    "Amount",
                    amountController,
                  ),
                  buildTextField(
                    "Remarks",
                    remarksController,
                    maxLines: 3,
                  ),

                  buildTextField(
                    "BackDates",
                    backDatesController,
                    hintText: "dd/mm/yyyy",
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.black54,
                    ),
                    onTap: () => _selectDate(context, backDatesController),
                  ),
                  buildDropdown(
                    "Category",
                    selectedCategory,
                    ['Category A', 'Category B'], // Dummy data
                    (v) => setState(() => selectedCategory = v),
                    hint: "-- Select Category --",
                  ),
                ],

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate required fields
                      if (selectedBank == null || selectedBank!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a bank')),
                        );
                        return;
                      }
                      String finalAmount = amountController.text.trim();
                      if (_groupName == 'employee' && selectedParty?.toUpperCase() == 'COMPLAINT LOSS') {
                        finalAmount = lossAmountController.text.trim();
                        if (finalAmount.isEmpty && selectedLossType != 'No Loss') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter loss amount')),
                          );
                          return;
                        }
                      } else {
                        if (finalAmount.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter amount')),
                          );
                          return;
                        }
                      }

                      // Resolve BankId from selected bank name
                      final bank = bankList.firstWhere(
                        (e) => e.bankName == selectedBank,
                      );

                      // Resolve EmployeeId from selected employee name
                      String employeeId = '';
                      if (selectedEmployeeName != null) {
                        final emp = employeeList.firstWhere(
                          (e) => e.name == selectedEmployeeName,
                          orElse: () => AddDayBookLookupItem(id: '', name: ''),
                        );
                        employeeId = emp.id;
                      }

                      // Resolve CreatedBy / CreatorName from selected account name
                      String createdBy = '';
                      String creatorName = '';
                      if (selectedAccountName != null) {
                        final acc = accountNameList.firstWhere(
                          (e) => e.name == selectedAccountName,
                          orElse: () => AddDayBookLookupItem(id: '', name: ''),
                        );
                        createdBy = acc.id;
                        creatorName = acc.name;
                      }

                      String finalDescription = remarksController.text.trim();
                      if (_groupName == 'employee' && selectedParty?.toUpperCase() == 'COMPLAINT LOSS') {
                        finalDescription = complaintDetailsController.text.trim();
                      }

                      // Call Save API
                      final result = await BankBookSaveService().saveEmployeeBankBook(
                        bankId: bank.bankId,
                        transactionType: transactionType ?? '',
                        amount: finalAmount,
                        type: selectedParty ?? '',
                        employeeId: employeeId,
                        description: finalDescription,
                        createdBy: createdBy,
                        creatorName: creatorName,
                        paymentDate: backDatesController.text.trim(),
                        voucherNo: voucherController.text.trim(),
                        toPayment: selectedEmployeeName,
                        complaintImagePath: _complaintImage?.path,
                      );

                      if (result != null && result.status) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message.isNotEmpty
                                ? result.message
                                : 'Saved successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Reload data to get fresh voucher number
                        loadInitialData();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result?.message ?? 'Failed to save'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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
      ),
    );
  }

  Widget buildSchoolsAndAmountsTable() {
    double totalAmount = 0.0;
    for (var item in schoolAmountList) {
      double amt = double.tryParse(item['amount']!.text) ?? 0.0;
      totalAmount += amt;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 140,
            child: Text(
              "Schools & Amounts",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey.shade100,
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 3,
                              child: Text(
                                "School",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                "Amount",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                     setState(() {
                                       schoolAmountList.add({
                                         "selectedSchool": null,
                                         "amount": TextEditingController(),
                                       });
                                     });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Rows
                      ...schoolAmountList.asMap().entries.map((entry) {
                        int index = entry.key;
                        var item = entry.value;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: DropdownButtonFormField<String>(
                                  value: item['selectedSchool'] as String?,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    hintText: "Select School",
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 10,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: schoolList.map((s) {
                                    return DropdownMenuItem<String>(
                                      value: s.schoolName,
                                      child: Text(
                                        s.schoolName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      item['selectedSchool'] = val;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: item['amount'],
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) => setState(() {}),
                                  decoration: const InputDecoration(
                                    hintText: "Amount",
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 10,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: Center(
                                  child: schoolAmountList.length > 1
                                      ? InkWell(
                                          onTap: () {
                                             setState(() {
                                               item['amount']?.dispose();
                                               schoolAmountList.removeAt(index);
                                             });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Total: ₹${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
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
              style: const TextStyle(fontSize: 14, color: Colors.black87),
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
    int maxLines = 1,
        Color textColor = Colors.black87,
  }) {
    return buildLabelField(
      title,
      TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: isHighlighted
                  ? Colors.blue.shade200
                  : Colors.grey.shade300,
              width: isHighlighted ? 2 : 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: isHighlighted
                  ? Colors.blue.shade200
                  : Colors.grey.shade300,
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
