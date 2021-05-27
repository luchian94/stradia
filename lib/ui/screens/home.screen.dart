import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STRADIA'),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                size: 34.0,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160.0,
              child: ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('START'),
                    Icon(Icons.play_arrow),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 160.0,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('STOP'),
                    Icon(Icons.stop),
                  ],
                ),
              ),
            ),
            Container(
              width: 300,
              height: 300,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
