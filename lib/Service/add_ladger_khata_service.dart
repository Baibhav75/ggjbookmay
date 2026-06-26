import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;

import '../Model/add_ladger_khata_response_model.dart';

class AddLadgerKhataService {
  static final Uri _submitUrl = Uri.parse(
    'https://g17bookworld.com/api/AddDayBookApiNew/AddLadgerKhataPost',
  );

  Future<AddLadgerKhataResponse> submitLedgerKhata({
    required String voucherNo,
    required String flag,
    required String type,
    required String formSection,
    required String accountGroupId,
    required String employeeId,
    required String toPayment,
    required String createdBy,
    required String amount,
    required String remarks,
    required String backDate,
    required String particularName,
    required String mobileNo,
    required String expenceBowcherNo2,
    required String receiptBowcherNo,
    File? imageFile,
    String? imageFileName,
    Map<String, String> extraFields = const <String, String>{},
  }) {
    return _postFields({
      'VoucherNo': voucherNo,
      'Flag': flag,
      'Type': type,
      'FormSection': formSection,
      'AccountGroup': accountGroupId,
      'EmployeeId': employeeId,
      'ToPayment': toPayment,
      'CreatedBy': createdBy,
      'Amount': amount,
      'Remarks': remarks,
      'BackDate': backDate,
      'ParicularName': particularName,
      'MobileNo': mobileNo,
      'ExpenceBowcherNo2': expenceBowcherNo2,
      'ReceiptBowcherNo': receiptBowcherNo,
      ...extraFields,
    },
      imageFile,
      imageFileName,
    );
  }

  Future<AddLadgerKhataResponse> submitSchoolPayment({
    required String schoolId,
    required String cashierId,
    required String agentId,
    required String paymentDate,
    required String amount,
    required String remarks,
    required String customerMobile,
    required String voucherNo,
    required String flag,
    required String type,
  }) {
    return _postFields({
      'VoucherNo': voucherNo,
      'Flag': flag,
      'Type': type,
      'FormSection': 'SCHOOLPAYMENT',
      'SchoolPaySchoolId': schoolId,
      'SchoolPayCashierId': cashierId,
      'SchoolPayAgentId': agentId,
      'SchoolPayPaymentDate': paymentDate,
      'SchoolPayAmount': amount,
      'SchoolPayRemarks': remarks,
      'SchoolPayCustomerMobile': customerMobile,

    }, null);
  }

  Future<AddLadgerKhataResponse> _postFields(
      Map<String, String> fields,
      File? imageFile,
      [String? imageFileName]
      ) async {
    final request = http.MultipartRequest(
      'POST',
      _submitUrl,
    )..fields.addAll(_cleanFields(fields));

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'Imagefile',
          imageFile.path,
          filename: imageFileName ?? imageFile.path.split('/').last,
        ),
      );
    }

    print("FIELDS => ${request.fields}");
    print("FILES COUNT => ${request.files.length}");

    for (var file in request.files) {
      print("FIELD => ${file.field}");
      print("FILENAME => ${file.filename}");
    }

    try {
      final streamedResponse = await request.send();
      final response =
      await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to submit: ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);

      return AddLadgerKhataResponse.fromJson(decoded);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Map<String, String> _cleanFields(Map<String, String> fields) {
    return Map<String, String>.fromEntries(
      fields.entries.where((entry) => entry.value.trim().isNotEmpty),
    );
  }
}
