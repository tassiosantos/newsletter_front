import 'package:flutter/material.dart';
import 'news_model.dart';

class Noticia extends StatelessWidget {
  final News news;

  const Noticia({Key? key, required this.news}) : super(key: key);

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
            Image.memory(news.image!),
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