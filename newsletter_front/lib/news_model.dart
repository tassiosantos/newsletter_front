import 'dart:convert';
import 'dart:typed_data';

class News {
  // final String title;
  // final String imagePath;
  // final String summary;
  // final String content;

  final int id;
  final String title;
  final Uint8List? image; 
  final String summary;
  final String content;

  //News({required this.title, required this.imagePath, required this.summary, required this.content});

  News({
    required this.id,
    required this.title,
    this.image,
    required this.summary,
    required this.content,
  });


  factory News.fromJson(Map<String, dynamic> json) {
  return News(
    id: json['id'],
    title: json['title'],
    summary: json['summary'],
    content: json['content'],
    image: base64Decode(json['image']),
  );
}
}