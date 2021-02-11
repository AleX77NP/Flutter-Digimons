import 'package:flutter/material.dart';
import 'package:digimon_world/models/digimon.dart';

class Detail extends StatelessWidget {

  Digimon digimon;

  Detail({this.digimon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Detail View", style: TextStyle(
          color: Colors.black
        ),),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Hero(tag: 'img-${digimon.name}',child: Image.network(digimon.img, height: 180.0,)),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(digimon.name.toUpperCase(), style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                letterSpacing: 1.5
              ),),
            ),
            Text(digimon.level, style: TextStyle(
              letterSpacing: 1.5,
              fontSize: 12.0
            ))
          ],
        ),
      ),
    );
  }
}
