import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Model/AccountabtMobileResponceCashierModel.dart';
import '../Model/CashierSubmitOtpResponce_model.dart';
import '../Model/all_bank_list_model.dart';
import '../Model/bankBook_get_child_groups_model.dart';
import '../Model/bank_book_form_model.dart';
import '../Model/get_bank_book_balance_model.dart';
import '../Model/get_bank_book_by_id_model.dart';
import '../Model/verify_otp_responseCashier_model.dart';
import '../Model/view_agent_discount_details_model.dart';
import 'api_constants.dart';

class AuthService {

  static Future<ViewAgentDiscountDetailsModel?>
  getInvoiceDetails(String billNo) async {

    try {

      final response = await http.get(
        Uri.parse(
          ApiConstants.saleInvoice(billNo),
        ),
      );

      if (response.statusCode == 200) {

        return ViewAgentDiscountDetailsModel.fromJson(
          jsonDecode(response.body),
        );
      }

    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<AccountantMobileResponse?> getAccountantMobile(
      String name) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://g17bookworld.com/api/AddDayBookApiNew/GetAccountantMobile?name=$name',
        ),
      );

      if (response.statusCode == 200) {
        return AccountantMobileResponse.fromJson(
          jsonDecode(response.body),
        );
      }

      return null;
    } catch (e) {
      debugPrint('Get Accountant Mobile Error: $e');
      return null;
    }
  }

  Future<SendOtpResponseModel?> sendOtp({
    required String mobile,
    required String amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://g17bookworld.com/api/AddDayBookApiNew/SendOtps',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mobile': mobile,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        return SendOtpResponseModel.fromJson(
          jsonDecode(response.body),
        );
      }

      return null;
    } catch (e) {
      print('Send OTP Error: $e');
      return null;
    }
  }
  Future<VerifyOtpResponseModel?> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://g17bookworld.com/api/AddDayBookApiNew/VerifyOtp',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mobile': mobile,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        return VerifyOtpResponseModel.fromJson(
          jsonDecode(response.body),
        );
      }

      return null;
    } catch (e) {
      print('Verify OTP Error: $e');
      return null;
    }




  }
  Future<BankBookFormModel?> getBankBookFormData() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://g17bookworld.com/api/SaveBankBook/GetSaveBankBookFormData",
        ),
      );

      if (response.statusCode == 200) {
        return BankBookFormModel.fromJson(
          jsonDecode(response.body),
        );
      } else {
        debugPrint("Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("BankBook Error: $e");
      return null;
    }
  }

  Future<GetBankBookByIdModel?> getBankById(String bankId) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://g17bookworld.com/api/SaveBankBook/GetBankById?bankId=$bankId",
        ),
      );

      if (response.statusCode == 200) {
        return GetBankBookByIdModel.fromJson(
          jsonDecode(response.body),
        );
      }

      return null;
    } catch (e) {
      debugPrint("BankById Error : $e");
      return null;
    }
  }

  Future<GetBankBookBalanceModel?> getBankBalance(String bankId) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://g17bookworld.com/api/SaveBankBook/GetBankBalance?bankId=$bankId",
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return GetBankBookBalanceModel.fromJson(json);
      } else {
        debugPrint("Status Code : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error : $e");
    }

    return null;
  }
  Future<GetChildGroupsModel?> getChildGroups(String parentId) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://g17bookworld.com/api/AddDayBookApiNew/GetChildGroups?parentId=$parentId",
        ),
      );

      if (response.statusCode == 200) {
        return GetChildGroupsModel.fromJson(
          jsonDecode(response.body),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }



}