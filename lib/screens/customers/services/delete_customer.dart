// ignore_for_file: no_leading_underscores_for_local_identifiers, file_names

import 'package:bhatti_pos/screens/customers/services/get_all_customers.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';

deleteCustomer(int id) async {
  APIClient _apiClient = APIClient();
  String response = await _apiClient.deleteCustomer(id);
  if (response.toLowerCase().contains("success")) {
    await getAllCustomers();
  }
  return response;
}
