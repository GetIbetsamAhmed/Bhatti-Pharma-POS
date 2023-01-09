// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:bhatti_pos/screens/customers/services/get_all_customers.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';

createCustomer(String address, String phone, String name) async {
  APIClient _apiClient = APIClient();
  String response =
      await _apiClient.createCustomer(UserData.userName!, address, phone, name);
  if (response.toLowerCase().contains("success")) {
    await getAllCustomers();
  }
  return response;
}
