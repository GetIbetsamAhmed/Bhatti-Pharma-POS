// ignore_for_file: file_names
import 'dart:convert';
import 'package:bhatti_pos/services/models/product.dart';
import 'package:http/http.dart' as http;

class APIClient {
  Map<String, String> headers = {
    "Content-type": "",
  };

  final String _hostAddress = "http://daniyalabid-001-site1.dtempurl.com/api/";

  Future<dynamic> getAllProducts() async {
    var uri = Uri.parse("${_hostAddress}services/GetAllProducts");
    var response = await http.get(uri);
    List<dynamic> res = jsonDecode(response.body);
    List<Product> products = []; 
    for(dynamic item in res){
      var pid = item['ProductID'];
      var pname = item['ProductName'];
      var pstock = item['CurrentStock'];
      var puprice = item['UnitPrice'];
      Product product = Product(productID: "$pid", productName: pname, unitPrice: "Rs: $puprice", paymentMedium: "Cash", currentStock: pstock, bookingDate: "", bookingTime: "");
      products.add(product);
    }
    return products;
  }

  
}
