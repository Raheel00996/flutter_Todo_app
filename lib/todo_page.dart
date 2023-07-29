import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Todo_Page extends StatefulWidget {
  final Map? Editing;
  const Todo_Page({super.key, this.Editing});

  @override
  State<Todo_Page> createState() => _Todo_PageState();
}

class _Todo_PageState extends State<Todo_Page> {
  TextEditingController titlecontroler = TextEditingController();
  TextEditingController descriptioncontroler = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final editing = widget.Editing;
    if (editing != null) {
      isEdit = true;
      final title = editing['title'];
      final descript = editing['description'];
      titlecontroler.text = title;
      descriptioncontroler.text = descript;
    }
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 86, 85, 85),
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 86, 85, 85),
          title: Text(isEdit ? 'Edit Todo' : 'Add Todo')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: titlecontroler,
              decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: descriptioncontroler,
              decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
            SizedBox(
              height: 60,
            ),
            isloading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: isEdit ? Updatedata : submitdata,
                    child: Text(isEdit ? 'Update' : 'Submit'))
          ],
        ),
      ),
    );
  }

  Future<void> Updatedata() async {
    setState(() {
      isloading = true;
    });
    final editing = widget.Editing;
    if (editing == null) {
      print('you canot call update without todo data');
      return;
    }
    final id = editing['_id'];
    final iscompleted = editing['is_completed'];
    final title = titlecontroler.text;
    final descrip = descriptioncontroler.text;
    final body = {
      "title": title,
      "description": descrip,
      "is_completed": iscompleted
    };
    final responce = await http.put(
        Uri.parse('https://api.nstack.in/v1/todos/$id'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});

    if (responce.statusCode == 200) {
      titlecontroler.text = '';
      descriptioncontroler.text = '';
      snakbar('Success!!');
    } else {
      snakbar('Oh Hey!!');
    }
    setState(() {
      isloading = false;
    });
  }

  Future<void> submitdata() async {
    //Get the data from
    setState(() {
      isloading = true;
    });
    final tex = titlecontroler.text;
    final descrip = descriptioncontroler.text;
    final body = {"title": tex, "description": descrip, "is_completed": false};
    final responce = await http.post(
        Uri.parse('https://api.nstack.in/v1/todos'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    if (responce.statusCode == 201) {
      titlecontroler.text = '';
      descriptioncontroler.text = '';
      snakbar('Success!!');
    } else {
      snakbar2('Oh Hey!!');
      print(responce.body);
    }

    setState(() {
      isloading = false;
    }); //submit data to the server
    // show scuccess fail message
  }

  void snakbar(String message) {
    final materialBanner = MaterialBanner(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: message,
        message:
            'This is an example error message that will be shown in the body of materialBanner!',

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.success,
        // to configure for material banner
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);
  }

  void snakbar2(String message) {
    final materialBanner = MaterialBanner(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: message,
        message:
            'This is an example error message that will be shown in the body of materialBanner!',

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.success,
        // to configure for material banner
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);
  }
}
