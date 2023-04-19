// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'feed.dart';
// import 'news_model.dart';
// import 'news_repository.dart';

// class FeedView extends StatefulWidget {
//   @override
//   FeedViewState createState() => FeedViewState();
// }

// class FeedViewState extends State<FeedView> {
//   final scrollController = ScrollController();
//   late final FeedViewModel viewModel;
//   bool isLoadingMore = false;

//   @override
//   void initState() {
//     super.initState();
//     viewModel = Provider.of<FeedViewModel>(context, listen: false);
//     scrollController.addListener(onScroll);
//   }

//   @override
//   void dispose() {
//     scrollController.removeListener(onScroll);
//     scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Feed de Notícias'),
//         actions: [
//           IconButton(
//             icon: Icon(viewModel.themeIcon),
//             onPressed: () => viewModel.toggleTheme(context),
//           ),
//         ],
//       ),
//       body: buildNewsList(context),
//     );
//   }

//   Widget buildNewsList(BuildContext context) {
//     final viewModel = Provider.of<FeedViewModel>(context);
//     return ListView.builder(
//       controller: scrollController,
//       itemCount: viewModel.newsList.length + (isLoadingMore ? 1 : 0),
//       itemBuilder: (context, index) {
//         if (index == viewModel.newsList.length) {
//           // Exibe o indicador de progresso no final da lista
//           return Center(child: CircularProgressIndicator());
//         }

//         final news = viewModel.newsList[index];
//         return ListTile(
//           title: Text(news.title),
//           leading: Image.asset('assets/images/${news.imagePath}'),
//           subtitle: Text(news.summary),
//           onTap: () => onNewsTap(context, news),
//         );
//       },
//     );
//   }

//   // ...

//   void onScroll() {
//     if (scrollController.position.pixels ==
//             scrollController.position.maxScrollExtent &&
//         !isLoadingMore) {
//       loadMoreNews();
//     }
//   }

//   Future<void> loadMoreNews() async {
//     setState(() {
//       isLoadingMore = true;
//     });

//     final newNews = await viewModel.fetchNews();
//     if (mounted) {
//       setState(() {
//         isLoadingMore = false;
//       });

//       if (newNews.isNotEmpty) {
//         viewModel.addNews(newNews);
//       }
//     }
//   }
// }

// class FeedViewModel with ChangeNotifier {
//   // ...

//   final _newsRepository = NewsRepository();
//   List<News> newsList = [];
//   int _currentPage = 1;
//   final int _pageSize = 5;

//   // ...

//   Future<List<News>> fetchNews() async {
//     final news = await _newsRepository.fetchNews(page: _currentPage, pageSize: _pageSize);
//     _currentPage += 1;
//     return news;
//   }

//   void addNews(List<News> newNews) {
//     newsList.addAll(newNews);
//     notifyListeners();
//   }
// }
