import 'package:flutter/material.dart';
import '../../Model/individual_order_model.dart';
import '../../Service/individual_order_service.dart';
import 'IndividualOrderDetailScreen.dart';

class IndividualOrderListScreen extends StatefulWidget {
  const IndividualOrderListScreen({super.key});

  @override
  State<IndividualOrderListScreen> createState() =>
      _IndividualOrderListScreenState();
}

class _IndividualOrderListScreenState
    extends State<IndividualOrderListScreen> {
  late TextEditingController _searchController;
  List<IndividualOrder> _allOrders = [];
  List<IndividualOrder> _filteredOrders = [];
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
      final orders = await IndividualOrderService().fetchIndividualOrders();
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
          final senderMatch = order.senderId.toLowerCase().contains(lowercaseQuery);
          final publicationMatch = order.publication.toLowerCase().contains(lowercaseQuery);
          return senderMatch || publicationMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Individual Orders List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // back arrow color
        ),
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
          hintText: "Search Sender ID or Publication...",
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
        width: 800, // Minimum width to ensure columns have space
        child: Column(
          children: [
            // 🔹 HEADER ROW
            Container(
              color: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Row(
                children: [
                  _HeaderCell('Sr No', flex: 1),
                  _HeaderCell('Sender ID', flex: 2),
                  _HeaderCell('Publication', flex: 3),
                  _HeaderCell('Date', flex: 2),
                  _HeaderCell('Action', flex: 2),
                ],
              ),
            ),

            // 🔹 DATA ROWS
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
                        _BodyCell(order.senderId, flex: 2),
                        _BodyCell(order.publication, flex: 3),
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
                                    builder: (context) => IndividualOrderDetailScreen(
                                      senderId: order.senderId, // 🔥 PASSING SENDER ID
                                    ),
                                  ),
                                );
                              },
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

/// 🔹 Header Cell
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

/// 🔹 Body Cell
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


