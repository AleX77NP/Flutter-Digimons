import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:digimon_world/models/digimon.dart';
import 'package:digimon_world/pages/detail.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Digimon> digimons;
  PageController _controller;
  bool loading = false;
  List<String> levels = ["In Training", "Champion", "Rookie", "Legendary"];

  Future<http.Response> getDigimons() async {
    setState(() {
      loading = true;
    });
    final response = await http.get('https://digimon-api.vercel.app/api/digimon');
    if(response.statusCode == 200) {
      Iterable it = json.decode(response.body);
      List<Digimon> data = it.map((e) => Digimon.fromJson(e)).toList();
      setState(() {
        digimons = data;
        loading = false;
      });
    } else {
      setState(() {
        digimons = [];
        loading = false;
      });
    }
  }

  _digiSelector(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_controller.position.haveDimensions) {
          value = _controller.page - index;
          value = (1 - (value.abs() * 0.35) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 270.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.red, Colors.deepOrangeAccent]
                    )
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (_) => Detail(digimon: digimons[index])
                              ));
                            },
                            child: Hero(
                              tag: 'img-${digimons[index].name}',
                              child: Image(
                                image: NetworkImage(digimons[index].img),
                                height: 120.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Text(digimons[index].name.toUpperCase()
                            ,style: TextStyle(
                                fontWeight: FontWeight.bold)
                        )
                      ],
                    ),
                  ),
                ),
              ),
              elevation: 4.0,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getDigimons();
    _controller = PageController(initialPage: 1, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image(
          image: AssetImage('assets/images/logo.png'),
          height: 52.0,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.blue[800],),
          padding: EdgeInsets.only(left: 30.0),
          onPressed: () { print('menu');},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.blue[800],),
            padding: EdgeInsets.only(right: 30.0),
            onPressed: () { print('search');},
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: loading ? Center(child: CircularProgressIndicator()) : ListView(
        children: [
          Container(
            height: 280.0,
            padding: EdgeInsets.only(top: 30.0),
            width: double.infinity,
            child: PageView.builder(
                controller: _controller,
                itemCount: digimons.length,
                itemBuilder: (BuildContext context, int index) {
                  return _digiSelector(index);
                }
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: levels.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 200.0,
                    margin: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.tealAccent
                    ),
                    child: ListTile(
                      title: Center(child: Text(levels[index])),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
