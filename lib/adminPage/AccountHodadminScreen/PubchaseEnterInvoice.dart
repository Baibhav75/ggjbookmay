import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Model/PurchasePublicationEntryModel.dart';
import '../../Model/PurchaseSeriesInvoice_model.dart';
import '../../Model/PurchaseTitalTabledate_model.dart';
import '../../Model/purchase_party_entry_model.dart';
import '../../Service/PurchasePublicationEntryService.dart';
import '../../Service/PurchaseSeriesInvoice_service.dart';
import '../../Service/PurchaseSubmit_service.dart';
import '../../Service/PurchaseTitalInvoice_service.dart';
import '../../Service/PurchaseTitalTabledate_service.dart';
import '../../Service/purchase_party_entry_service.dart';
import '../../Model/PurchaseTransportInvoice_model.dart';
import '../../Service/PurchaseTransportInvoice_service.dart';
import '../Sale/salePurchaseInvoice.dart';


class PurchaseInvoiceEntry extends StatefulWidget {
  const PurchaseInvoiceEntry ({super.key});

  @override
  State<PurchaseInvoiceEntry > createState() =>_PurchaseInvoiceEntryState();
}

class _PurchaseInvoiceEntryState extends State<PurchaseInvoiceEntry> {


  String? selectedSchool;
  String? selectedPublication;
  String? selectedSeries;
  String? selectedTitle;
  File? invoiceImage;
  final ImagePicker picker = ImagePicker();


  List<SelectedItemGroup> addedGroups = [];
  List<PurchasePartyEntryModel> partyList = [];
  bool isLoadingParties = true;


  List<PublicationItem> publicationList = [];
  PublicationItem? selectedPublicationItem;
  bool isLoadingPublication = true;

  List<TransportItem> transportList = [];
  TransportItem? selectedTransportItem;
  bool isLoadingTransport = true;

  List<SeriesItem> seriesList = [];
  SeriesItem? selectedSeriesItem;
  bool isLoadingSeries = false;

  List<String> titleList = [];
  String? selectedTitleItem;
  bool isLoadingTitle = false;

  ItemData? selectedItemData;
  bool isLoadingItem = false;

  @override
  void initState() {
    super.initState();
    loadPublications();
    _fetchParties();
    _fetchTransports();
  }

  void _fetchTransports() async {
    try {
      final data = await PurchaseTransportInvoiceService.fetchTransportList();
      setState(() {
        transportList = data;
        isLoadingTransport = false;
      });
    } catch (e) {
      setState(() => isLoadingTransport = false);
    }
  }

  void loadPublications() async {
    try {
      final data = await PurchasePublicationEntryService.fetchPublications();

      setState(() {
        publicationList = data;
        isLoadingPublication = false;
      });

    } catch (e) {
      setState(() => isLoadingPublication = false);
    }
  }
  void fetchSeriesByPublication(String publicationId) async {
    setState(() {
      isLoadingSeries = true;
    });

    try {
      final data = await PurchaseSeriesInvoiceService.fetchSeries(publicationId);

      setState(() {
        seriesList = data;
        isLoadingSeries = false;
      });
    } catch (e) {
      setState(() {
        isLoadingSeries = false;
      });
    }
  }

