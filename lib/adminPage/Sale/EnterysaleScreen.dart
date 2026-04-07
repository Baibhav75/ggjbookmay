import 'package:bookworld/adminPage/Sale/sale_invoice_history_screen.dart';
import 'package:flutter/material.dart';

class SaleInvoiceEntry extends StatefulWidget {
  const SaleInvoiceEntry({super.key});

  @override
  State<SaleInvoiceEntry> createState() => _PurchaseEntryScreenState();
}

class _PurchaseEntryScreenState extends State<SaleInvoiceEntry> {

  String? selectedSchool;
  String? selectedPublication;
  String? selectedSeries;
  String? selectedTitle;
  String? selectedTransport;


  List<SelectedItemGroup> addedGroups = [];

  @override
  void dispose() {
    for (var group in addedGroups) {
      for (var row in group.rows) {
        row.qtyController.dispose();
      }
    }
    super.dispose();
  }

  List<String> schools = [
    "DRAPDOWN SCHOOL",
    "DEV SCHOOL"
  ];

  List<String> publications = [
    "APC Publication",
    "APPS Publication"
  ];

  List<String> series = [
    "Series 1",
    "Series 2",
    "Series 3"
  ];

  List<String> titles = [
    "ELEVATE MATHEMATICS",
    "SMART ENGLISH",
    "SCIENCE MASTER"
  ];
  List<String> transportOptions = [
    "Bus",
    "Van",
    "Self",
    "Suzuki"
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        title: const Text("SaleInvoice Entry"),
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,


      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// GENERAL INFO
                const Text("General Information", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 16)),
                const SizedBox(height: 12),
                _textField("Bill No", "83"),
                const SizedBox(height: 16),
                _textField("Remark", "Enter remark"),
                const SizedBox(height: 16),
                _textField("Rec. Date", "dd-mm-yyyy"),
                const SizedBox(height: 16),
                _textField("Agent Name", ""),
                const SizedBox(height: 24),


