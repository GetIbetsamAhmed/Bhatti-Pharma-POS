class DailyReportData {
  int? sNO;
  String? orderNo;
  double? cash;
  String? partyName;
  String? areaName;

  DailyReportData(
      {this.sNO, this.orderNo, this.cash, this.partyName, this.areaName});

  DailyReportData.fromJson(Map<String, dynamic> json) {
    sNO = json['SNO'];
    orderNo = json['OrderNo'];
    cash = double.parse(json['Cash'].toStringAsFixed(2));
    partyName = json['PartyName'];
    areaName = json['AreaName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['SNO'] = sNO;
    data['OrderNo'] = orderNo;
    data['Cash'] = cash;
    data['PartyName'] = partyName;
    data['AreaName'] = areaName;
    return data;
  }
}
