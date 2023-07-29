import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'Todo_List.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() => runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: add_page(),
    ));

class postapi extends StatefulWidget {
  const postapi({super.key});

  @override
  State<postapi> createState() => _postapiState();
}

class _postapiState extends State<postapi> {
  TextEditingController namecontroler = TextEditingController();
  TextEditingController phonecontroler = TextEditingController();
  TextEditingController passwordcontroler = TextEditingController();
  TextEditingController agecontroler = TextEditingController();
  TextEditingController emailcontroler = TextEditingController();
  bool isloding = false;
  File? image;

  Future<void> imagepicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedimage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      image = File(pickedimage.path);
    } else {
      print('no image');
    }
  }

  Future<void> uploadimage(File imagefile) async {
    if (imagefile == null) return;
    final uri = Uri.parse('https://h2o.itlifee.net/api/postdata');
    final request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('image', imagefile.path));

    final responce = await request.send();
    if (responce.statusCode == 200) {
      // Image successfully uploaded
      print('Image uploaded successfully.');
    } else {
      // Error uploading image
      print('Error uploading image: ${responce.reasonPhrase}');
    }
  }

  Future<void> submitdata() async {
    //Get the data from
    setState(() {
      isloding = true;
    });

    final body = {
      "name": namecontroler.text,
      "phone": phonecontroler.text,
      "password": passwordcontroler.text,
      "age": agecontroler.text,
      "email": emailcontroler.text,
    };
    final responce = await http.post(
        Uri.parse('https://h2o.itlifee.net/api/postdata'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    if (responce.statusCode == 201) {
      namecontroler.text = '';
      phonecontroler.text = '';
      passwordcontroler.text = '';
      agecontroler.text = '';
      emailcontroler.text = '';
    } else {
      Get.snackbar('Good', 'Success');
      print(responce.body);
    }
    Get.snackbar('Error', 'Oh Hey!!');
    setState(() {
      isloding = false;
    }); //submit data to the server
    // show scuccess fail message
  }

// onesignal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                width: 200,
              ),
              GestureDetector(
                onTap: () => imagepicker(),
                child: image == null
                    ? Text('No image selected.')
                    : Image.file(image!),
              ),
              SizedBox(
                height: 30,
              ),
              Text('Upload Image '),
              reuseable(title: 'name', maincontroler: namecontroler),
              SizedBox(height: 20),
              reuseable(title: 'phone', maincontroler: phonecontroler),
              SizedBox(height: 20),
              reuseable(title: 'age', maincontroler: agecontroler),
              SizedBox(height: 20),
              reuseable(title: 'passord', maincontroler: passwordcontroler),
              SizedBox(height: 20),
              reuseable(title: 'email', maincontroler: emailcontroler),
              SizedBox(
                height: 20,
              ),
              isloding
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          submitdata();
                          uploadimage(image!);
                        });
                      },
                      child: Text('post')),
              ElevatedButton(
                  onPressed: () {
                    Get.to(showpage());
                  },
                  child: Text('show data'))
            ],
          ),
        ),
      ),
    );
  }
}

class reuseable extends StatelessWidget {
  reuseable(
      {super.key,
      required this.title,
      required this.maincontroler,
      this.hint_style,
      this.lab_style,
      this.type_keybord});
  String title;
  var type_keybord;
  var lab_style;
  var hint_style;
  TextEditingController maincontroler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: type_keybord,
      controller: maincontroler,
      decoration: InputDecoration(
          labelStyle: lab_style,
          hintText: hint_style,
          isDense: true,
          label: Text(title),
          border: OutlineInputBorder()),
    );
  }
}

class showpage extends StatefulWidget {
  const showpage({super.key});

  @override
  State<showpage> createState() => _showpageState();
}

class _showpageState extends State<showpage> {
  List dataproduct = [];

  bool isloding = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getapi();
  }

  void getapi() async {
    // var token =
    //     'b594b70650ea6c5757d58096d75d9e5cf6a55ad7c84c2ab070b3f2e4f238053a';
    // var headers = {
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer $token'
    // };
    final responce = await http.get(
      Uri.parse('https://h2o.itlifee.net/api/getdata'),
    );
    final data = jsonDecode(responce.body);
    final result = data['data'] as List;
    if (responce.statusCode == 200) {
      setState(() {
        dataproduct = result;
      });
    }
  }

  // final String url = 'https://h2o.itlifee.net/api/deletedata/';

  void deletedata(String id) async {
    var token =
        'b594b70650ea6c5757d58096d75d9e5cf6a55ad7c84c2ab070b3f2e4f238053a';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final responce = await http.delete(
        Uri.parse('https://h2o.itlifee.net/api/deletedata/$id'),
        headers: headers);
    // final data = jsonDecode(responce.body);
    final data = jsonDecode(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        dataproduct = data;
      });
    }
  }

  TextEditingController namecontroler = TextEditingController();
  TextEditingController phonecontroler = TextEditingController();
  TextEditingController passwordcontroler = TextEditingController();
  TextEditingController agecontroler = TextEditingController();
  TextEditingController emailcontroler = TextEditingController();
  Future<void> Editdata(String id) async {
    //Get the data from
    setState(() {
      isloding = true;
    });

    final body = {
      "name": namecontroler.text,
      "phone": phonecontroler.text,
      "password": passwordcontroler.text,
      "age": agecontroler.text,
      "email": emailcontroler.text,
    };
    final responce = await http.put(
        Uri.parse('https://h2o.itlifee.net/api/updatedata/$id'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    if (responce.statusCode == 201) {
      namecontroler.text = '';
      phonecontroler.text = '';
      passwordcontroler.text = '';
      agecontroler.text = '';
      emailcontroler.text = '';
    } else {
      Get.snackbar('Good', 'Success');
      print(responce.body);
    }
    Get.snackbar('Error', 'Oh Hey!!');
    setState(() {
      isloding = false;
    }); //submit data to the server
    // show scuccess fail message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: dataproduct.length,
            itemBuilder: ((context, index) => ExpansionTile(
                  title: Text('data'),
                  children: [
                    Image.network(dataproduct[index]['image']),
                    Text(dataproduct[index]['name']),
                    Text(dataproduct[index]['phone']),
                    Text(dataproduct[index]['password']),
                    Text(dataproduct[index]['email']),
                    ElevatedButton(
                        onPressed: () {
                          deletedata(dataproduct[index]['id'].toString());
                        },
                        child: Text('delete')),
                    ElevatedButton(
                        onPressed: () {
                          showBottomSheet(
                              context: context,
                              builder: ((context) => Container(
                                    height: 500,
                                    child: Column(
                                      children: [
                                        reuseable(
                                            title: 'name',
                                            maincontroler: namecontroler),
                                        reuseable(
                                            title: 'age',
                                            maincontroler: agecontroler),
                                        reuseable(
                                            title: 'email',
                                            maincontroler: emailcontroler),
                                        reuseable(
                                            title: 'password',
                                            maincontroler: passwordcontroler),
                                        ElevatedButton(
                                            onPressed: () {
                                              Editdata(dataproduct[index]['id']
                                                  .toString());
                                            },
                                            child: Text('update data'))
                                      ],
                                    ),
                                  )));
                        },
                        child: Text('update')),
                  ],
                ))));
  }
}
