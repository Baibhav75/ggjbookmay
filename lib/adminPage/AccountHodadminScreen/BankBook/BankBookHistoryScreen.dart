import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Model/transaction_history_model.dart';
import '../../../../Service/transaction_history_service.dart';

class BankBookHistoryScreen extends StatefulWidget {
  const BankBookHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BankBookHistoryScreen> createState() => _BankBookHistoryScreenState();
}

class _BankBookHistoryScreenState extends State<BankBookHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  
  String selectedType = 'All Types';
  
  TransactionHistoryResponse? _historyResponse;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty || dateStr == '-') return null;
    try {
      final dateOnly = dateStr.split(' ')[0];
      final parts = dateOnly.contains('-') ? dateOnly.split('-') : dateOnly.split('/');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // ignore
    }
    return null;
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final response = await TransactionHistoryService.fetchTransactionHistory();
    setState(() {
      _historyResponse = response;
      _isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Bank Book History'),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildSummaryCards(),
                  _buildFilters(),
                ],
              ),
            ),
          ];
        },
        body: _buildTransactionList(),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final summary = _historyResponse?.summary;
    final String totalTx = summary?.totalTransaction.toStringAsFixed(2) ?? "0.00";
    final String netBal = summary?.netBalance.toStringAsFixed(2) ?? "0.00";
    final String openBal = summary?.openingBalance.toStringAsFixed(2) ?? "0.00";

    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildInfoCard("Total Transaction", "₹$totalTx", Colors.blue.shade50, Colors.blue.shade800),
            const SizedBox(width: 8),
            _buildInfoCard("Net Balance", "₹$netBal", Colors.red.shade50, Colors.red.shade800),
            const SizedBox(width: 8),
            _buildInfoCard("Opening Balance", "₹$openBal", Colors.orange.shade50, Colors.orange.shade800),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bgColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    isDense: true,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text("Export Excel"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _fromDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "From Date",
                    isDense: true,
                    suffixIcon: const Icon(Icons.calendar_today, size: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onTap: () => _selectDate(context, _fromDateController),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("to", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              Expanded(
                child: TextField(
                  controller: _toDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "To Date",
                    isDense: true,
                    suffixIcon: const Icon(Icons.calendar_today, size: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onTap: () => _selectDate(context, _toDateController),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent.shade100),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedType,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blueAccent),
                    items: ['All Types', 'SALARY', 'EXPENSES', 'VENDOR'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => selectedType = v);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    var list = _historyResponse?.data ?? [];
    
    if (list.isNotEmpty) {
      if (_searchController.text.isNotEmpty) {
        final q = _searchController.text.toLowerCase();
        list = list.where((tx) =>
            tx.id.toString().contains(q) ||
            tx.bankName.toLowerCase().contains(q) ||
            tx.description.toLowerCase().contains(q) ||
            tx.toPayment.toLowerCase().contains(q) ||
            tx.createdBy.toLowerCase().contains(q)
        ).toList();
      }

      if (selectedType != 'All Types') {
        list = list.where((tx) => tx.type.toUpperCase() == selectedType.toUpperCase()).toList();
      }

      if (_fromDateController.text.isNotEmpty) {
        try {
          final fromDate = DateFormat('dd/MM/yyyy').parse(_fromDateController.text);
          list = list.where((tx) {
            final txDate = _parseDate(tx.transactionDate);
            if (txDate == null) return true;
            return !txDate.isBefore(fromDate);
          }).toList();
        } catch (_) {}
      }

      if (_toDateController.text.isNotEmpty) {
        try {
          final toDate = DateFormat('dd/MM/yyyy').parse(_toDateController.text);
          list = list.where((tx) {
            final txDate = _parseDate(tx.transactionDate);
            if (txDate == null) return true;
            return !txDate.isAfter(toDate);
          }).toList();
        } catch (_) {}
      }
    }

    if (list.isEmpty) {
      return const Center(child: Text("No transactions found.", style: TextStyle(color: Colors.grey)));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1690,
        child: Column(
          children: [
            Container(
              color: Colors.cyan.shade100,
              child: Row(
                children: [
                  _buildHeaderCell('Sr No.', 60),
                  _buildHeaderCell('ID', 80),
                  _buildHeaderCell('Bank', 200),
                  _buildHeaderCell('Type', 100),
                  _buildHeaderCell('Topayment', 150),
                  _buildHeaderCell('Description', 200),
                  _buildHeaderCell('Opening Balance', 120),
                  _buildHeaderCell('Debit', 100),
                  _buildHeaderCell('Credit', 100),
                  _buildHeaderCell('Balance', 120),
                  _buildHeaderCell('CreatedBy', 100),
                  _buildHeaderCell('Bank Date', 120),
                  _buildHeaderCell('Entry Date', 120),
                  _buildHeaderCell('Action', 120),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final tx = list[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Row(
                      children: [
                        _buildDataCell(Text('${index + 1}'), 60),
                        _buildDataCell(Text('${tx.id}'), 80),
                        _buildDataCell(Text(tx.bankName, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), 200),
                        _buildDataCell(Text(tx.type, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)), 100),
                        _buildDataCell(Text(tx.toPayment), 150),
                        _buildDataCell(Text(tx.description), 200),
                        _buildDataCell(const Text('-'), 120),
                        _buildDataCell(Text(tx.withdrawal == 0 ? '-' : tx.withdrawal.toStringAsFixed(2), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), 100),
                        _buildDataCell(Text(tx.deposit == 0 ? '-' : tx.deposit.toStringAsFixed(2), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)), 100),
                        _buildDataCell(Text(tx.amount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)), 120),
                        _buildDataCell(Text(tx.createdBy), 100),
                        _buildDataCell(Text(tx.transactionDate), 120),
                        _buildDataCell(Text(tx.transactionDate), 120),
                        _buildDataCell(
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            child: const Text('Action ▾'),
                          ),
                          120,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
