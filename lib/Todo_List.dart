import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'todo_page.dart';
// import 'modal.dart';

class add_page extends StatefulWidget {
  const add_page({
    super.key,
  });

  @override
  State<add_page> createState() => _add_pageState();
}

class _add_pageState extends State<add_page> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  bool isloding = false;
  List getapi = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 86, 85, 85),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 86, 85, 85),
        title: Center(child: Text('Todo List')),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.teal,
          onPressed: navigatepage,
          label: Text('add text')),
      body: Visibility(
        visible: isloding,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: getdata,
          child: Visibility(
            visible: getapi.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo Item',
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.white),
              ),
            ),
            child: ListView.builder(
                itemCount: getapi.length,
                itemBuilder: ((context, index) {
                  final item = getapi[index] as Map;
                  final id = item['_id'] as String;
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == 'edit') {
                        NavigateEdit(item);
                      } else if (value == 'delete') {
                        delete(id);
                        setState(() {
                          isloding = false;
                        });
                      }
                    }, itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text('delete'),
                          value: 'delete',
                        ),
                      ];
                    }),
                  );
                })),
          ),
        ),
      ),
    );
  }

  Future<void> NavigateEdit(Map item) async {
    final route =
        MaterialPageRoute(builder: ((context) => Todo_Page(Editing: item)));
    await Navigator.push(context, route);

    setState(() {
      isloding = true;
    });
    getdata();
  }

  Future<void> navigatepage() async {
    final route = MaterialPageRoute(builder: ((context) => Todo_Page()));
    await Navigator.push(context, route);
    setState(() {
      isloding = true;
    });
    getdata();
  }

  // delete
  Future<void> delete(String id) async {
    final responce =
        await http.delete(Uri.parse('https://api.nstack.in/v1/todos/$id'));
    if (responce.statusCode == 200) {
      final filter = getapi.where((element) => element['_id'] != id).toList();
      setState(() {
        getapi = filter;
      });
    } else {}
  }
  // get data

  Future<void> getdata() async {
    var responce = await http
        .get(Uri.parse('https://api.nstack.in/v1/todos?page=1&limit=10'));
    if (responce.statusCode == 200) {
      final data = jsonDecode(responce.body) as Map;
      final result = data['items'] as List;
      setState(() {
        getapi = result;
      });
    } else {}
    setState(() {
      isloding = false;
    });
  }
}
