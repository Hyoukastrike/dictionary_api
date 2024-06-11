import 'dart:convert';

import 'dictionary_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class APIServices{
  static String baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';
  static Future<DictionaryModel?> fetchData(String word) async {
    Uri url = Uri.parse("$baseUrl$word");
    final response = await http.get(url);
    try{
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return DictionaryModel.fromJson(data[0]);
      }else{
        throw Exception("Tải dữ liệu thất bại");
      }
    }catch(e){
      print(e.toString());
    }
    return null;
  }
}