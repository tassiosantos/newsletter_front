import 'package:flutter/material.dart';
import 'news_model.dart';

class Noticia extends StatelessWidget {
  final News news;

  const Noticia({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/imagens/${news.imagePath}'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                news.content,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}