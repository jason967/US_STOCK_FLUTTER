import 'package:http/http.dart' as http;

class StockApi {
  static const baseUrl = 'https://www.alphavantage.co/';
  static const apiKey = '54L72Q8UIQVTB4O5';
  final http.Client client;
  //test코드를 작성할 때 용이
  StockApi(this.client);

  Future<http.Response> getListings(String apiKey) async {
    return await client.get(Uri.parse(
        'https://www.alphavantage.co/query?function=LISTING_STATUS&paikey=$apiKey'));
  }
}
