import 'package:flutter/material.dart';
import '../../Model/tracking_order_model.dart';
import '../../Service/tracking_order_service.dart';
import 'order_tracking_detail_page.dart';

class TrackingOrderListScreen extends StatefulWidget {
  const TrackingOrderListScreen({super.key});

  @override
  State<TrackingOrderListScreen> createState() =>
      _TrackingOrderListScreenState();
}

class _TrackingOrderListScreenState
    extends State<TrackingOrderListScreen> {
  late TextEditingController _searchController;
  List<TrackingOrder> _allOrders = [];
  List<TrackingOrder> _filteredOrders = [];
  bool _isLoading = true;
  String? _errorMessage;
  DateTime? _startDate;
  DateTime? _endDate;

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
      final orders = await TrackingOrderService().fetchTrackingOrders();
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

  void _applyFilters() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredOrders = _allOrders.where((order) {
        // Text Match
        final orderNoMatch = order.orderNo.toLowerCase().contains(query);
        final publicationMatch = order.publication.toLowerCase().contains(query);
        final textMatch = orderNoMatch || publicationMatch;

        // Date Match
        bool dateMatch = true;
        if (_startDate != null && _endDate != null) {
          // Normalize dates to remove time for comparison
          final orderDate = DateTime(order.date.year, order.date.month, order.date.day);
          final start = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
          final end = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
          
          dateMatch = orderDate.isAtSameMomentAs(start) || 
                      orderDate.isAtSameMomentAs(end) ||
                      (orderDate.isAfter(start) && orderDate.isBefore(end));
        }

        return textMatch && dateMatch;
      }).toList();
    });
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _applyFilters();
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _startDate = null;
      _endDate = null;
      _filteredOrders = _allOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Tracking Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
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
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => _applyFilters(),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search Order No or Publication...",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white70),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilters();
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _selectDateRange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range, color: Colors.white70, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _startDate == null
                                ? "Select Date Range"
                                : "${_startDate!.toString().split(' ')[0]} to ${_endDate!.toString().split(' ')[0]}",
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_startDate != null || _searchController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.filter_list_off, color: Colors.white70),
                    tooltip: "Clear All Filters",
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadOrders,
                child: const Text("Retry"),
              ),
            ],
          ),
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
      child: SizedBox(
        width: 800,
        child: Column(
          children: [
            // 🔹 TABLE HEADER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.grey.shade300,
              child: const Row(
                children: [
                  _HeaderCell('Sr No', flex: 1),
                  _HeaderCell('Order No', flex: 2),
                  _HeaderCell('Publication', flex: 2),
                  _HeaderCell('Date', flex: 2),
                  _HeaderCell('Action', flex: 2),
                ],
              ),
            ),

            // 🔹 TABLE BODY
            Expanded(
              child: ListView.builder(
                itemCount: _filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = _filteredOrders[index];

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        _BodyCell('${index + 1}', flex: 1),
                        _BodyCell(order.orderNo, flex: 2),
                        _BodyCell(order.publication, flex: 2),
                        _BodyCell(
                          order.date.toLocal().toString().split(' ')[0],
                          flex: 2,
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderTrackingDetailPage(
                                      senderId: order.senderId,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('View'),
                            ),
                          ),
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
}

/// 🔹 Header Cell Widget
class _HeaderCell extends StatelessWidget {
  final String title;
  final int flex;

  const _HeaderCell(this.title, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// 🔹 Body Cell Widget
class _BodyCell extends StatelessWidget {
  final String value;
  final int flex;

  const _BodyCell(this.value, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(value),
      ),
    );
  }
}
