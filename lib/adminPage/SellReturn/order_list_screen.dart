import 'package:flutter/material.dart';
import '../../Model/order_list_model.dart';
import '../../Service/order_list_service.dart';
import 'AllOderDetails_view_order_details.dart';
import 'ViewBookList.dart';
import 'oderExcelSheet.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late TextEditingController _searchController;
  List<OrderItem> _allOrders = [];
  List<OrderItem> _filteredOrders = [];
  bool _isLoading = true;
  String? _errorMessage;

  String? _expandedBillNo;

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
      final model = await OrderListService.fetchOrderList();
      if (mounted) {
        setState(() {
          _allOrders = model.data;
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
          final mobileMatch = order.mobileNo.toLowerCase().contains(lowercaseQuery);
          final schoolTypeMatch = order.schoolType.toLowerCase().contains(lowercaseQuery);
          final counterSupplyMatch = order.counterSupply.toLowerCase().contains(lowercaseQuery);
          final partyNameMatch = order.schoolName.toLowerCase().contains(lowercaseQuery);
          final billNoMatch = order.billNo.toLowerCase().contains(lowercaseQuery);

          return mobileMatch || schoolTypeMatch || counterSupplyMatch || partyNameMatch || billNoMatch;
        }).toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Order Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF6B46C1), // Deep purple
        iconTheme: const IconThemeData(color: Colors.white),
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
        color: const Color(0xFF6B46C1),
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
          hintText: "Search Mobile, School Type, CounterSupply...",
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
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState(_errorMessage!);
    }

    if (_filteredOrders.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  const Color(0xFFE0F7FA), // Light cyan header
                ),
                columnSpacing: 20,
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                columns: const [
                  DataColumn(label: Text('Sr No.')),
                  DataColumn(label: Text('Old OrderDate')),
                  DataColumn(label: Text('School Type')),
                  DataColumn(label: Text('Order Date')),
                  DataColumn(label: Text('Bill No')),
                  DataColumn(label: Text('Party Name')),
                  DataColumn(label: Text('CounterSupply')),
                  DataColumn(label: Text('AgentName')),
                  DataColumn(label: Text('MobileNo')),
                  DataColumn(label: Text('Bill Date')),
                  DataColumn(label: Text('Action')),
                ],
                rows: List.generate(_filteredOrders.length, (index) {
                  final order = _filteredOrders[index];
                  return DataRow(
                    cells: [
                      DataCell(Text((index + 1).toString())),
                      DataCell(Text(_cleanDate(order.oldOrderDate))),
                      DataCell(Text(order.schoolType)),
                      DataCell(Text(_cleanDate(order.orderDate))),
                      DataCell(Text(order.billNo)),
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Text(
                            order.schoolName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(Text(order.counterSupply.toUpperCase())),
                      DataCell(Text(order.agentName)),
                      DataCell(Text(order.mobileNo)),
                      DataCell(Text(_cleanDate(order.billDate))),
                      DataCell(
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'view_details') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewOrderDetails(
                                    billNo: order.billNo,
                                  ),
                                ),
                              );
                            } else if (value == 'view_books') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewBookDetails(
                                    billNo: order.billNo, // optional
                                  ),
                                ),
                              );
                            } else if (value == 'Oder ExcelSheet') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OderExcelSheet(
                                    billNo: order.billNo, // optional
                                  ),
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'view_details',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility, size: 20),
                                  SizedBox(width: 8),
                                  Text('View Details'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'view_books',
                              child: Row(
                                children: [
                                  Icon(Icons.list_alt, size: 20),
                                  SizedBox(width: 8),
                                  Text('View Book List'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'Oder ExcelSheet',
                              child: Row(
                                children: [
                                  Icon(Icons.list_alt, size: 20),
                                  SizedBox(width: 8),
                                  Text('Oder ExcelSheet'),
                                ],
                              ),
                            ),
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
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
                                    fontWeight: FontWeight.w500,
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
          ),
        ),
      ],
    );
  }

  String _cleanDate(String date) {
    if (date.isEmpty) return '';
    try {
      // If it's a full DateTime string, just take the date part
      if (date.contains('T')) {
        return date.split('T')[0];
      }
      if (date.contains(' ')) {
        return date.split(' ')[0];
      }
      return date;
    } catch (e) {
      return date;
    }
  }





  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading Orders...',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[400]),
            const SizedBox(height: 20),
            const Text(
              'Unable to Load Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _loadOrders();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 72,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            const Text(
              'No Orders Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your order history will appear here',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
