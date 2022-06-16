import 'package:http/http.dart' as http;
import '../models/products_model.dart';

class HttpService {
  static Future<List<ProductsModel>> fetchProducts() async {
    const options = {
      "method": "GET",
      "hostname": "hotels4.p.rapidapi.com",
      "headers": {
        "X-RapidAPI-Host": "hotels4.p.rapidapi.com",
        "X-RapidAPI-Key": "5d019ac0f3msha47262bddc77b10p176b23jsne763b6803d0c",
        "useQueryString": true
      }
    };

    var response =
        await http.get(Uri.parse("https://fakestoreapi.com/products"));
    if (response.statusCode == 200) {
      var data = response.body;
      return productsModelFromJson(data);
    } else {
      throw Exception();
    }
  }
}
