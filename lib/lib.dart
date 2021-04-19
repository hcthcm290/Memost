import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          titleSection,
          buttonSection,
          textSection,
        ],
      ),
    );
  }
}




Widget titleSection = Container(
  padding: const EdgeInsets.all(32),
  child: Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lonely Mountain', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Text('Lovele mountain where the king live', )
          ],
        )
      ),
      Icon(
        Icons.star,
        color: Colors.red[500],
        size: 30,
      ),
      Text('250', style: TextStyle(fontSize: 25),),
    ],
  ),
);

Widget buttonSection = Container(
  child: 
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildButtonColumn(Colors.blueAccent, Icons.call, "CALL"),
      _buildButtonColumn(Colors.blueAccent, Icons.near_me, "ROUTE"),
      _buildButtonColumn(Colors.blueAccent, Icons.share, "SHARE")
    ],
  ),
);

Column _buildButtonColumn(Color color, IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: color,),
      Container(
        child: Text(label, style: TextStyle(fontWeight: FontWeight.w400, color: color),),
        margin: EdgeInsets.only(top: 8),
      )
    ],
  );
}

Widget textSection = Container(
  padding: EdgeInsets.all(32),
  child: Text(
    'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
        'Alps. Situated 1,578 meters above sea level, it is one of the '
        'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
        'half-hour walk through pastures and pine forest, leads you to the '
        'lake, which warms to 20 degrees Celsius in the summer. Activities '
        'enjoyed here include rowing, and riding the summer toboggan run.',
    softWrap: true,
    style: TextStyle(fontSize: 16),
  ),
);

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final biggerFont = TextStyle(fontSize: 25);

  Widget _buildRow(WordPair s) {
    final _alreadySaved = _saved.contains(s);

    return ListTile(
      title: Text(s.asPascalCase, style: biggerFont,),
      trailing: Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if(_alreadySaved)
            _saved.remove(s);
          else
            _saved.add(s);
        });
      },
    );
  }

  Widget _buildSuggestion() {
    return ListView.builder(
      itemBuilder: (context, i) {
        if(i.isOdd) return Divider();

        final index = i ~/ 2;

        while(index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  void _pushSave() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start up name generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSave)
        ],
      ),

      body: _buildSuggestion(),
    );
  }
}