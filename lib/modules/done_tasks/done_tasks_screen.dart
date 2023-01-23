import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class DoneTaskScreen extends StatefulWidget {
  const DoneTaskScreen({Key? key}) : super(key: key);

  @override
  State<DoneTaskScreen> createState() => _DoneTaskScreenState();
}
class _DoneTaskScreenState extends State<DoneTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state){},
      builder: (context,state){
        var tasks = AppCubit.get(context).doneTasks;
        return tasksBuilder(tasks);
      },
    );
  }
}