  void fetchTitlesBySeries(String seriesId) async {
    setState(() {
      isLoadingTitle = true;
    });

    try {
      final data = await PurchaseTitalInvoiceService.fetchTitles(seriesId);

      setState(() {
        titleList = data;
        isLoadingTitle = false;
      });
    } catch (e) {
      setState(() {
        isLoadingTitle = false;
      });
    }
  }
  /// PurchaseTitalTabledateService
  void fetchItemDetails(String seriesId, String title) async {
    bool isAlreadyAdded = addedGroups.any((group) => 
        group.series == selectedSeriesItem!.series && group.title == title);

    if (isAlreadyAdded) {
      showMsg("This title has already been added.");
      setState(() { selectedTitleItem = null; });
      return;
    }

    setState(() {
      isLoadingItem = true;
    });

    try {
      final data = await PurchaseTitalTabledateService.fetchItemDetails(seriesId, title);

      setState(() {
        selectedItemData = data;
        isLoadingItem = false;
        selectedTitleItem = null; // Reset selection to allow adding another

        /// 🔥 TABLE AUTO CREATE (Appended)
        addedGroups.add(
          SelectedItemGroup(
            series: selectedSeriesItem!.series,
            title: title,
            publication: selectedPublicationItem!.publication,
            rows: [
              BookRowData(className: "Class 1", subject: data.subject, rate: data.rate1),
              BookRowData(className: "Class 2", subject: data.subject, rate: data.rate2),
              BookRowData(className: "Class 3", subject: data.subject, rate: data.rate3),
              BookRowData(className: "Class 4", subject: data.subject, rate: data.rate4),
              BookRowData(className: "Class 5", subject: data.subject, rate: data.rate5),
            ],
          ),
        );
      });
    } catch (e) {
      setState(() {
        isLoadingItem = false;
      });
      showMsg("Failed to fetch item details.");
    }
  }


