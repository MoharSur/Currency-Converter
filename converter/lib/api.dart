import 'dart:convert';

import 'package:http/http.dart';
class ApiClient{

   String apiKey = '2fdaaa05ed3eaecf2ebc';

    Future<List<String>> getCurrencies() async {
      Response response = await get(Uri.parse(
        'https://free.currconv.com/api/v7/currencies?apiKey=$apiKey'));
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        var results = data['results'];
        var currencies = results.keys.toList();
        return currencies;
      }
      else{
        throw Exception('Unable to connect to the api');
      }
    }
    Future<double> getCurrencyRate(String from, String to) async {
      String fromTo = '${from}_$to';
      Response response = await get(Uri.parse
         ('https://free.currconv.com/api/v7/convert?q=$fromTo&compact=ultra&apiKey=$apiKey'));

      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        double rate = data[fromTo];
        return rate;
      }
      else{
        throw Exception('Unable to connect to the api');
      }
    }
}