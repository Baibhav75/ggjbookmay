import 'package:flutter/material.dart';

import '../../Model/bank_book_form_model.dart';
import '../../appDart/auth_servcie.dart';
import 'package:get/get.dart';

class BankBookController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;

  BankBookFormModel? bankBookModel;

  RxList<BankModel> banks = <BankModel>[].obs;
  RxList<PartyModel> parties = <PartyModel>[].obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<LedgerGroupModel> ledgerGroups = <LedgerGroupModel>[].obs;

  Future<void> getBankBookFormData() async {
    try {
      isLoading.value = true;

      final response = await _authService.getBankBookFormData();

      if (response != null) {
        bankBookModel = response;

        banks.assignAll(response.data.banks);
        parties.assignAll(response.data.expenseParties);
        categories.assignAll(response.data.expenseCategories);
        ledgerGroups.assignAll(response.data.categoryList);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    getBankBookFormData();
    super.onInit();
  }
}