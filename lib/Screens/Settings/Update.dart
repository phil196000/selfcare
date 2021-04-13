import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:selfcare/CustomisedWidgets/DarkBlueText.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/PrimaryButton.dart';

// import 'package:get_version/get_version.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:selfcare/CustomisedWidgets/TextButton.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

const debug = true;

class Update extends StatefulWidget {
  final TargetPlatform? platform;

  Update({this.platform});

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  UpdateInfo? updateInfo;
  List<_TaskInfo>? _tasks;

  // late List<_ItemHolder> _items;
  bool _isLoading = false;
  late bool _permissionReady;
  late String _localPath;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    log(widget.platform.toString());
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
  }

  Widget _infoTile(String title, String subtitle, String updateInfor) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Visibility(
              visible: updateInfo != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DarkGreenText(
                    text: 'New',
                    size: 15,
                    weight: FontWeight.normal,
                  ),
                ],
              )),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subtitle.isNotEmpty ? subtitle : 'Not set'),
          DarkGreenText(text: updateInfor != null ? updateInfor : '')
        ],
      ),
    );
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int? progress = data[2];

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == id);
        if (task != null) {
          setState(() {
            task.status = status;
            task.progress = progress;
          });
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link!,
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId!);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  void _resumeDownload(_TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo? task) {
    if (task != null) {
      return FlutterDownloader.open(taskId: task.taskId!);
    } else {
      return Future.value(false);
    }
  }

  Future<void> downloadApk() async {
    final taskId = await FlutterDownloader.enqueue(
      url: 'your download link',
      savedDir: 'the path of directory where you want to save downloaded files',
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    // _items = [];
    _tasks!.add(_TaskInfo(name: updateInfo!.app_name, link: updateInfo!.url));
    // _tasks!.addAll(_documents.map((document) =>
    //     _TaskInfo(name: document['name'], link: document['link'])));
    //
    // _items.add(_ItemHolder(name: 'Documents'));
    // for (int i = count; i < _tasks!.length; i++) {
    //   _items.add(_ItemHolder(name: _tasks![i].name, task: _tasks![i]));
    //   count++;
    // }
    //
    // _tasks!.addAll(_images
    //     .map((image) => _TaskInfo(name: image['name'], link: image['link'])));
    //
    // _items.add(_ItemHolder(name: 'Images'));
    // for (int i = count; i < _tasks!.length; i++) {
    //   _items.add(_ItemHolder(name: _tasks![i].name, task: _tasks![i]));
    //   count++;
    // }
    //
    // _tasks!.addAll(_videos
    //     .map((video) => _TaskInfo(name: video['name'], link: video['link'])));
    //
    // _items.add(_ItemHolder(name: 'Videos'));
    // for (int i = count; i < _tasks!.length; i++) {
    //   _items.add(_ItemHolder(name: _tasks![i].name, task: _tasks![i]));
    //   count++;
    // }

    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks!) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });
    log(_tasks!.length.toString(), name: 'tasks');
    if (_tasks != null && _tasks!.length > 0) {
      _requestDownload(_tasks![0]);
    }

    // _permissionReady = await _checkPermission();
    //
    // _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
    //
    // final savedDir = Directory(_localPath);
    // bool hasExisted = await savedDir.exists();
    // if (!hasExisted) {
    //   savedDir.create();
    // }
    //
    // setState(() {
    //   _isLoading = false;
    // });
  }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      log('i should ran');
      final status = await Permission.storage.status;
      log(status.toString());
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        log(result.toString(), name: 'Permission request');
        if (result == PermissionStatus.granted) {
          return true;
        } else if (result.isPermanentlyDenied) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // onVisible: () => Timer(
            //     Duration(seconds: 2),
            //         () => Navigator.of(context).pop()),
            backgroundColor: Colors.green,
            content: Container(
              // color: Colors.yellow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WhiteText(
                    text: 'Permission permanently denied',
                  ),
                  Container(
                    decoration:
                        BoxDecoration(color: DefaultColors().shadowColorGrey),
                    child: ButtonText(
                      text: 'Change',
                      onPressed: () {
                        openAppSettings();
                      },
                    ),
                  )
                ],
              ),
            ),

            duration: Duration(milliseconds: 7000),
          ));
          // The user opted to never again see the permission request dialog for this
          // app. The only way to change the permission's status now is to let the
          // user manually enable it in the system settings.

        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await (getExternalStorageDirectory() as FutureOr<Directory>)
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> fetchUpdate() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('app_update')
        .where('build_number',
            isGreaterThan: int.parse(_packageInfo.buildNumber))
        .get();
    if (querySnapshot.size > 0) {
      querySnapshot.docs.forEach((element) {
        setState(() {
          updateInfo = UpdateInfo.fromJson(element.data()!);
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // onVisible: () => Timer(
        //     Duration(seconds: 2),
        //         () => Navigator.of(context).pop()),
        backgroundColor: Colors.green,
        content: Container(
          // color: Colors.yellow,
          child: WhiteText(
            text: 'Update available',
          ),
        ),
        duration: Duration(milliseconds: 2000),
      ));
    } else {
      log(_packageInfo.buildNumber);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // onVisible: () => Timer(
        //     Duration(seconds: 2),
        //         () => Navigator.of(context).pop()),
        backgroundColor: Colors.red,
        content: Container(
          // color: Colors.yellow,
          child: WhiteText(
            text: 'No updates available yet',
          ),
        ),
        duration: Duration(milliseconds: 2000),
      ));
      setState(() {
        updateInfo = null;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: DefaultColors().yellow,
          title: new Text('Update'),
        ),
        body: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              Visibility(
                visible: _isLoading,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(DefaultColors().primary),
                ),
              ),
              _infoTile('App name', _packageInfo.appName,
                  updateInfo != null ? updateInfo!.app_name! : ''),
              _infoTile(
                  'Package name',
                  _packageInfo.packageName,
                  updateInfo != null
                      ? updateInfo!.package_name.toString()
                      : ''),
              _infoTile('App version', _packageInfo.version,
                  updateInfo != null ? updateInfo!.version.toString() : ''),
              _infoTile(
                  'Build number',
                  _packageInfo.buildNumber,
                  updateInfo != null
                      ? updateInfo!.build_number.toString()
                      : ''),
              Visibility(
                visible: _tasks != null && _tasks!.length > 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: _tasks != null ? _tasks![0].progress! / 100 : 0,
                      ),
                      DarkBlueText(
                          text: '${_tasks != null ? _tasks![0].progress! : 0}%')
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: PrimaryButton(
                  text: updateInfo == null
                      ? 'Check for Update'
                      : _tasks != null && _tasks![0].progress == 100
                          ? 'Install'
                          : 'Download',
                  onPressed: () async {
                    if (updateInfo == null) {
                      fetchUpdate();
                    } else if (_tasks != null && _tasks![0].progress == 100) {
                      _openDownloadedFile(_tasks![0]);
                    } else {
                      _permissionReady = await _checkPermission();
                      log(_permissionReady.toString());
                      if (_permissionReady) {
                        _localPath = (await _findLocalPath()) +
                            Platform.pathSeparator +
                            'Download';
                        final savedDir = Directory(_localPath);
                        bool hasExisted = await savedDir.exists();
                        if (!hasExisted) {
                          savedDir.create();
                        } else {
                          _prepare();
                        }
                      }

                      //

                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskInfo {
  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class UpdateInfo {
  final String? url;
  final int? build_number;
  final String? app_name;
  final String? package_name;

  String? version;

  UpdateInfo({
    this.url,
    this.build_number,
    this.version,
    this.app_name,
    this.package_name,
  });

  UpdateInfo.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        app_name = json['app_name'],
        package_name = json['package_name'],
        build_number = json['build_number'],
        version = json['version'];

  Map<String, dynamic> toJson() =>
      {'url': url, 'build_number': build_number, 'version': version};
}
