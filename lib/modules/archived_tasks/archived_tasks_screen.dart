import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ArchivedTaskScreen extends StatefulWidget {
  const ArchivedTaskScreen({Key? key}) : super(key: key);

  @override
  State<ArchivedTaskScreen> createState() => _ArchivedTaskScreenState();
}
class _ArchivedTaskScreenState extends State<ArchivedTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state){},
      builder: (context,state){
        var tasks = AppCubit.get(context).archivedTasks;
        return tasksBuilder(tasks);
      },
    );
  }
}
