import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('aucun composant pour $selectedIndex');
    }
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem (
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;  

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Une idée aléatoire :'),
          BigCard(pair: pair),
          SizedBox(height: 10.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ↓ Ajoutez ces 2 composants
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text("J'aime"),
              ),
              SizedBox(width: 10),

              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Suivant'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context); 
    var style = theme.textTheme.displayMedium!.copyWith(
    color: theme.colorScheme.onPrimary,
  );
    return Card(
      
      color: theme.colorScheme.primary,  
      
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asPascalCase, 
          style: style,
          semanticsLabel: pair.asPascalCase
        ),
      ),
    );
  }
}



class FavoritesPage extends StatelessWidget{
  @override
  
  Widget build(BuildContext context ){
    var appState = context.watch<MyAppState>();
    
    return Column(
        children: [
          Expanded(
              child: ListView(
                
                children: [
                  Center(child: Text('Favoris : ')),
                  for (var favs in appState.favorites)
                    Center(child: SmallCard(favs: favs)),
                ],
              ),
          ),
        ],
    );
  }
}

class SmallCard extends StatelessWidget {
  const SmallCard({
    super.key,
    required this.favs,
  });

  final WordPair favs;

  @override
  
  Widget build(BuildContext context) {
    var theme = Theme.of(context); 
    var style = theme.textTheme.displaySmall!.copyWith(
    color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,  
      
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(favs.asPascalCase,
          style: style,
        ),
      ),
    );
  }
}