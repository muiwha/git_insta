import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MaterialApp(
    theme: ThemeData(
      iconTheme: IconThemeData(
        color: Colors.black87
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.amber
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.red),
        bodyText2: TextStyle(color: Colors.red),
      )
    ),
    home: MyApp(),
  ) );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var tab = 0;
  var data=[];

  getData() async{
    var result = await http.get(Uri.parse("https://codingapple1.github.io/app/data.json"));
    print(result.statusCode);
    var result2 = jsonDecode(result.body);
    data = result2;
    setState(() {
      data = result2;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(

                decoration: BoxDecoration(
                  color: Colors.blueGrey
                ),
                child: Text("서랍"),


            ),
            ListTile(
              title: Text("Item 1"),
              onTap: (){
                print("아이템 1 이 눌렸습니다.");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Item 2"),
              onLongPress: (){
                print("아이템2가 눌렸습니다.");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Exit"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Instargram"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined, color: Colors.black,),
            iconSize: 30,
            onPressed: (){print("클릭 아이콘");},
          )
        ],
      ),
      body: [Home(data: data),Text('샵페이지'),Text('플러스페이지')][tab],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i){
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_max_outlined,),

              label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),label:'샵'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined),label:'플러스'),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, this.data}) : super(key: key);
  final data;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scroll.addListener(() {
      print(scroll.position.pixels);
    });
  }


  @override
  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty) {
      return ListView.builder(itemCount: widget.data.length ,controller: scroll,itemBuilder: (c,i){

      return Column(
        children: [
          Image.network(widget.data[i]['image']),
          Text('좋아요 ${widget.data[i]['likes']}'),
          Text(widget.data[i]['date']),
          Text(widget.data[i]['content'])
        ],
      );
    });
    } else  {
      return Text('로딩중');
    }
  }
}
