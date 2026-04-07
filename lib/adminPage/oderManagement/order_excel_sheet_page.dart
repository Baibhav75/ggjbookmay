import 'package:flutter/material.dart';
import '../SellReturn/ViewBookList.dart';
import '../SellReturn/oderExcelSheet.dart';
import '/Model/order_excel_sheet_model.dart';
import '/Service/order_excel_sheet_service.dart';

class OrderExcelSheetPage extends StatefulWidget {
  const OrderExcelSheetPage({super.key});

  @override
  State<OrderExcelSheetPage> createState() => _OrderExcelSheetPageState();
}

class _OrderExcelSheetPageState extends State<OrderExcelSheetPage> {
  late TextEditingController _searchController;
  List<OrderExcelSheet> _allOrders = [];
  List<OrderExcelSheet> _filteredOrders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await OrderExcelSheetService().fetchOrderExcelSheetList();
      if (mounted) {
        setState(() {
          _allOrders = orders;
          _filteredOrders = _allOrders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _filterOrders(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOrders = _allOrders;
      } else {
        final lowercaseQuery = query.toLowerCase();
        _filteredOrders = _allOrders.where((order) {
          final schoolNameMatch = order.schoolName.toLowerCase().contains(lowercaseQuery);
          final billNoMatch = order.billNo.toLowerCase().contains(lowercaseQuery);
          return schoolNameMatch || billNoMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text(
          "Order Excel Sheet List",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterOrders,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search School or Bill No...",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () {
                    _searchController.clear();
                    _filterOrders('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white24, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text("Error: $_errorMessage"),
            ElevatedButton(
              onPressed: _loadOrders,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (_filteredOrders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("No Data Found"),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
          columnSpacing: 30,
          dataRowMinHeight: 48,
          dataRowMaxHeight: 60,
          columns: const [
            DataColumn(label: Text('Sr No')),
            DataColumn(label: Text('School Name')),
            DataColumn(label: Text('Bill No')),
            DataColumn(label: Text('Order Date')),
            DataColumn(label: Text('Rec Date')),
            DataColumn(label: Text('Action')),
          ],
          rows: List.generate(_filteredOrders.length, (index) {
            final order = _filteredOrders[index];

            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')),
                DataCell(
                  SizedBox(
                    width: 220,
                    child: Text(
                      order.schoolName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(order.billNo)),
                DataCell(Text(_formatDate(order.dates))),
                DataCell(Text(_formatDate(order.recDate))),

                // ✅ ACTION COLUMN (View Button)
                DataCell(
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'books') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewBookDetails(
                              billNo: order.billNo,
                            ),
                          ),
                        );
                      } else if (value == 'excel') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OderExcelSheet(
                              billNo: order.billNo,
                            ),
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'books',
                        child: Row(
                          children: [
                            Icon(Icons.menu_book, size: 18),
                            SizedBox(width: 8),
                            Text('View Book List'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'excel',
                        child: Row(
                          children: [
                            Icon(Icons.description, size: 18),
                            SizedBox(width: 8),
                            Text('Order Excel Sheet'),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple, // 🔵 Blue background
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ✅ Date formatter
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }
}
