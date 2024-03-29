import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFFF82B10);
    return MaterialApp(
      title: 'Flutter Demo',
      //конструктор
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Color(0xFFEFF1F3),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(), //extract widget
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var _selectedPageIndex = 0;
  final _pageController = PageController(); //для переключения между страницами

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() => _selectedPageIndex = value);
        },
        children: [
          SearchScreen(),
          Scaffold(),
          Scaffold(),
          Scaffold()
        ],
      ), 
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.hintColor,
        currentIndex: _selectedPageIndex,
        onTap: _openPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Поиск'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Стихи'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
        ],
      ),
    );
  }

  void _openPage(int index) {
    setState(() => _selectedPageIndex = index);
    _pageController.animateToPage(
      index, 
      duration: Duration(microseconds: 300),
      curve: Curves.linear
    ); //или обычный метод jumpToPage(index)
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Rhymer'),
          surfaceTintColor: Colors.transparent,
          pinned: true,
          snap: true,
          floating: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: SearchButton(), //extract widget
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)), //расстояние между апбаром и сливерлистом
        SliverToBoxAdapter(
          child: 
          SizedBox(
            height: 100,
            child: ListView.separated(  //помимо ListView.builder есть ListView.separated. он позволяет добавить разделители с помощью separatorBuilder
              padding: const EdgeInsets.only(left: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              separatorBuilder: (context, index) => const SizedBox(width: 16,),
              itemBuilder: (context, index) {
                final rhymes = List.generate(4, (index) => 'Рифма $index');
                return RhymeHistoryCard(rhymes: rhymes);},
            ),
          )
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverList.builder(
          itemBuilder: (context, index) => const RhymeListCard()
        ) //extract widget
      ],
    );
  }
}

class RhymeHistoryCard extends StatelessWidget {
  const RhymeHistoryCard({
    super.key,
    required this.rhymes,
  });

  final List<String> rhymes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BaseContainer(
      width: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Слово', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
          Wrap(
            children: rhymes.map((e) => Padding( //вся конструкция мап с ту лист для добавления  padding между рифмами
              padding: EdgeInsets.only(right: 4),
              child: Text(e),
              ))
              .toList(),
          )
        ],
      ),
    );
  }
}

class BaseContainer extends StatelessWidget {
  const BaseContainer({
    super.key, 
    required this.child, 
    required this.width, 
    this.margin, //если свойство не нужно везде задавать
    this.padding = const EdgeInsets.only(left: 12),
  });

  final double width;
  final Widget child;
  final EdgeInsets? margin; //если свойство не нужно везде задавать
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12)
      ),
      child: child,);
  }
}

class RhymeListCard extends StatelessWidget {
  const RhymeListCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BaseContainer(
      margin: EdgeInsets.symmetric(horizontal: 16)
        .copyWith(bottom: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Рифма', 
            style: theme.textTheme.bodyMedium
          ),
          IconButton(onPressed: () {}, icon: Icon(
            Icons.favorite,
            color: theme.hintColor.withOpacity(0.3)
          ))
        ],
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity, //во всю ширину
      margin: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.hintColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[700],),
          SizedBox(width: 8,),
          Text(
            'Поиск рифм...', 
            style: TextStyle(
              fontSize: 16,
              color: theme.hintColor.withOpacity(0.5),
              fontWeight: FontWeight.w400
            ),
          ),
        ],
      )
    );
  }
}
