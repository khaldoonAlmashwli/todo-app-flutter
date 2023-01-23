import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void ChangeIndex(index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  void createDatebase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print("database created");
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT )')
            .then((value) {
          print("table created");
        }).catchError((onError) {
          print('Errorr when Creating Table ${onError.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('onOpen Function in createDatebase');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status ) VALUES ("$title","$date","$time","new" )')
          .then((value) {
        getDataFromDatabase(database);
        emit(AppInsertDatabaseState());
        print("$value inserted successfuly ");
      }).catchError((onError) {
        print("Errorr when inserting New Record ${onError.toString()}");
      });
    });
  }

  void getDataFromDatabase(database) {
    // emit(state);
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void updateDataFromDatabase({
    required String status,
    required int id,
  }) async {
    await database?.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
      print('updated: $value');
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
