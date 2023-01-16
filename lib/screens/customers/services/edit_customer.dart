// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:bhatti_pos/screens/customers/services/get_all_customers.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';

editCustomer(int id, String address, String name, String phone) async {
  APIClient _apiClient = APIClient();
  String response = await _apiClient.editCustomer(
    id,
    address,
    name,
    phone,
    UserData.userName!,
  );
  if (response.toLowerCase().contains("success")) {
    await getAllCustomers();
  }
  return response;
}
