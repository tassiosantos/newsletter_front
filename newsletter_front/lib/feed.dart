import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'news_model.dart';
import 'news_repository.dart';
import 'noticia.dart';
import 'main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedViewModel(),
      child: const FeedView(),
    );
  }
}

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  FeedViewState createState() => FeedViewState();
}


class FeedViewState extends State<FeedView> {  
  final scrollController = ScrollController();
  late final FeedViewModel viewModel;
  bool isLoadingMore = false;
  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<FeedViewModel>(context, listen: false);
    viewModel.fetchNews(1).then((news) {
      viewModel.currentPage += 1;
      if (mounted) {
        viewModel.addNews(news);
      }
    }).catchError((error) {
    });
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notícias nossas de cada dia.'),
        actions: [
          IconButton(
            icon: Icon(viewModel.themeIcon),
            onPressed: () => viewModel.toggleTheme(context),
          ),
        ],
      ),
      body: buildNewsList(context),
    );
  }

  Widget buildNewsList(BuildContext context) {
    final viewModel = Provider.of<FeedViewModel>(context);
    return SmartRefresher(
      controller: refreshController,
      onRefresh: onRefresh,
      child: GridView.builder(
        controller: scrollController,
        itemCount: viewModel.newsList.length + (isLoadingMore ? 1 : 0),
        
        itemBuilder: (context, index) {
          if (index == viewModel.newsList.length && isLoadingMore) {
            // Exibe o indicador de progresso no final da lista
            return const Center(child: CircularProgressIndicator());
          }

          final news = viewModel.newsList[index];
          return GestureDetector(
                onTap: () => onNewsTap(context, news),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.memory(
                              
                              news.image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          news.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          news.summary,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
        }, 
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.2 / 1,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            )
      ),
    );
  }

    //gerencia o scroll da página
    void onScroll() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        loadMoreNews();
      }
    }

    //Carrega novas notícias no feed
    Future<void> loadMoreNews() async {
      setState(() {
        isLoadingMore = true;
      });

      final newNews = await viewModel.fetchNews(viewModel.currentPage);
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
        //Se ainda tiver novas notícias, adiciona no feed
        if (newNews.isNotEmpty) {
          await Future.delayed(const Duration(microseconds: 500));
          viewModel.addNews(newNews);
          viewModel.currentPage += 1;   
        }
      }      
      
    }

    //Gerencia a aplicação quando o usuário faz um refresh
    Future<void> onRefresh() async {
      viewModel.currentPage = 1;
      final newNews = await viewModel.fetchNews(viewModel.currentPage);

      if (context.mounted) {
        viewModel.replaceNews(newNews);
        //isLoadingMore = true;
        refreshController.refreshCompleted();
      }
    }

    //Abre a página da notícia que foi clicada
    void onNewsTap(BuildContext context, News news) {
      Navigator.push(
      context,
        MaterialPageRoute(
          builder: (context) => Noticia(news: news),
          ),
      );
    }
}


//Classe para gerenciar o feed.
class FeedViewModel with ChangeNotifier {

      IconData themeIcon = Icons.light_mode;
      bool isLightTheme = true;
      bool hasMoreNews = true;

      final newsRepository = NewsRepository();
      List<News> newsList = [];
      int currentPage = 1;
      final int pageSize = 5;



      //Busca novas notícias na lista de notícias
      Future<List<News>> fetchNews(int page) async {
        final news = await newsRepository.fetchNews(
          page: page, pageSize: pageSize);
          if (news.length < pageSize) {
            hasMoreNews = false;
          }
        return news;
      }

      //Adiciona notícias na lista de notícias
      void addNews(List<News> newNews) {
        newsList.addAll(newNews);
        notifyListeners();
      }

      //recria a lista de notícias
      void replaceNews(List<News> newNews) {
        newsList = newNews;
        notifyListeners();
      }

      //Reseta a para a página 1
      void resetCurrentPage() {
        currentPage = 1;
        notifyListeners();
      }


      //Muda o tema de dark para light
      void toggleTheme(BuildContext context) {
          isLightTheme = !isLightTheme;
          themeIcon = isLightTheme ? Icons.light_mode : Icons.dark_mode;
          Provider.of<ThemeChanger>(context, listen: false)
              .setTheme(isLightTheme ? ThemeData.light() : ThemeData.dark());
          notifyListeners();
        }


}
