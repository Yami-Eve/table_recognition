import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_recognition/config.dart';
import 'package:table_recognition/main_initialize.dart';
import 'package:table_recognition/recognition_model.dart';
import 'package:table_recognition/table_result.dart';

void main() {
  runApp(MyApp());
  request();
}

void request() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.storage,
  ].request();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('表格识别'),
      ),
      body: MyHomeContent(),
    );
  }
}

class MyHomeContent extends StatefulWidget {
  @override
  _MyHomeContentState createState() => _MyHomeContentState();
}

class _MyHomeContentState extends State<MyHomeContent> {
  final _picker = ImagePicker();
  File? _image;
  int _column = 2;
  Map<String, dynamic>? _data;
  List? _rawData;
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: HttpConfig.baseURL,
    connectTimeout: HttpConfig.timeout,
  );

  static final Dio _dio = Dio(_baseOptions);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          _imageView(),
          _dropDownMenu(),
          ElevatedButton(
            onPressed: _takePhoto,
            child: Text("表格识别(照相)"),
          ),
          ElevatedButton(
            onPressed: _openGallery,
            child: Text("表格识别(图片)"),
          ),
          ElevatedButton(
            onPressed: _showTable,
            child: Text("显示表格"),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Widget _imageView() {
    return _image == null ? Text("请拍摄图像") : Image.file(_image!);
  }

  void _showTable() {
    setState(() {
      if (this._rawData != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MyTableScreen(this._rawData!, this._column);
        }));
      }
    });
  }

  void _takePhoto() async {
    PickedFile? pickedFile = await _picker.getImage(source: ImageSource.camera);
    var image = File(pickedFile!.path);
    setState(() {
      this._image = image;
      _uploadData();
    });
  }

  void _openGallery() async {
    PickedFile? pickedFile =
        await _picker.getImage(source: ImageSource.gallery);
    var image = File(pickedFile!.path);
    setState(() {
      this._image = image;
      _uploadData();
    });
  }

  Widget _dropDownMenu() {
    return Container(
      child: Row(
        children: [
          Text("请选择表格列数："),
          DropdownButton(
            items: items,
            onChanged: (value) {
              setState(() {
                this._column = value as int;
              });
            },
            value: this._column,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  void _uploadData() async {
    if (this._image != null) {
      String base64encode = base64Encode(await this._image!.readAsBytes());
      // print(base64encode.length);
      Map<String, dynamic> headers = {
        'Authorization': 'APPCODE ' + HttpConfig.AppKey,
        'Content-Type': 'application/json; charset=UTF-8'
      };
      final Options options =
          Options(method: HttpConfig.defaultMethod, headers: headers);
      final data = {"img": base64encode};
      final response = await _dio.post('', data: data, options: options);
      var model = RecognitionModel.fromJson(response.data);
      Map<String, dynamic> table = Map();
      final split = model.content!.trim().split(' ');
      for (int i = 0; i < this._column; i++) {
        table[split[i]] = [];
      }
      for (var i = this._column; i < split.length; i++) {
        final head = table[split[i % this._column]] as List;
        head.add(split[i]);
      }
      print(table);
      setState(() {
        this._data = table;
        this._rawData = split;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MyTableScreen(split, this._column);
        }));
      });
    }
  }
}
