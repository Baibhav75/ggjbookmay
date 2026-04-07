import 'package:flutter/material.dart';
import 'package:bookworld/Model/merge_order_details_model.dart';
import 'package:bookworld/Service/merge_order_details_service.dart';

class MergeOrderDetailsPage extends StatefulWidget {
  final String publicationId;

  const MergeOrderDetailsPage({super.key, required this.publicationId});

  @override
  State<MergeOrderDetailsPage> createState() =>
      _MergeOrderDetailsPageState();
}

class _MergeOrderDetailsPageState
    extends State<MergeOrderDetailsPage> {

  late TextEditingController _searchController;
  List<MergeOrderDetailsModel> _allDetails = [];
  List<MergeOrderDetailsModel> _filteredDetails = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadDetails();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDetails() async {
    try {
      final details = await MergeOrderDetailsService.fetchDetails(widget.publicationId);
      if (mounted) {
        setState(() {
          _allDetails = details;
          _filteredDetails = _allDetails;
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

  void _filterDetails(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDetails = _allDetails;
      } else {
        final lowercaseQuery = query.toLowerCase();
        _filteredDetails = _allDetails.where((item) {
          final bookNameMatch = (item.bookName ?? "").toLowerCase().contains(lowercaseQuery);
          final subjectMatch = (item.subject ?? "").toLowerCase().contains(lowercaseQuery);
          final schoolNameMatch = (item.schoolName ?? "").toLowerCase().contains(lowercaseQuery);
          return bookNameMatch || subjectMatch || schoolNameMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Merge Order Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterDetails,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search Book, Subject or School...",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () {
                    _searchController.clear();
                    _filterDetails('');
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
      return const Center(
        child: CircularProgressIndicator(
            color: Colors.deepPurple, strokeWidth: 3),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDetails,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (_filteredDetails.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text("No data found",
                style: TextStyle(color: Colors.black54)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDetails,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Card(
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                    Colors.deepPurple.shade50),
                columnSpacing: 24,
                dataRowHeight: 56,
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 14,
                ),
                columns: const [
                  DataColumn(label: Text("Sr No")),
                  DataColumn(label: Text("Publication")),
                  DataColumn(label: Text("Series")),
                  DataColumn(label: Text("Subject")),
                  DataColumn(label: Text("Book Name")),
                  DataColumn(label: Text("NU")),
                  DataColumn(label: Text("LKG")),
                  DataColumn(label: Text("UKG")),
                  DataColumn(label: Text("Class1")),
                  DataColumn(label: Text("Class2")),
                  DataColumn(label: Text("Class3")),
                  DataColumn(label: Text("Class4")),
                  DataColumn(label: Text("Class5")),
                  DataColumn(label: Text("Class6")),
                  DataColumn(label: Text("Class7")),
                  DataColumn(label: Text("Class8")),
                  DataColumn(label: Text("Class9")),
                  DataColumn(label: Text("Class10")),
                  DataColumn(label: Text("Class11")),
                  DataColumn(label: Text("Class12")),
                  DataColumn(label: Text("School Name")),
                ],
                rows: List.generate(_filteredDetails.length, (index) {
                  final item = _filteredDetails[index];
                  final isEven = index % 2 == 0;

                  return DataRow(
                    color: MaterialStateProperty.all(
                        isEven ? Colors.white : Colors.grey.shade50),
                    cells: [
                      DataCell(Text("${index + 1}",
                          style: const TextStyle(color: Colors.black54))),
                      DataCell(Text(_safeString(item.publication))),
                      DataCell(Text(_safeString(item.series))),
                      DataCell(Text(_safeString(item.subject))),
                      DataCell(Text(_safeString(item.bookName),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500))),

                      // 👇 DATA VISIBILITY FIX APPLIED HERE
                      DataCell(_numberCell(item.nU)),
                      DataCell(_numberCell(item.lKG)),
                      DataCell(_numberCell(item.uKG)),
                      DataCell(_numberCell(item.class1)),
                      DataCell(_numberCell(item.class2)),
                      DataCell(_numberCell(item.class3)),
                      DataCell(_numberCell(item.class4)),
                      DataCell(_numberCell(item.class5)),
                      DataCell(_numberCell(item.class6)),
                      DataCell(_numberCell(item.class7)),
                      DataCell(_numberCell(item.class8)),
                      DataCell(_numberCell(item.class9)),
                      DataCell(_numberCell(item.class10)),
                      DataCell(_numberCell(item.class11)),
                      DataCell(_numberCell(item.class12)),

                      DataCell(Text(_safeString(item.schoolName),
                          style: const TextStyle(color: Colors.indigo))),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= HELPER METHODS =================

  /// 🔹 Safe string (no null text)
  String _safeString(String? value) {
    if (value == null || value == "null" || value.isEmpty) {
      return "-";
    }
    return value;
  }

  /// 🔹 Hide 0 and null values, style numbers
  Widget _numberCell(dynamic value) {
    if (value == null) return const SizedBox();

    final val = value.toString();

    if (val == "0" || val == "0.0" || val == "null" || val.isEmpty) {
      return const Center(
          child: Text("-", style: TextStyle(color: Colors.black12)));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        val,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }
}
