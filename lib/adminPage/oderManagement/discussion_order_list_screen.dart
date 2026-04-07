import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/discussion_order_list_model.dart';
import '../../Service/discussion_order_service.dart';

class DiscussionOrderListScreen extends StatefulWidget {
  const DiscussionOrderListScreen({super.key});

  @override
  State<DiscussionOrderListScreen> createState() =>
      _DiscussionOrderListScreenState();
}

class _DiscussionOrderListScreenState
    extends State<DiscussionOrderListScreen> {
  late TextEditingController _searchController;
  List<DiscussionOrderListModel> _allOrders = [];
  List<DiscussionOrderListModel> _filteredOrders = [];
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
      final orders = await DiscussionOrderService().fetchOrders();
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
          final billMatch = order.billNo.toLowerCase().contains(lowercaseQuery);
          final schoolMatch = order.schoolName.toLowerCase().contains(lowercaseQuery);
          final agentMatch = (order.agentName ?? "").toLowerCase().contains(lowercaseQuery);
          final mobileMatch = order.schoolMobileNo.toLowerCase().contains(lowercaseQuery);
          return billMatch || schoolMatch || agentMatch || mobileMatch;
        }).toList();
      }
    });
  }

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B46C1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Discussion Order List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF6B46C1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterOrders,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search Bill, Party, Agent or Mobile...",
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
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
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
            Text('No orders found'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 20,
          border: TableBorder.all(color: Colors.grey.shade300),
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
          columns: const [
            DataColumn(label: Text("Sr No.")),
            DataColumn(label: Text("Old OrderDate")),
            DataColumn(label: Text("Order Date")),
            DataColumn(label: Text("SchoolType")),
            DataColumn(label: Text("Bill No")),
            DataColumn(label: Text("Party Name")),
            DataColumn(label: Text("CounterSupply")),
            DataColumn(label: Text("AgentName")),
            DataColumn(label: Text("MobileNo")),
            DataColumn(label: Text("OrderStatus")),
            DataColumn(label: Text("Bill Date")),
            DataColumn(label: Text("Action")),
          ],
          rows: List.generate(_filteredOrders.length, (index) {
            final order = _filteredOrders[index];

            return DataRow(cells: [
              DataCell(Text("${index + 1}")),
              DataCell(Text(formatDate(order.oldOrderDate))),
              DataCell(Text(formatDate(order.dates))),
              DataCell(Text(order.schoolType)),
              DataCell(Text(order.billNo)),
              DataCell(Text(order.schoolName)),
              DataCell(Text(order.counterType)),
              DataCell(Text(order.agentName ?? "-")),
              DataCell(Text(order.schoolMobileNo)),
              const DataCell(Text("Pending")), // static
              DataCell(Text(formatDate(order.recDate))),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  onPressed: () {
                    // View Action
                  },
                ),
              ),
            ]);
          }),
        ),
      ),
    );
  }
}
