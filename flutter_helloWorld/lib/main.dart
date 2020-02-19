import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(HelloWorldFlutterApp());

class HelloWorldFlutterApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(primaryColor: Colors.amber.shade600,
        textTheme: TextTheme(body1: TextStyle(color: Colors.purple))
      ),
      home: HelloWorldFlutter(),
    );
  }
}

class HelloWorldFlutter extends StatefulWidget{
  @override
  createState() => HelloWorldFlutterState();
}

class HelloWorldFlutterState extends State<HelloWorldFlutter>{
  var _members = <Member>[];
  final _biggerFont = const TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic);

  @override
  void initState(){
    super.initState();
    _loadData();
  }

  Widget _buildRow(int i) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
          title: Text('${_members[i].login}', style: _biggerFont),
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          backgroundImage: NetworkImage(_members[i].avatarUrl),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Flutterxxx"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _members.length * 2,
        itemBuilder: (BuildContext context, int position) {
          if (position.isOdd) return Divider();
          final index = position ~/2;
          return _buildRow(index);
        },
      ),
    );
  }

  _loadData() async {
    String dataURL = "https://api.github.com/orgs/raywenderlich/members";
    http.Response res = await http.get(dataURL);
    setState(() {
      final membersJson = json.decode(res.body);
      for (var memberJson in membersJson) {
        final member = Member(memberJson['login'], memberJson['avatar_url']);
        _members.add(member);
      }

    });
  }

}

class Member {
  final String login;
  final String avatarUrl;

  Member(this.login, this.avatarUrl) {
    if (login == null) {
      throw ArgumentError("login of Member cannot be null. "
          "Received: '$login'");
    }

    if (avatarUrl == null) {
      throw ArgumentError("avatarUrl of Member cannot be null. "
          "Received: '$avatarUrl'");
    }

  }
}