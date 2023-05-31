// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'news_model.dart';


// class NewsRepository {
//   Future<List<News>> fetchNews({required int page, required int pageSize}) async {
//     final jsonStr = await rootBundle.loadString('assets/fakedb.json');
//     final jsonData = jsonDecode(jsonStr);

//     // Aqui, nós extraímos a lista de notícias da chave 'news'
//     final List<dynamic> jsonArr = jsonData['news'];

//     // Simula a paginação, dividindo a lista de notícias em páginas
//     final startIndex = (page - 1) * pageSize;
//     final endIndex = startIndex + pageSize;
//     final int jsonArrLength = jsonArr.length;
//     final int end = endIndex < jsonArrLength ? endIndex : jsonArrLength;
//     var paginatedJsonArr = [];
//     if(startIndex < jsonArrLength){
//       paginatedJsonArr = jsonArr.sublist(startIndex, end);
//     }
       
//     return paginatedJsonArr.map((json) => News.fromJson(json)).toList();
//   }
// }

import 'package:http/http.dart' as http;


class NewsRepository {
  //static const String BASE_URL = 'http://backend:8080/noticia';  // Coloque o URL base do seu servidor aqui
  static const String BASE_URL = 'http://10.0.2.2:8080/noticia';  // Coloque o URL base do seu servidor aqui
  // static const String BASE_URL = 'http://192.168.0.4:8080/noticia';  // Coloque o URL base do seu servidor aqui
  

  Future<List<News>> fetchNews({required int page, required int pageSize}) async {
    final response = await http.get(Uri.parse('$BASE_URL/getnews/$page'));

    if (response.statusCode == 200) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(decodedData);
      final List<dynamic> jsonArr = jsonData['content'];
      List<News> newsList = jsonArr.map((json) => News.fromJson(json)).toList();
      print(newsList[0].title);
      return newsList;
    } else {
      throw Exception('Erro ao buscar notícias');
    }
  }

  Future<News> fetchSingleNews({required int newsId}) async {
    final response = await http.get(Uri.parse('$BASE_URL/$newsId'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      // Retornar a instância de News com a imagem decodificada
      return News.fromJson(jsonData);
    } else {
      throw Exception('Erro ao buscar notícia');
    }
  }


}
