import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';


class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatebase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
                condition: true,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator())),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   time: timeController.text,
                    //   date: dateController.text,
                    // ).then((value)
                    // {
                    //   getDataFromDatabase(database).then((value) {
                    //     Navigator.pop(context);
                    //
                    //     // setState((){
                    //     //
                    //     // isBottomSheetShown = false;
                    //     // fabIcon = Icons.edit;
                    //     //
                    //     // tasks = value;
                    //     // print(value);
                    //     //
                    //     // });
                    //   });
                    //
                    // }
                    // );
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(15.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title must be not empty';
                                    }
                                    return null;
                                  },
                                  label: "Title Task",
                                  prefix: Icons.title,
                                ),

                                SizedBox(
                                  height: 15.0,
                                ),
//------------------------Time Text Filed -----------------------------------
                                defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time must be not empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      print(value?.format(context).toString());
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  label: "Task Time",
                                  prefix: Icons.watch_later_outlined,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
//------------------------Date Text Filed -----------------------------------
                                defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date must be not empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-09-30'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(value!);
                                      print(DateFormat('yyyy-MM-dd')
                                          .format(value));
                                    });
                                  },
                                  label: "Task Date",
                                  prefix: Icons.calendar_month_outlined,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
                // var name = await getName();
                // print(name);
                // getName().then((value) {
                //   print(value);
                //   print("value");
                //   throw('انا عملت ايرور!!');
                // }
                // ).catchError((onError){
                //   print('error is  ${onError.toString()}');
                // });
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              //fixedColor: Colors.red,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                // setState(((){
                cubit.ChangeIndex(index);
                // }));
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: "Archived",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String> getName() async {
    return "khaldoon";
  }
}
