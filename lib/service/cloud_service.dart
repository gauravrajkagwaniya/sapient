import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/cloud.dart';
import 'package:todo/utils/global.dart';

class CloudService {
final  todoId;
  /// todoList collection reference
  final CollectionReference toDoListCollection = fireStore.collection('todoList');

  CloudService(this.todoId);

  Future<void> toDoListToCloud(String todo) async {
    await fireStore
        .collection('todoList').doc(todo)
        .set({
      'todo': todo,

    });

  }
  Future<void> DoneListToCloud(String todo) async {
    await fireStore
        .collection('doneList').doc(todo)
        .set({
      'todo': todo,

    });

  }

  /// todo  list from Snapshot
Cloud _cloudDataFromSnapshot(DocumentSnapshot snapshot){
    return Cloud(
      todo: snapshot.data()['todo']
    );

}

  List<Cloud> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return Cloud(
        todo: e.data()['todo'],
      );
    }).toList();
  }

  /// get todolist Stream
  Stream<List<Cloud>> get cloud {
    return toDoListCollection.snapshots().map(_todoListFromSnapshot);
  }

   Stream<Cloud>get cloud1{

    return toDoListCollection.doc(toDoListCollection.id).snapshots().map(_cloudDataFromSnapshot);
   }
  deleteTodo(context) async => await fireStore
      .collection('todoList')
      .doc(todoId)
      .delete()
      .then((value) => Navigator.pop(context));
}
