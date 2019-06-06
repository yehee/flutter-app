import 'package:flutter/material.dart';
import 'package:flutter_tags/selectable_tags.dart';
import 'routes.dart';

enum Choice {
  Settings, Sound, Logout
}

int _id = 0;
List<Choice> _choices = [Choice.Logout, Choice.Settings, Choice.Sound];

List<PopupMenuItem<Choice>> popupMenuItems() => _choices.map((choice) { return PopupMenuItem<Choice>(value: choice, child: Text(choice.toString().split('.').last),);}).toList();
void choiceAction(Choice choice) => print(choice.toString().split('.').last);
PopupMenuButton<Choice> popupMenuButton() => PopupMenuButton<Choice>(onSelected: choiceAction, itemBuilder: (BuildContext context) { return popupMenuItems(); },);

class Item extends Comparable {
  int id;
  String title;
  bool active;
  List<String> tags = [];

  Item(this.title) {
    this.id = _id++;
    this.active = true;
  }

  void addTag(String tag) {
    tags.add(tag);
  }

  bool containsTag(String tag) {
    return tags.contains(tag);
  }

  bool isActive(List<Tag> activeTags) {
    return activeTags.any((tag) => tags.contains(tag.title));
  }

  @override
  int compareTo(other) {
    return int.parse(this.title).compareTo(int.parse(other.title));
  }
}

class LevelsPage extends StatefulWidget {
  LevelsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LevelsPageState createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          popupMenuButton(),
        ],
      ),
      body: Container(
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 30.0),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    onPressed: () {
                      //TODO: implement behavior
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.airport_shuttle),
                        Text("K-8"),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(2.5)),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    onPressed: () {
                      //TODO: implement behavior
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.airport_shuttle),
                        Text("9-12"),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(2.5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    onPressed: () {
                      //TODO: implement behavior
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.airport_shuttle),
                        Text("SAT"),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(2.5)),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    onPressed: () {
                      //TODO: implement behavior
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.airport_shuttle),
                        Text("Univ"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class BrowsePage extends StatefulWidget {
  BrowsePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
//  List<Choice> _choices     = [Choice.Logout, Choice.Settings, Choice.Sound];
  List<Item>     items       = [];
  List<Item>     activeItems = [];
  List<Tag>      tags        = [];

  TextEditingController controller = TextEditingController();
  String filter;
  double _separatorHeight = 100.0;

  InkWell _inkWell(Card card) {
    return InkWell(onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => ProblemRoute())); }, child: card);
  }

  Card _card(int index) {
    return Card(child: Padding(padding: const EdgeInsets.all(16.0), child: Text(activeItems[index].title)));
  }

  Card _separator(int index) {
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(5.0),
              child: InkWell(
                splashColor: Colors.pinkAccent,
                highlightColor: Colors.pink,
                child: Container(
                  alignment: AlignmentDirectional.center,
//                  child: Text(activeItems[index].title, textAlign: TextAlign.center,),
                  child: Hero(
                      tag: "Tag $index",
                      child: Icon(Icons.mail, size: 50.0,)
                  ),
                  height: _separatorHeight,
                ),
                onTap: (){ print(index); Navigator.push(context, MaterialPageRoute(builder: (context) => ProblemRoute())); },
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(2.5),),
          Expanded(
            child: Material(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(5.0),
              child: InkWell(
                splashColor: Colors.pinkAccent,
                highlightColor: Colors.pink,
                child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Text(activeItems[index].title, textAlign: TextAlign.center,),
                  height: _separatorHeight,
                ),
                onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => ProblemRoute())); },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _contains(int index) {
    return filter == null || filter == "" || activeItems[index].title.toLowerCase().contains(filter.toLowerCase());
  }

  List<Tag> _getActiveTags() {
    return tags.where((tag) => tag.active).toList();
  }

  List<Tag> _getDisableTags() {
    return tags.where((tag) => !tag.active).toList();
  }

//  void choiceAction(Choice choice) {
//    print(choice.toString().substring(9));
//  }

  void updateActiveItems() {
    activeItems = items.where((item) => item.isActive(_getActiveTags())).toList();
    activeItems.sort();
    setState(() { });
  }

  @override
  initState() {
    super.initState();

    for (int i = 1; i <= 20; i++) {
      Item item = Item(i.toString());
      item.addTag(i % 2 == 0 ? "even" : "odd");
      item.addTag(i % 3 == 0 ? "integration" : "differentiation");
      items.add(item);
    }

    tags.add(Tag(id: 0, title: "even", active: false));
    tags.add(Tag(id: 1, title: "odd",  active: false));
    tags.add(Tag(id: 2, title: "differentiation",  active: false));
    tags.add(Tag(id: 3, title: "integration",  active: false));
    tags.add(Tag(id: 4, title: "algebra",  active: false));

    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          popupMenuButton(),
        ],
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: "Search something",
                  prefixIcon: Icon(Icons.search),
                ),
                controller: controller,
              ),
              Container(
                child: SelectableTags(
                  activeColor: Colors.blueAccent,
                  tags: tags,
                  onPressed: (tag) { updateActiveItems(); },
                ),
              ),
              ListView.separated(
                itemCount: activeItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return _contains(index) ? _inkWell(_card(index)) : Container();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return (index + 1) % 4 == 0 ? _separator(index) : Container();
                },
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(0.0),
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

}