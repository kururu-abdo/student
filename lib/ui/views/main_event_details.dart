import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student_side/model/event.dart';
import 'package:student_side/ui/views/open_image.dart';
import 'package:student_side/util/ui/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MainEventDetails extends StatefulWidget {
  final Event data;
  MainEventDetails(this.data);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<MainEventDetails> {
  List<String> files = [];




    bool _permissionReady;

  @override
  void initState() {
    super.initState();
_permissionReady = false;
    _prepareSaveDir();
    fill_array();
  }
  String _localPath;
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }

  _checkPermission() async {
    final status = await Permission.storage.status;
    bool granted;
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        granted = true;
      } else {
        granted = false;
      }
    } else {
      granted = true;
    }

    return granted;
  }

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }


  fill_array() {
    for (var i = 0; i < widget.data.Files.length; i++) {
      files.add(widget.data.Files[i]);
    }
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
        
          appBar: AppBar(
          
        
            title: Text('التفاصيل'),
            centerTitle: true,
           
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Container(
                   padding: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(blurRadius: 2.0, color: Colors.white),
                        ]),
                    child: Text('االموضوع.')),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  child: SingleChildScrollView(
                    child: Text(
                      
                      widget.data.body != null ? widget.data.body :
                      widget.data.title
                      
                      ,
                      maxLines: 20,
                    
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right :8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(blurRadius: 2.0, color: Colors.white)
                        ]),
                    child: Text('الملفات...')),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Container(
                      height: MediaQuery.of(context).size.height - 120,
                      decoration: BoxDecoration(),
                      child: files.length > 0
                          ? GridView.count(
                              crossAxisCount: 2,
                              children: files.map((file) {
                                print(file);

                                    if (file.endsWith("jpg") ||
                                        file.endsWith("jpeg") ||
                                        file.endsWith("png")) {
                                      return Container(
                                        margin: EdgeInsets.all(8.0),
                                        width: 100,
                                        height: 200,
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.to(OpenImage(url: file));
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                color: Colors.amber,
                                                child: Center(
                                                    child:
                                                        Text("معاينة الملف")),
                                              ),
                                            ),
                                            Expanded(
                                                child: Image.network(
                                              file,
                                              fit: BoxFit.cover,
                                            )),
                                            InkWell(
                                              onTap: () {
                                                _requestDownload(file);
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                color: AppColors.greenColor,
                                                child: Center(
                                                    child: Text("تحميل الملف" ,        style: TextStyle(
                                                            color:
                                                                Colors.white))),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }

                                    return Container(
                                      margin: EdgeInsets.all(8.0),
                                      width: 100,
                                      height: 200,
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              if (await canLaunch(file)) {
                                                await launch(file);
                                              } else {
                                                throw 'Unable to open url : $file';
                                              }
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.amber,
                                              child: Center(
                                                  child: Text("معاينة الملف")),
                                            ),
                                          ),
                                          Expanded(
                                              child: Text(getFileType(file))),
                                          InkWell(

                                          onTap: (){
                                          
                                                                                        _requestDownload(file);

                                          },
                                            child: Container(
                                              width: double.infinity,
                                              color: AppColors.greenColor,
                                              child: Center(
                                                  child: Text("تحميل الملف" ,  style: TextStyle(color: Colors.white), )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                              ).toList(),
                            )
                          : Column(
                            children: [

                              Image.asset('assets/images/file_not_found.png'),

                              Text('لا يحتوي الخبر أو الاعلان على ااي ملفات'),
                            ],
                          )),
                ),
              ],
            ),
          )),
    );
  }

  void _requestDownload(String link) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    final taskId = await FlutterDownloader.enqueue(
      url: link,

      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification: true,
      savedDir:
          appDocPath, // click on notification to open downloaded file (for Android)
    );
  }

 String getFileType(String url) {
    String fileType = url.split('.').last.toLowerCase();

    return fileType;
  }

}
