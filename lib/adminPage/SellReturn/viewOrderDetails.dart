import 'package:flutter/material.dart';

class ViewOrderDetails extends StatelessWidget {
  const ViewOrderDetails({super.key});

  TableRow _headerRow() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xffeeeeee)),
      children: [
        Padding(
          padding: EdgeInsets.all(6),
          child: Text("S.N", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: Text("Book Name",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child:
          Text("Qty", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child:
          Text("Rate", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child:
          Text("Amount", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: Text("Amt With Disc.",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  TableRow _bookRow(
      String sn, String name, String qty, String rate, String amt) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(sn),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(name),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(qty),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(rate),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(amt),
        ),
        const Padding(
          padding: EdgeInsets.all(6),
          child: Text(""),
        ),
      ],
    );
  }

  TableRow _subtotalRow(String qty, String amount) {
    return TableRow(children: [
      const Padding(
        padding: EdgeInsets.all(6),
        child: Text(""),
      ),
      const Padding(
        padding: EdgeInsets.all(6),
        child: Text("Subtotal",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      Padding(
        padding: const EdgeInsets.all(6),
        child: Text(qty),
      ),
      const Padding(
        padding: EdgeInsets.all(6),
        child: Text(""),
      ),
      Padding(
        padding: const EdgeInsets.all(6),
        child: Text(amount),
      ),
      const Padding(
        padding: EdgeInsets.all(6),
        child: Text(""),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Details"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// COMPANY HEADER
            const Center(
              child: Column(
                children: [
                  Text(
                    "GJ BOOK WORLD PVT LTD",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text("D-1/20, SECTOR 22, GIDA, GORAKHPUR"),
                  Text("Cont. - 7905891950, 8303173798"),
                  Text(
                      "GST No: 09AAGCG6058B1Z2 | CIN No: U22222UP2015PTC068597"),
                  SizedBox(height: 6),
                  Text(
                    "Sale MRP Invoice",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 2),

            /// INVOICE INFO
            const Text(
                "Invoice No : 46        Party Name : SPRINGER PUBLIC SCHOOL"),
            const Text("Bill Date  : 11-03-2026"),

            const Divider(),

            const Text(
                "Transport: BY ISUZU    Address: BARGADWA GORAKHPUR    Rec. Date: 11-03-2026"),

            const SizedBox(height: 10),

            /// SERIES HEADER
            const Text(
              "Series: MAXWELL, N-U  Publication: SHREE HOLY GANGA INTERNATIONAL",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const Divider(),

            /// TABLE
            Table(
              border: TableBorder.all(color: Colors.black12),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(4),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
              },
              children: [
                _headerRow(),
                _bookRow("1", "Rhymes With Rhymes Nursery", "40", "180", "7200"),
                _bookRow("2", "Rhymes With Rhymes LKG", "45", "180", "8100"),
                _bookRow("3", "Rhymes With Rhymes UKG", "45", "180", "8100"),
                _subtotalRow("130", "23400"),
              ],
            ),

            const SizedBox(height: 20),

            /// GRAND TOTAL
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12)),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand Total"),
                      Text("260    ₹608255.00",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Discount"),
                      Text("0%    ₹608255.00"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Invoice Created By: SUJITA SHARMA",
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}