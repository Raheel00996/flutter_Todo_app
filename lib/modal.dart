// Future<ProductsModel> getProductsApi() async {

// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class catagorycontroler extends GetxController {
  RxBool loading = false.obs;
  modal? Modaldata;
  @override
  void onInit() {
    // TODO: implement onInit
    getdata();
    super.onInit();
  }

  void getdata() async {
    loading(true);
    final response = await http.get(
        Uri.parse('https://webhook.site/d24f9761-dfba-4759-bcda-f42f3dd539b7'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      Modaldata = modal.fromJson(json.decode(response as String));
    } else {
      Modaldata = modal.fromJson(json.decode(response as String));
    }
    loading(false);
  }
}

class getdata extends StatelessWidget {
  getdata({super.key});
  var getcontrolerdata = Get.put(catagorycontroler());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Obx(() {
        if (getcontrolerdata.loading == true) {
          return CircularProgressIndicator();
        }
        return ListView.builder(
            itemCount: getcontrolerdata.Modaldata != null
                ? getcontrolerdata.Modaldata?.message!.length
                : 0,
            itemBuilder: ((context, index) {
              return Column();
            }));
      })),
    );
  }
}

class modal {
  int? code;
  bool? success;
  int? timestamp;
  String? message;
  List<Items>? items;
  Meta? meta;

  modal(
      {this.code,
      this.success,
      this.timestamp,
      this.message,
      this.items,
      this.meta});

  modal.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    timestamp = json['timestamp'];
    message = json['message'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    data['timestamp'] = this.timestamp;
    data['message'] = this.message;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class Items {
  String? sId;
  String? title;
  String? description;
  bool? isCompleted;
  String? createdAt;
  String? updatedAt;

  Items(
      {this.sId,
      this.title,
      this.description,
      this.isCompleted,
      this.createdAt,
      this.updatedAt});

  Items.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    isCompleted = json['is_completed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['is_completed'] = this.isCompleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Meta {
  int? totalItems;
  int? totalPages;
  int? perPageItem;
  int? currentPage;
  int? pageSize;
  bool? hasMorePage;

  Meta(
      {this.totalItems,
      this.totalPages,
      this.perPageItem,
      this.currentPage,
      this.pageSize,
      this.hasMorePage});

  Meta.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    totalPages = json['total_pages'];
    perPageItem = json['per_page_item'];
    currentPage = json['current_page'];
    pageSize = json['page_size'];
    hasMorePage = json['has_more_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_items'] = this.totalItems;
    data['total_pages'] = this.totalPages;
    data['per_page_item'] = this.perPageItem;
    data['current_page'] = this.currentPage;
    data['page_size'] = this.pageSize;
    data['has_more_page'] = this.hasMorePage;
    return data;
  }
}
