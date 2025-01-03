import 'package:flutter/material.dart';
import 'package:local_storage_sqflite/services/local_storage_sqflite_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final LocalStorageSqfliteService _localStorageSqfliteService =
      LocalStorageSqfliteService.instance;

  String? _task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _localStorageSqfliteService.read(),
        builder: (bCtx, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemBuilder: (bCtx, i) {
                return ListTile(
                  title: Text(snap.data![i].toString()),
                  trailing: IconButton(
                    onPressed: () {
                      _localStorageSqfliteService.update(i + 1);
                      setState(() {});
                    },
                    icon: Icon(Icons.menu),
                  ),
                );
              },
              itemCount: snap.data?.length,
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Add Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    _task = value;
                  });
                },
              ),
              TextButton(
                onPressed: () {
                  if (_task == null || _task!.isEmpty) {
                    return;
                  }
                  _localStorageSqfliteService.write(content: _task!);
                  setState(() {
                    _task = null;
                  });
                  Navigator.of(context).pop();
                },
                child: Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }
}