                /// VEHICLE INFO
                const Text("Vehicle Information", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 16)),
                const SizedBox(height: 12),
                _textField("Vehicle No", ""),
                const SizedBox(height: 16),
                _textField("Driver Name", ""),
                const SizedBox(height: 16),
                _textField("Driver Mobile", ""),
                const SizedBox(height: 24),

                const Divider(),
                const SizedBox(height: 16),

                /// PARTY DETAILS
                const Text("Party Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 16)),
                const SizedBox(height: 12),
                _dropdown(
                  label: "Party Name",
                  value: selectedSchool,
                  items: schools,
                  onChanged: (v) {
                    setState(() {
                      selectedSchool = v;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _textField("Party Address", ""),
                const SizedBox(height: 24),

                const Divider(),
                const SizedBox(height: 16),

                /// PUBLICATION DETAILS
                const Text("Publication Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 16)),
                const SizedBox(height: 12),
                _dropdown(
                  label: "Publication",
                  value: selectedPublication,
                  items: publications,
                  onChanged: (v) {
                    setState(() {
                      selectedPublication = v;

                      /// 🔥 reset नीचे वाले
                      selectedSeries = null;
                      selectedTitle = null;
                    });
                  },
                ),
                const Text(
                  "Group: BRAND",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),
                _dropdown(
                  label: "Transport",
                  value: selectedTransport,
                  items: transportOptions,
                  onChanged: (v) {
                    setState(() {
                      selectedTransport = v;
                    });
                  },
                ),
                const SizedBox(height: 8),

                /// SERIES (after publication select)
                if (selectedPublication != null) ...[
                  _dropdown(
                    label: "Series",
                    value: selectedSeries,
                    items: series,
                    onChanged: (v) {
                      setState(() {
                        selectedSeries = v;

                        /// 🔥 reset title when series changes
                        selectedTitle = null;
                      });
                    },
                  ),
                ],

                const SizedBox(height: 16),

                /// TITLE (after series select)
                if (selectedSeries != null) ...[
                  _dropdown(
                    label: "Title",
                    value: null,
                    items: titles,
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          selectedTitle = v;

                          addedGroups.add(
                            SelectedItemGroup(
                              series: selectedSeries!,
                              title: v,
                              publication: selectedPublication!,
                              rows: [
                                BookRowData(className: "Class 1", subject: "COMPUTER", stockQty: 0, rate: 218.00),
                                BookRowData(className: "Class 2", subject: "COMPUTER", stockQty: 0, rate: 234.00),
                                BookRowData(className: "Class 3", subject: "COMPUTER", stockQty: 0, rate: 268.00),
                                BookRowData(className: "Class 4", subject: "COMPUTER", stockQty: 0, rate: 298.00),
                                BookRowData(className: "Class 5", subject: "COMPUTER", stockQty: 0, rate: 328.00),
                              ],
                            ),
                          );
                        });
                      }
                    },
                  ),
                ],

                if (addedGroups.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildItemsTable(),
                ],

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: _button("Submit", Colors.deepPurple),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ITEMS TABLE
  Widget _buildItemsTable() {
    final columnWidths = const <int, TableColumnWidth>{
      0: FixedColumnWidth(120),
      1: FixedColumnWidth(80),
      2: FixedColumnWidth(80),
      3: FixedColumnWidth(100),
      4: FixedColumnWidth(70),
      5: FixedColumnWidth(80),
      6: FixedColumnWidth(100),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Items in Selected Series",
          style: TextStyle(
            color: Colors.green,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 72, // Screen width minus padding
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Table
                Table(
                  border: TableBorder(
                    top: BorderSide(color: Colors.grey.shade300),
                    left: BorderSide(color: Colors.grey.shade300),
                    right: BorderSide(color: Colors.grey.shade300),
                    bottom: BorderSide(color: Colors.grey.shade300),
                    verticalInside: BorderSide(color: Colors.grey.shade300),
                  ),
                  columnWidths: columnWidths,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade100),
                      children: [
                        _tableHeader("Book Name"),
                        _tableHeader("Class"),
                        _tableHeader("Subject"),
                        _tableHeader("Stoct Qty"),
                        _tableHeader("Qty"),
                        _tableHeader("Rate"),
                        _tableHeader("Amount"),
                      ],
                    ),
                  ],
                ),

                // 2. Data Groups
                ...addedGroups.map((group) {
                  double subtotal = 0;
                  for (var r in group.rows) {
                    subtotal += (r.qty * r.rate);
                  }

                  return Column(
                    children: [
                      // Group Header Row (Spans full width)
                      Container(
                        width: 630, // Sum of FixedColumnWidths (120+80+80+100+70+80+100)
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey.shade300),
                            right: BorderSide(color: Colors.grey.shade300),
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Series: ${group.series} | Title: ${group.title}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              "Publication: ${group.publication}",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      
                      // Group Data Rows
                      Table(
                        border: TableBorder(
                          left: BorderSide(color: Colors.grey.shade300),
                          right: BorderSide(color: Colors.grey.shade300),
                          verticalInside: BorderSide(color: Colors.grey.shade300),
                        ),
                        columnWidths: columnWidths,
                        children: group.rows.map((row) {
                          return TableRow(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                            ),
                            children: [
                              _tableCell(group.title),
                              _tableCell(row.className),
                              _tableCell(row.subject),
                              _tableCell("Purchased: ${row.stockQty}", color: Colors.green),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 35,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    controller: row.qtyController,
                                    onChanged: (val) {
                                      setState(() {
                                        row.qty = int.tryParse(val) ?? 0;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              _tableCell(row.rate.toStringAsFixed(2)),
                              _tableCell((row.qty * row.rate).toStringAsFixed(2)),
                            ],
                          );
                        }).toList(),
                      ),

                      // Group Subtotal Row
                      Container(
                        width: 630,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey.shade300),
                            right: BorderSide(color: Colors.grey.shade300),
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Subtotal (${group.series} - ${group.title}):      ${subtotal.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _tableCell(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontWeight: color != null ? FontWeight.bold : null),
      ),
    );
  }

  /// TEXT FIELD
  Widget _textField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(label),

        const SizedBox(height: 6),

        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  /// DROPDOWN
  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(label),

        const SizedBox(height: 6),

        DropdownButtonFormField<String>(

          value: value,

          items: items
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
              .toList(),

          onChanged: onChanged,

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  /// BUTTON
  Widget _button(String title, Color color) {

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
      ),
      child: Text(title),
    );
  }
}

class BookRowData {
  String className;
  String subject;
  int stockQty;
  int qty;
  double rate;
  TextEditingController qtyController;

  BookRowData({
    required this.className,
    required this.subject,
    required this.stockQty,
    this.qty = 0,
    required this.rate,
  }) : qtyController = TextEditingController(text: qty > 0 ? qty.toString() : '');
}

class SelectedItemGroup {
  String series;
  String title;
  String publication;
  List<BookRowData> rows;

  SelectedItemGroup({
    required this.series,
    required this.title,
    required this.publication,
    required this.rows,
  });
}