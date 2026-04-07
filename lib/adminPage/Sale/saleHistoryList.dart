import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '/Model/sale_history_details_model.dart';
import '/Service/sale_historyDetails_service.dart';

class SaleHistoryDetailsPage extends StatefulWidget {
  final String billNo;

  const SaleHistoryDetailsPage({super.key, required this.billNo});

  @override
  State<SaleHistoryDetailsPage> createState() => _SaleHistoryDetailsPageState();
}

class _SaleHistoryDetailsPageState extends State<SaleHistoryDetailsPage> {
  SaleHistoryDetailsModel? invoice;
  bool loading = true;
  double zoomFactor = 1.0; // Zoom factor state

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    final data =
        await SaleHistoryDetailsService.getInvoiceDetails(widget.billNo);

    setState(() {
      invoice = data;
      loading = false;
    });
  }

  void _zoomIn() {
    setState(() {
      if (zoomFactor < 2.0) zoomFactor += 0.1;
    });
  }

  void _zoomOut() {
    setState(() {
      if (zoomFactor > 0.5) zoomFactor -= 0.1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (invoice == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Failed to load invoice details")),
      );
    }

    final master = invoice!.master;

    // Group items by Publication and Series
    Map<String, Map<String, List<Item>>> groupedItems = {};
    for (var item in invoice!.items) {
      groupedItems.putIfAbsent(item.publication, () => {});
      groupedItems[item.publication]!.putIfAbsent(item.series, () => []);
      groupedItems[item.publication]![item.series]!.add(item);
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Invoice #${master.billNo}",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            tooltip: "Zoom In",
            onPressed: _zoomIn,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            tooltip: "Zoom Out",
            onPressed: _zoomOut,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Zoom",
            onPressed: () => setState(() => zoomFactor = 1.0),
          ),
          const VerticalDivider(color: Colors.white24, indent: 12, endIndent: 12),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // TODO: Implement Print functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Transform.scale(
              scale: zoomFactor,
              alignment: Alignment.topLeft,
              child: Container(
                width: 800, // Reduced from 900 to optimize horizontal space
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- HEADER ---
                    _buildHeader(),
                    const Divider(height: 1, thickness: 1),

                    // --- TITLE ---
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.grey[50],
                      child: Center(
                        child: Text(
                          "Sale MRP Invoice",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),

                    // --- MASTER DETAILS ---
                    _buildMasterDetails(master),
                    const Divider(height: 1, thickness: 1),

                    // --- ITEMS TABLE ---
                    _buildItemsTable(groupedItems),

                    // --- FOOTER TOTALS ---
                    _buildFooter(invoice!),

                    // --- CREATED BY ---
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Invoice Created By: SUJITA SHARMA",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "GJ BOOK WORLD PVT. LTD.",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6B46C1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "D-1/20, SECTOR 22, GIDA, GORAKHPUR",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[800]),
          ),
          Text(
            "GST No: 09AAGCG0650B1Z2 | CIN No: U22222UP2015PTC068597",
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterDetails(Master master) {
    String formattedDate = "";
    try {
      formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.parse(master.dates));
    } catch (e) {
      formattedDate = master.dates;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _detailItem("Invoice No", master.billNo, isBold: true),
              ),
              Expanded(
                flex: 5,
                child: _detailItem("Party Name", master.schoolName, isBold: true),
              ),
              Expanded(
                flex: 3,
                child: _detailItem("Bill Date", formattedDate),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _detailItem("Transport", master.transport),
              ),
              Expanded(
                flex: 5,
                child: _detailItem("Address", master.address),
              ),
              Expanded(
                flex: 3,
                child: _detailItem("Rec. Date", "-"), // Rec. Date if available
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _detailItem("Vehicle No", master.vehicleNo ?? "-"),
              ),
              Expanded(
                flex: 5,
                child: _detailItem("Driver Name", master.vehicleDriverName ?? "-"),
              ),
              Expanded(
                flex: 3,
                child: _detailItem("Driver Mo No", master.vehicleDriverMoNo ?? "-"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsTable(Map<String, Map<String, List<Item>>> groupedItems) {
    int srNo = 1;
    List<Widget> rows = [];

    // Header Row
    rows.add(
      Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            _tableHeaderCell("S.N", flex: 1),
            _tableHeaderCell("Book Name(Title)", flex: 5),
            _tableHeaderCell("Qty", flex: 1, align: TextAlign.center),
            _tableHeaderCell("Rate", flex: 2, align: TextAlign.right),
            _tableHeaderCell("Amount", flex: 2, align: TextAlign.right),
            _tableHeaderCell("Amt With Disc.", flex: 2, align: TextAlign.right),
          ],
        ),
      ),
    );

    groupedItems.forEach((publication, seriesMap) {
      seriesMap.forEach((series, items) {
        // Group Header
        rows.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: Border(
                bottom: BorderSide(color: Colors.blue[100]!),
                top: BorderSide(color: Colors.blue[100]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.blue[900]),
                      children: [
                        const TextSpan(text: "Series: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: "$series  "),
                        const TextSpan(text: "Publication: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: publication),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        int seriesQty = 0;
        double seriesRate = 0; // Added for rate calculation
        double seriesAmount = 0;
        double seriesAmtWithDisc = 0;

        for (var item in items) {
          double amtWithDisc = item.totalAmount - (item.totalAmount * (item.discount / 100));
          
          seriesQty += item.qty;
          seriesRate += item.rate; // Sum of rates
          seriesAmount += item.totalAmount;
          seriesAmtWithDisc += amtWithDisc;

          rows.add(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  _tableCell("${srNo++}", flex: 1),
                  _tableCell("${item.bookName} - ${item.classes}", flex: 5, isBold: true),
                  _tableCell("${item.qty}", flex: 1, align: TextAlign.center),
                  _tableCell(item.rate.toStringAsFixed(2), flex: 2, align: TextAlign.right),
                  _tableCell(item.totalAmount.toStringAsFixed(2), flex: 2, align: TextAlign.right),
                  _tableCell(amtWithDisc.toStringAsFixed(2), flex: 2, align: TextAlign.right),
                ],
              ),
            ),
          );
        }

        // --- SERIES SUBTOTAL ROW ---
        rows.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.orange[50]?.withOpacity(0.5),
              border: Border(bottom: BorderSide(color: Colors.orange[100]!)),
            ),
            child: Row(
              children: [
                const Expanded(flex: 1, child: SizedBox()),
                _tableCell("Series Subtotal:", flex: 5, align: TextAlign.right, isBold: true),
                _tableCell("$seriesQty", flex: 1, align: TextAlign.center, isBold: true),
                _tableCell(seriesRate.toStringAsFixed(2), flex: 2, align: TextAlign.right, isBold: true), // Displayed total rate
                _tableCell(seriesAmount.toStringAsFixed(2), flex: 2, align: TextAlign.right, isBold: true),
                _tableCell(seriesAmtWithDisc.toStringAsFixed(2), flex: 2, align: TextAlign.right, isBold: true),
              ],
            ),
          ),
        );
      });
    });

    return Column(children: rows);
  }

  Widget _tableHeaderCell(String text, {required int flex, TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _tableCell(String text, {required int flex, TextAlign align = TextAlign.left, bool isBold = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildFooter(SaleHistoryDetailsModel invoice) {
    int totalQty = invoice.items.fold(0, (sum, item) => sum + item.qty);
    double totalRate = invoice.items.fold(0.0, (sum, item) => sum + item.rate); // Total rate for footer
    double subtotal = invoice.items.fold(0.0, (sum, item) => sum + item.totalAmount);
    
    // Calculate total discount from items or use a master discount if available
    // Mockup shows: Disc(%) 0 and Total Discount
    double totalAmtWithDisc = invoice.items.fold(0.0, (sum, item) => sum + (item.totalAmount * (1 - item.discount / 100)));
    double totalDiscountAmount = subtotal - totalAmtWithDisc;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        children: [
          _footerRow("Subtotal", totalQty, totalRate.toStringAsFixed(2), subtotal.toStringAsFixed(2), totalAmtWithDisc.toStringAsFixed(2)),
          const SizedBox(height: 8),
          _footerRow("Disc(%) / Total Discount", null, null, "${(totalDiscountAmount / subtotal * 100).toStringAsFixed(1)}%", totalDiscountAmount.toStringAsFixed(2), isHighlight: true),
          const Divider(height: 24, thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Grand Total",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF6B46C1)),
              ),
              Text(
                "₹ ${totalAmtWithDisc.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF6B46C1)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerRow(String label, int? qty, String? rate, String val1, String val2, {bool isHighlight = false}) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              color: isHighlight ? Colors.blue[800] : Colors.grey[700],
            ),
          ),
        ),
        if (qty != null)
          _tableCell(qty.toString(), flex: 1, align: TextAlign.center, isBold: true)
        else
          const Expanded(flex: 1, child: SizedBox()),
        if (rate != null)
          _tableCell(rate, flex: 2, align: TextAlign.right, isBold: true)
        else
          const Expanded(flex: 2, child: SizedBox()),
        _tableCell(val1, flex: 2, align: TextAlign.right, isBold: isHighlight),
        _tableCell(val2, flex: 2, align: TextAlign.right, isBold: isHighlight),
      ],
    );
  }
}



