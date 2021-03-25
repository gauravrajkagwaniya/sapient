import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo/model/local.dart';
import 'package:todo/utils/pref.dart';
import 'package:todo/utils/styles.dart';

class LocalTodo extends StatefulWidget {
  @override
  _LocalTodoState createState() => _LocalTodoState();
}

class _LocalTodoState extends State<LocalTodo> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  final myTodoController = TextEditingController();
  Local localData = Local();

  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    load();

    // TODO: implement initState
    super.initState();
  }
@override
  void didChangeDependencies() {
    load();
    for(var i = 0 ; i < localData.todo.length ; i++)
      {
        print('&&&&&&&&&&&&&& ${localData.todo[i]}');
      }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    myTodoController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  load() async {
    String json = await Pref().getValueByKey(Pref().eventsKey);
    if (json != null) {
      localData = Local.fromJson(jsonDecode(json));
      print('shared prefs loading data ${jsonDecode(json)}');
    }
  }

  save() async {
    if (localData.todo != null && localData.todo.isNotEmpty) {
      load();
      localData.todo.add( myTodoController.text);
    } else {
      localData.todo = ['swipe down to add todo'];
      localData.todo.add( myTodoController.text);
    }
    print('in map');
    Map value = localData.toJson();
    print('shared prefs saving data ${jsonEncode(value)}');
    await Pref().setValueByKey(Pref().eventsKey, jsonEncode(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Local Todo App',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await refreshList();
        },
        child: ReorderableListView.builder(
          onReorder: (int index, int targetPosition) {
            print(index.toString() + " -> " + targetPosition.toString());
          },
          itemCount: localData.todo.length ?? 0,
          itemBuilder: (context, index) {
            return Dismissible(
                key: Key(index.toString()),
                onDismissed: (direction) {
                },
                background: deleteBg(),
                child: ListTile(
                  title: Text(localData.todo[index]),
                ));
          },
        ),
      ),
    );
  }

  Widget deleteBg() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.auto_delete,
        color: Colors.white,
      ),
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    addInitailTodo();
    return null;
  }

  addInitailTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10,
          title: Text('Add Todo'),
          titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          content: TextField(
            controller: myTodoController,
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * .90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.call_made_rounded,
                          color: Colors.green,
                        ),
                      ),
                      onTap: () {
                        save();
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
