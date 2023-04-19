import 'dart:convert';
import 'package:flutter/services.dart';
import 'news_model.dart';


class NewsRepository {
  Future<List<News>> fetchNews({required int page, required int pageSize}) async {
    final jsonStr = await rootBundle.loadString('assets/fakedb.json');
    final jsonData = jsonDecode(jsonStr);

  // Aqui, nós extraímos a lista de notícias da chave 'news'
  final List<dynamic> jsonArr = jsonData['news'];


    // Simula a paginação, dividindo a lista de notícias em páginas
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    final int jsonArrLength = jsonArr.length;
    final int end = endIndex < jsonArrLength ? endIndex : jsonArrLength;
    final paginatedJsonArr = jsonArr.sublist(startIndex, end);
    return paginatedJsonArr.map((json) => News.fromJson(json)).toList();
  }
}