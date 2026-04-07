import 'package:flutter/material.dart';
import '../service/update_order_status_service.dart';
import '../model/update_order_status_model.dart';

class OrderDetailsPage extends StatefulWidget {
  final String counterId;
  final String orderNo;
  final double initialDiscount;

  const OrderDetailsPage({
    super.key,
    required this.counterId,
    required this.orderNo,
    required this.initialDiscount,
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {

  bool loading = false;
  String message = "";

  late TextEditingController discountController;

  @override
  void initState() {
    super.initState();
    discountController = TextEditingController(
      text: widget.initialDiscount.toString(),
    );
  }

  Future<void> verifyOrder() async {

    /// validation
    if (discountController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter discount"),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    UpdateOrderStatusModel? result =
    await UpdateOrderStatusService.updateOrderStatus(
      widget.orderNo,
      widget.counterId,
      discountController.text,
    );

    setState(() {
      loading = false;
      message = result?.message ?? "Something went wrong";
    });

    /// success popup
    if (result != null) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? ""),
        ),
      );

      /// close popup automatically
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text(
        "Verify Order",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// Discount field
            TextField(
              controller: discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Discount",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator()
                : message.isNotEmpty
                ? Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            )
                : const SizedBox(),
          ],
        ),
      ),

      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: verifyOrder,
          child: const Text("Verify"),
        ),

      ],
    );
  }
}