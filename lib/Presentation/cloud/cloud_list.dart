import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/cloud.dart';
import 'package:todo/service/cloud_service.dart';
import 'package:todo/utils/global.dart';
import 'package:todo/utils/styles.dart';

class CloudTodo extends StatefulWidget {
  @override
  _CloudTodoState createState() => _CloudTodoState();
}

class _CloudTodoState extends State<CloudTodo> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  GlobalKey<ScaffoldState> _scaffoldKey;

  final myTodoController = TextEditingController(text: "");

  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    myTodoController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final cloud = Provider.of<List<Cloud>>(context) ?? [];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Cloud Todo App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await refreshList();
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Styles.initialgrad, Styles.finalgred]),
                backgroundBlendMode: BlendMode.darken),
            child: Column(
              children: [
                Container(
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      'Please pull down to add new todo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 05,),
                StreamBuilder(
                    stream: fireStore.collection('todoList').snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              /*                       onReorder: (int index, int targetPosition) {
                                // if (oldIndex < newIndex) newIndex -= 1;
                                // _docs.insert(newIndex, _docs.removeAt(oldIndex));
                                // final batch = Firestore.instance.batch();
                                // for (int pos = 0; pos < _docs.length; pos++) {
                                //   batch.updateData(_docs[pos].reference,
                                //       {widget.indexKey: pos});
                                // }
                                // batch.commit();
                                print(index.toString() + " -> " + targetPosition.toString());
                              },*/
                              itemCount: snapshot.data.docs.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                DocumentSnapshot todo =
                                    snapshot.data.docs[index];
                                return Dismissible(
                                    key: Key(todo['todo']),
                                    onDismissed: (direction) async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CloudTodo(),
                                          ));
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        await CloudService(todo['todo'])
                                            .deleteTodo(context);
                                        displaySnackBar('todo is deleted');
                                      } else {
                                        displaySnackBar(
                                            'Huuuureyy.... you have done your task');
                                        CloudService(todo['todo'])
                                            .DoneListToCloud(todo['todo']);
                                        await CloudService(todo['todo'])
                                            .deleteTodo(context);
                                      }
                                    },
                                    background: doneBg(),
                                    secondaryBackground: deleteBg(),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: ListTile(
                                        /* leading: Icon(Icons.menu),*/
                                        tileColor: Colors.red[200],
                                        title: Text(todo['todo'],
                                            style:
                                                TextStyle(color: Colors.white)),
                                        trailing: Icon(
                                          Icons.circle,
                                          color: Colors.red[900],
                                        ),
                                      ),
                                    ));
                              },
                            )
                          : Container();
                    }),
                StreamBuilder(
                    stream: fireStore.collection('doneList').snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot todo =
                                    snapshot.data.docs[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ListTile(
                                    tileColor: Colors.grey,
                                    title: Text(
                                      todo['todo'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    trailing: Icon(
                                      Icons.circle,
                                      color: Colors.green[900],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget deleteBg() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.red,
      child: Icon(
        Icons.auto_delete,
        color: Colors.white,
      ),
    );
  }

  Widget doneBg() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.0),
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.green,
      child: Icon(
        Icons.done_outline_outlined,
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
    myTodoController.clear();
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
            onSubmitted: (value) => myTodoController.text,
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
                        CloudService(myTodoController)
                            .toDoListToCloud(myTodoController.text)
                            .whenComplete(() => Navigator.pop(context));
                      }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
