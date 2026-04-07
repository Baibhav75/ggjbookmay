import 'package:flutter/material.dart';
import '../../Model/publication_order_management_model.dart';
import '../../Service/publication_order_management_service.dart';
import '/adminPage/oderManagement/publication_ledger_page.dart';

class PublicationOrderManagementPage extends StatefulWidget {
  const PublicationOrderManagementPage({super.key});

  @override
  State<PublicationOrderManagementPage> createState() =>
      _PublicationOrderManagementPageState();
}

class _PublicationOrderManagementPageState
    extends State<PublicationOrderManagementPage> {
  late Future<PublicationOrderManagementResponse> futureData;

  List<PublicationOrderRecord> _allRecords = [];
  List<PublicationOrderRecord> _filteredRecords = [];
  late TextEditingController _searchController;
  String _selectedBrand = 'ALL';
  final List<String> _brandOptions = [
    'ALL',
    'BRAND',
    'SUPER BRAND',
    'SEMI BRAND',
    'SPECIAL BRAND',
    'NON BRAND'
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    futureData = PublicationOrderManagementService.fetchPublicationOrderList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRecords(String query) {
    setState(() {
      _filteredRecords = _allRecords.where((record) {
        final matchesQuery = query.isEmpty ||
            record.publicationName.toLowerCase().contains(query.toLowerCase()) ||
            record.groupName.toLowerCase().contains(query.toLowerCase());

        final matchesBrand =
            _selectedBrand == 'ALL' || record.groupName == _selectedBrand;

        return matchesQuery && matchesBrand;
      }).toList();
    });
  }

  double get _filteredTotal {
    return _filteredRecords.fold(0.0, (sum, item) => sum + item.totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text(
          'Publication Order Management',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<PublicationOrderManagementResponse>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.records.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          // ✅ Assign only once
          if (_allRecords.isEmpty) {
            _allRecords = snapshot.data!.records;
            _filteredRecords = _allRecords;
          }

          final totalPurchase = snapshot.data!.totalPurchase;

          return Column(
            children: [

              /// 🔹 FILTER SECTION (Brand + Search)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 16, 8),
                child: Row(
                  children: [

                    /// 🔽 BRAND FILTER DROPDOWN
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedBrand,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: _brandOptions.map((brand) {
                            return DropdownMenuItem(
                              value: brand,
                              child: Text(brand),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedBrand = value;
                                _filterRecords(_searchController.text);
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    /// 🔍 SEARCH BAR
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterRecords,
                        decoration: InputDecoration(
                          hintText: "Search Publication or Brand",
                          prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _filterRecords('');
                              });
                            },
                          )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 📊 TABLE
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor:
                      MaterialStateProperty.all(Colors.grey.shade200),
                      columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('Sr No')),
                          DataColumn(label: Text('Publication Name')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Brand Name')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Action')),
                        ],
                      rows: List.generate(
                        _filteredRecords.length,
                            (index) {
                          final item = _filteredRecords[index];

                          return DataRow(
                            cells: [
                              DataCell(Text('${index + 1}')),
                                DataCell(Text(item.publicationName)),
                                DataCell(
                                  Text(
                                    '₹ ${item.totalAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item.groupName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                              DataCell(
                                Text(
                                  '${item.date.day}-${item.date.month}-${item.date.year}',
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    _openLedger(item);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    foregroundColor: Colors.white,
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6),
                                  ),
                                  child: const Text('View'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              /// 💰 TOTALS
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTotalRow(
                      label: "Filtered Brand Total",
                      amount: _filteredTotal,
                      color: Colors.deepPurple,
                    ),
                    const Divider(height: 20),
                    _buildTotalRow(
                      label: "Grand Total Purchase",
                      amount: totalPurchase,
                      color: Colors.green,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTotalRow({
    required String label,
    required double amount,
    required Color color,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          '₹ ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _openLedger(PublicationOrderRecord item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PublicationLedgerPage(
          publicationId: item.publicationId,
        ),
      ),
    );
  }
}