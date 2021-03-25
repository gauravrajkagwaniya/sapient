import 'package:flutter/material.dart';
import 'package:todo/utils/styles.dart';

import 'cloud/cloud_list.dart';
import 'local/local_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Styles.initialgrad, Styles.finalgred]),
            backgroundBlendMode: BlendMode.darken),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Hello There.. '),

            /// local todo list shuold be save in Shared prefs
            OutlineButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocalTodo(),
                      ));
                },
                child: Text('Local Saved Todo')),

            /// Cloud Todo list Saving in firebase cloud
            OutlineButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CloudTodo(),
                      ));
                },
                child: Text('Cloud Saved Todo')),
          ],
        ),
      ),
    );
  }
}
