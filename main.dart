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

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Rhymer'),
            surfaceTintColor: Colors.transparent,
            pinned: true,
            snap: true,
            floating: true,
            bottom: PreferredSize(
              child: SearchButton(), //extract widget
              preferredSize: Size.fromHeight(70),
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
                  return BaseContainer(
                    width: 200,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Слово', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
                        Wrap(
                          children: [
                            Text('Рифма'),
                            Text('Рифма'),
                            Text('Рифма'),
                            Text('Рифма'),
                          ].map((e) => Padding( //вся конструкция мап с ту лист для добавления  padding между рифмами
                            padding: EdgeInsets.only(right: 4),
                            child: e,
                            ))
                            .toList(),
                        )
                      ],
                    ),
                  );},
              ),
            )
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverList.builder(
            itemBuilder: (context, index) => const RhymeListCard()
          ) //extract widget
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: () {},
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