  Future<void> _fetchParties() async {
    try {
      final data = await PurchasePartyEntryService.fetchPublications();
      setState(() {
        partyList = data;
        isLoadingParties = false;
      });
    } catch (e) {
      setState(() {
        isLoadingParties = false;
      });
      debugPrint("Error fetching parties: $e");
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        invoiceImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    for (var group in addedGroups) {
      for (var row in group.rows) {
        row.qtyController.dispose();
      }
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade200,

        appBar: AppBar(
          title: const Text("Purchase Invoice Entry"),
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
                _textField("Rec. Date", "dd-mm-yyyy"),
                const SizedBox(height: 16),
                _textField("Sup.Bill No", ""),
                const SizedBox(height: 12),
                _textField("Challan No", ""),
                const SizedBox(height: 12),
                _textField("GrNo", ""),
                const SizedBox(height: 24),

                /// 📷 UPLOAD INVOICE IMAGE
                Text(
                  "Upload Invoice Image",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(height: 8),

                GestureDetector(
                  onTap: pickImage,

                  child: Container(
                    height: 120,
                    width: double.infinity,

                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),

                    child: invoiceImage == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt, size: 30),
                        SizedBox(height: 5),
                        Text("Tap to upload image"),
                      ],
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        invoiceImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),


                const SizedBox(height: 12),
                _textField("Received Box", ""),
                const SizedBox(height: 16),
                _textField("Pending Box", ""),
                const SizedBox(height: 16),

                const Divider(),
                const SizedBox(height: 16),

                /// PARTY DETAILS
                const Text("Party Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 16)),
                const SizedBox(height: 12),
                isLoadingParties
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Party"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedSchool,
                      items: { for (var e in partyList) e.publicationId : e.publication }
                          .entries.map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      )).toList(),
                      onChanged: (v) {
                        setState(() {
                          selectedSchool = v;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// PUBLICATION DETAILS
                const Text("Publication Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 16)),
                const SizedBox(height: 12),
                isLoadingPublication
                    ? const CircularProgressIndicator()
                    : DropdownButtonFormField<PublicationItem>(
                  value: selectedPublicationItem,

                  items: publicationList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.publication),
                    );
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedPublicationItem = value;
                      selectedSeriesItem = null; // reset
                    });

                    if (value != null) {
                      fetchSeriesByPublication(value.publicationId); // ✅ API call
                    }
                  },

                  decoration: InputDecoration(
                    labelText: "Publication",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const Text(
                  "Group: BRAND",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),
                isLoadingTransport
                    ? const CircularProgressIndicator()
                    : DropdownButtonFormField<TransportItem>(
                  value: selectedTransportItem,
                  items: transportList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.transport),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTransportItem = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Transport",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),


                /// SERIES + TITLE (Only after publication select)
                if (selectedPublicationItem != null) ...[
                  isLoadingSeries
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<SeriesItem>(
                    value: selectedSeriesItem,
                    items: seriesList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e.series),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSeriesItem = value;
                        selectedTitleItem = null; // reset title
                      });

                      if (value != null) {
                        fetchTitlesBySeries(value.seriesId); // ✅ ADD THIS LINE
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Series",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  isLoadingTitle
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<String>(
                    value: selectedTitleItem,
                    items: titleList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTitleItem = value;
                      });

                      if (value != null && selectedSeriesItem != null) {
                        fetchItemDetails(selectedSeriesItem!.seriesId, value); // ✅ API HIT
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Title",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],

                if (addedGroups.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildItemsTable(),
                ],

                const SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    child: _button("Submit", Colors.deepPurple)
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
      3: FixedColumnWidth(70),
      4: FixedColumnWidth(80),
      5: FixedColumnWidth(100),
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
                        width: 530, // Sum of FixedColumnWidths (120+80+80+70+80+100)
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
                            Expanded(
                              child: Text(
                                "Series: ${group.series} | Title: ${group.title}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Publication: ${group.publication}",
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      addedGroups.remove(group);
                                    });
                                  },
                                  child: const Icon(Icons.delete, color: Colors.red, size: 20),
                                ),
                              ],
                            ),
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
                        width: 530,
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
      onPressed: () async {

        String? publicationId = selectedPublicationItem?.publicationId;
        String? seriesId = selectedSeriesItem?.seriesId;
        String? titleName = selectedTitleItem;

        if (publicationId == null) {
          showMsg("Select publication");
          return;
        }

        if (seriesId == null) {
          showMsg("Select series");
          return;
        }

        if (addedGroups.isEmpty) {
          showMsg("Add items");
          return;
        }

        if (addedGroups.isEmpty) {
          showMsg("Add items");
          return;
        }

        /// ✅ ITEMS LIST
        List<Map<String, dynamic>> items = [];

        for (var group in addedGroups) {
          for (var row in group.rows) {
            if (row.qty > 0) {
              items.add({
                "BookName": group.title,
                "Subject": row.subject,
                "Series": group.series,
                "Classes": row.className,
                "Qty": row.qty,
                "Discount": 0,
                "SeriesId": selectedSeriesItem!.seriesId,
                "PendingBox": "0",
                "RecivedBox": "0",
                "ChallanNo": "0",
                "SepBillNo": "0",
                "Rate": row.rate,
                "TotalAmount": row.qty * row.rate, // ✅ subtotal
              });
            }
          }
        }

        /// ✅ BASE64 IMAGE
        String base64Image = "";
        if (invoiceImage != null) {
          final bytes = await invoiceImage!.readAsBytes();
          base64Image = base64Encode(bytes);
        }

        /// ✅ FINAL BODY
        Map<String, dynamic> body = {
          "Publication": selectedPublicationItem?.publication ?? "",
          "PublicationId": publicationId,
          "PartyId": selectedSchool ?? "",
          "Party": "",
          "Address": "",
          "Transport": selectedTransportItem?.transport ?? "",
          "GrNo": "GR123", // 🔥 dynamic कर सकते हो
          "RecDate": DateTime.now().toIso8601String(),
          "CreatedBy": "Admin",
          "InvoiceBase64": base64Image,
          "Items": items,
        };

        print(body); // 🔥 debug

        /// ✅ API CALL
        final response = await PurchaseSubmitService.submitPurchase(body);

        if (response != null) {
          showMsg("Saved ✅ Bill No: ${response.billNo}");
        } else {
          showMsg("Submit Failed ❌");
        }
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
      ),

      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}

class BookRowData {
  String className;
  String subject;
  int qty;
  double rate;
  TextEditingController qtyController;

  BookRowData({
    required this.className,
    required this.subject,
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