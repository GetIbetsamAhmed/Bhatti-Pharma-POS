// ignore_for_file: no_leading_underscores_for_local_identifiers, file_names

import 'package:bhatti_pos/services/models/customer.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';

getAllCustomers() async {
  CustomerList.customers.clear();
  APIClient _apiClient = APIClient();
  List customers = await _apiClient.getAllCustomers(UserData.userName!);

  // List of all Customer objects
  for (dynamic item in customers) {
    Customer customer = Customer.fromJson(item);
    CustomerList.customers.add(customer);
  }
  sortCustomerList();
}
