import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Model/send_transfer_otp_model.dart';

class SendTransferOtpService {

  Future<SendTransferOtpModel?> sendTransferOtp({
    required String fromEmpId,
    required String toEmpId,
    required String amount,
    required String remarks,
    File? imageFile,
  }) async {

    var uri = Uri.parse(
        "https://g17bookworld.com/API/TransferAmount/SendTransferOTP");

    var request = http.MultipartRequest("POST", uri);

    request.fields["FromEmpId"] = fromEmpId;
    request.fields["ToEmpId"] = toEmpId;
    request.fields["Amount"] = amount;
    request.fields["Remarks"] = remarks;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "ImageFile",
          imageFile.path,
        ),
      );
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return SendTransferOtpModel.fromJson(
          jsonDecode(responseData));
    } else {
      return null;
    }
  }
}