// ignore_for_file: file_names

class SalesReportData {
  String? pID;
  String? productName;
  double? qty;
  double? netAmount;
  double? contribution;

  SalesReportData({
    this.pID,
    this.productName,
    this.qty,
    this.netAmount,
    this.contribution,
  });

  SalesReportData.fromJson(Map<String, dynamic> json) {
    pID = json['PID'].toString();
    productName = json['ProductName'];
    qty = json['Qty'];
    netAmount = double.parse(json['NetAmount'].toStringAsFixed(2));
    contribution = json['Contribution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['PID'] = pID;
    data['ProductName'] = productName;
    data['Qty'] = qty;
    data['NetAmount'] = netAmount;
    data['Contribution'] = contribution;
    return data;
  }
}
