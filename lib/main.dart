import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
//providers
import 'package:flutter_app_learn/providers/bju_app_provider.dart';
import 'package:flutter_app_learn/providers/login_provider.dart';
import 'package:flutter_app_learn/providers/jpush_provider.dart';
//others
import 'package:flutter_app_learn/net/bju_net.dart';
import 'package:flustars/flustars.dart';
//
import 'package:flutter_app_learn/pages/main_page.dart';
//

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  //initialization
  @override
  void initState() {
    super.initState();
    // 初始化项目中的各种配置信息
    _initConfig();
  }
  void _initConfig() async {
    // 初始化请求Dio配置
    BjuHttp.initConfig();
    // 初始化SharedPreferences工具类
    await SpUtil.getInstance();
  }
  //
  static ChangeNotifierProvider<T> buildProvider<T extends ChangeNotifier>(
      T value) {
    return ChangeNotifierProvider<T>.value(value: value);
  }

  final List<SingleChildWidget> _providers =  [
    buildProvider<BjuAppSettingsProvider>(BjuAppSettingsProvider()..init()),
    //how it check if the user login
    buildProvider<LoginProvider>(LoginProvider()),
    buildProvider<JPushProvider>(JPushProvider()
      //..initNotificationPlugin()
      ..initJPush()
      ..setUpJPush()
    )
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providers,
      child: Consumer<BjuAppSettingsProvider>(
          builder: (context, bjuAppSettingsProvider, child) {
            return OKToast(
                child: MaterialApp(
                  title: bjuAppSettingsProvider.appTitle,
                  theme: bjuAppSettingsProvider.bjuThemeData,
                  debugShowCheckedModeBanner: false,
                  home: const Scaffold(
                      body: MainPage()
                      //body:Text("xxxxxxxxxxxxxxxxxxxxxxx")
                  ),
                )
            );
          }
      ),
    );
  }
}
