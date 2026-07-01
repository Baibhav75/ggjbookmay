import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/CashierViewCashBookHistory_model.dart';
import '../Service/CashierViewCashBookHistory_service.dart';

class CashierViewCashBookHistoryScreen extends StatefulWidget {
  const CashierViewCashBookHistoryScreen({super.key});

  @override
  State<CashierViewCashBookHistoryScreen> createState() =>
      _CashierViewCashBookHistoryScreenState();
}

class _CashierViewCashBookHistoryScreenState
    extends State<CashierViewCashBookHistoryScreen> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String> _errorMessage = ValueNotifier<String>('');

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  CashierViewCashBookHistoryResponse? _transactionResponse;

  // Ledger Column Widths
  static const double _colSrWidth = 50.0;
  static const double _colDateWidth = 100.0;
  static const double _colMobileWidth = 110.0;
  static const double _colParticularWidth = 220.0;
  static const double _colAmountWidth = 110.0;
  static const double _colTotalBalWidth = 130.0;
  static const double _colRemarksWidth = 200.0;
  static const double _colExpNoWidth = 100.0;
  static const double _colRecNoWidth = 100.0;
  static const double _colImgWidth = 60.0;
  static const double _colUserWidth = 100.0;
  static const double _colActionWidth = 130.0;

  double get _totalTableWidth =>
      _colSrWidth + _colDateWidth + _colMobileWidth + _colParticularWidth +
      (_colAmountWidth * 2) + _colTotalBalWidth + _colRemarksWidth +
      _colExpNoWidth + _colRecNoWidth + _colImgWidth + _colUserWidth +
      _colActionWidth;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    _isLoading.dispose();
    _errorMessage.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    if (mounted) {
      _isLoading.value = true;
      _errorMessage.value = '';
    }

    try {
      final response = await CashierViewCashBookHistoryService.fetchCashBook();

      if (mounted) {
        if (response != null && response.data.isNotEmpty) {
          response.data.sort((a, b) {
            try {
              DateTime dateA = DateTime.parse(a.date);
              DateTime dateB = DateTime.parse(b.date);
              return dateB.compareTo(dateA); // Descending order
            } catch (e) {
              return b.date.compareTo(a.date);
            }
          });
        }
        
        setState(() {
          _transactionResponse = response;
        });
      }
    } catch (e) {
      if (mounted) {
        _errorMessage.value = e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: \${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        _isLoading.value = false;
      }
    }
  }

  String _formatDate(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '-';
    try {
      final dt = DateTime.parse(dateTimeStr);
      return DateFormat('dd-MMM-yyyy').format(dt);
    } catch (e) {
      return dateTimeStr;
    }
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '-';
    try {
      final dt = DateTime.parse(dateTimeStr);
      return DateFormat('dd-MMM-yyyy HH:mm').format(dt);
    } catch (e) {
      return dateTimeStr;
    }
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Cashier View Cash Book History'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (context, isLoading, child) {
              return isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _loadTransactions,
                      tooltip: 'Refresh',
                    );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ValueListenableBuilder<String>(
            valueListenable: _errorMessage,
            builder: (context, errorMessage, child) {
              if (errorMessage.isEmpty) return const SizedBox();
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.red[100],
                child: Text(errorMessage, style: TextStyle(color: Colors.red[900])),
              );
            },
          ),
          
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  hintText: "Search by name, voucher, mobile or remarks...",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Scrollbar(
      controller: _horizontalScrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalScrollController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: _totalTableWidth + 2.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTableHeader(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadTransactions,
                  child: Scrollbar(
                    controller: _verticalScrollController,
                    child: ListView(
                      controller: _verticalScrollController,
                      padding: EdgeInsets.zero,
                      children: [_buildTableBody()],
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

  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC8E6C9), // Light green table header like image
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Sr No', _colSrWidth),
          _buildHeaderCell('DateTime', _colDateWidth),
          _buildHeaderCell('Mobile No', _colMobileWidth),
          _buildHeaderCell('ParticularName', _colParticularWidth),
          _buildHeaderCell('Debit', _colAmountWidth),
          _buildHeaderCell('Credit', _colAmountWidth),
          _buildHeaderCell('Total Balance', _colTotalBalWidth),
          _buildHeaderCell('Remarks', _colRemarksWidth),
          _buildHeaderCell('ExpensBouNo', _colExpNoWidth),
          _buildHeaderCell('ReciptBouNo', _colRecNoWidth),
          _buildHeaderCell('Image', _colImgWidth),
          _buildHeaderCell('CreatedBy', _colUserWidth),
          _buildHeaderCell('Action', _colActionWidth),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[400]!)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableBody() {
    if (_transactionResponse == null || _transactionResponse!.data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text("No Data Available")),
      );
    }

    List<Widget> rows = [];
    int globalSrNo = 1;

    for (var dayData in _transactionResponse!.data) {

      int srNo = 1;
      var filteredTxs = dayData.transactions.where((tx) {
        if (_searchQuery.isEmpty) return true;
        final q = _searchQuery.toLowerCase();
        return (tx.particularName?.toLowerCase().contains(q) ?? false) ||
               (tx.mobileNo?.toLowerCase().contains(q) ?? false) ||
               (tx.remarks?.toLowerCase().contains(q) ?? false) ||
               (tx.remark?.toLowerCase().contains(q) ?? false) ||
               (tx.voucherNo?.toLowerCase().contains(q) ?? false) ||
               (tx.expenseBowcherNo?.toLowerCase().contains(q) ?? false) ||
               (tx.receiptBowcherNo?.toLowerCase().contains(q) ?? false);
      }).toList();


      rows.add(_buildDateGroupRow(dayData));

      for (var tx in filteredTxs) {
        rows.add(_buildDataRow(srNo++, tx));
      }

      rows.add(_buildDaySummaryRows(dayData));
    }

    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text("No matching records found")),
      );
    }

    return Column(children: rows);
  }

  Widget _buildDateGroupRow(CashBookDayData dayData) {
    return Container(
      width: _totalTableWidth + 2.0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD0E6F8), // Subtle blue background
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today, size: 14, color: Colors.brown),
          const SizedBox(width: 8),
          Text(
            'Date: ${_formatDate(dayData.date)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(width: 30),
          const Icon(Icons.account_balance_wallet, size: 14, color: Colors.orange),
          const SizedBox(width: 8),
          Text(
            'Opening Balance: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green[800]),
          ),
          Text(
            _formatCurrency(dayData.openingBalance),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(int srNo, CashBookTransaction tx) {
    bool isCredit = tx.flag?.toLowerCase() == 'credit';
    bool isDebit = tx.flag?.toLowerCase() == 'debit';
    
    // In JSON, credit often shows in the amount field if Flag is "Credit"
    double debitAmt = isDebit ? tx.amount : 0.0;
    double creditAmt = isCredit ? tx.amount : 0.0;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
          left: BorderSide(color: Colors.grey[400]!),
          right: BorderSide(color: Colors.grey[400]!),
        ),
      ),
      child: Row(
        children: [
          _buildCell('$srNo', _colSrWidth, align: TextAlign.center),
          _buildCell(_formatDateTime(tx.createdatetime), _colDateWidth, align: TextAlign.center),
          _buildCell(tx.mobileNo ?? '', _colMobileWidth, align: TextAlign.center, textColor: Colors.blue[800]),
          _buildCell(tx.particularName ?? '', _colParticularWidth, textColor: Colors.blue[600]),
          _buildCell(debitAmt > 0 ? _formatCurrency(debitAmt) : '', _colAmountWidth, align: TextAlign.right, textColor: Colors.red[700], isBold: true),
          _buildCell(creditAmt > 0 ? _formatCurrency(creditAmt) : '', _colAmountWidth, align: TextAlign.right, textColor: Colors.green[700], isBold: true),
          _buildCell(_formatCurrency(tx.totalBalance ?? 0), _colTotalBalWidth, align: TextAlign.right, isBold: true),
          _buildCell(tx.remarks ?? tx.remark ?? '', _colRemarksWidth),
          _buildCell(tx.expenseBowcherNo ?? '', _colExpNoWidth, align: TextAlign.center),
          _buildCell(tx.receiptBowcherNo ?? 'no', _colRecNoWidth, align: TextAlign.center),
          _buildCell(tx.image == null || tx.image!.isEmpty ? 'No' : 'Yes', _colImgWidth, align: TextAlign.center, textColor: Colors.red),
          _buildCell(tx.createdBy ?? 'test', _colUserWidth, align: TextAlign.center),
          _buildActionCell(tx),
        ],
      ),
    );
  }

  Widget _buildDaySummaryRows(CashBookDayData dayData) {
    final spacerWidth = _colSrWidth + _colDateWidth + _colMobileWidth + _colParticularWidth;
    final totalRowSuffixWidth = _totalTableWidth - (spacerWidth + _colAmountWidth * 2);
    final finalBalSpacerWidth = spacerWidth + _colAmountWidth * 2;
    final finalBalSuffixWidth = _totalTableWidth - (finalBalSpacerWidth + _colTotalBalWidth);

    return Column(
      children: [
        _buildSummaryRow('Total (for ${_formatDate(dayData.date)})', spacerWidth, [
          _buildCell(_formatCurrency(dayData.totalDebit), _colAmountWidth, align: TextAlign.right, isBold: true),
          _buildCell(_formatCurrency(dayData.totalCredit), _colAmountWidth, align: TextAlign.right, isBold: true),
          Container(width: totalRowSuffixWidth),
        ], color: Colors.grey[300]),
        _buildSummaryRow('Final Balance (Carry Forward)', finalBalSpacerWidth, [
          _buildCell(_formatCurrency(dayData.nextDayFinalBalance), _colTotalBalWidth, align: TextAlign.right, isBold: true),
          Container(width: finalBalSuffixWidth),
        ], color: const Color(0xFFFFF3E0)),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double labelWidth, List<Widget> suffix, {Color? color}) {
    return Container(
      width: _totalTableWidth + 2.0,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: const Color(0xFFBDBDBD)),
      ),
      child: Row(
        children: [
          Container(
            width: labelWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            alignment: Alignment.centerRight,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          ...suffix,
        ],
      ),
    );
  }

  Widget _buildCell(String text, double width, {TextAlign align = TextAlign.start, bool isBold = false, Color? textColor}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey[300]!))),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: textColor),
        textAlign: align,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionCell(CashBookTransaction tx) {
    return Container(
      width: _colActionWidth,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          // Add action if needed
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: "view",
            child: Text("View Details"),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green, // Action button is green in image
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Actions",
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
