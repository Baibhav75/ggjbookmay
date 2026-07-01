import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/bank_book_save_model.dart';

class BankBookSaveService {

  Future<BankBookSaveModel?> saveEmployeeBankBook({
    required String bankId,
    required String transactionType,
    required String amount,
    required String type,
    required String employeeId,
    required String description,
    required String createdBy,
    required String creatorName,
    required String paymentDate,
    required String voucherNo,
    String? toPayment,
    String? complaintImagePath,
  }) async {

    try {

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://g17bookworld.com/api/SaveBankBook/SaveBankBookPost",
        ),
      );

      request.fields["BankId"] = bankId;
      request.fields["TransactionType"] = transactionType;
      request.fields["Amount"] = amount;
      request.fields["Type"] = type;
      request.fields["EmployeeId"] = employeeId;
      request.fields["Description"] = description;
      request.fields["CreatedBy"] = createdBy;
      request.fields["CreatorName"] = creatorName;
      request.fields["PaymentDate"] = paymentDate;
      request.fields["VoucherNo"] = voucherNo;
      if (toPayment != null) {
        request.fields["ToPayment"] = toPayment;
      }

      if (complaintImagePath != null && complaintImagePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'ComplaintImage', 
          complaintImagePath,
        ));
      }

      var response = await request.send();

      var body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return BankBookSaveModel.fromJson(
          jsonDecode(body),
        );
      }

    } catch (e) {
      print(e);
    }

    return null;
  }
}