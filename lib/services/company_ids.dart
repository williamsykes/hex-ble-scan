import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

late final Map<int, String> companyIdMap;

Future<void> loadCompanyIdentifiers() async {
  final jsonStr =
      await rootBundle.loadString('assets/company_identifiers.json');
  final Map<String, dynamic> raw = json.decode(jsonStr);

  final List<dynamic> companyList = raw["company_identifiers"];

  companyIdMap = {
    for (var item in companyList) item["value"] as int: item["name"] as String
  };
}
