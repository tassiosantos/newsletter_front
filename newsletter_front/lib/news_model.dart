class News {
  final String title;
  final String imagePath;
  final String summary;
  final String content;

  News({required this.title, required this.imagePath, required this.summary, required this.content});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'],
      imagePath: json['imagePath'],
      summary: json['summary'],
      content: json['content'],
    );
  }
}