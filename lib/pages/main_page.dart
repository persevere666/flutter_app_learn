import 'package:flutter_app_learn/pages/personal_center_page.dart';
import 'package:flutter_app_learn/pages/message_page.dart';
import 'package:flutter_app_learn/pages/home_page.dart';
import 'package:flutter_app_learn/pages/publish_page_v2.dart';
import 'package:flutter_app_learn/pages/square_page.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// 底部导航栏的索引值
  int _currentIndex = 0;

  /// BottomIconSize
  final double _bottomIconSize = 32;
  // BottomIconColor

  /// body
  final List<Widget> _bodys = [
    const HomePage(),
    //const Text("HomePage", selectionColor: Colors.red),

    const SquarePage(),
    //const Text("SquarePage"),

    const MessagePage(),
    //const Text("MessagePage"),

    const PersonalCenterPage()
    //const Text("PersonalCenterPage"),
  ];

  ///
  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ///
  /// 创建底部导航栏
  ///
  BottomAppBar _createBottomAppBar() {
    return BottomAppBar(
      color: Colors.lightBlueAccent,
      shape: const CircularNotchedRectangle(), // 凹槽
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
              iconSize: _bottomIconSize,
              icon: const Icon(Icons.apps),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              }
          ),
          IconButton(
              iconSize: _bottomIconSize,
              icon: const Icon(Icons.camera),
              onPressed: () {
                setState(() {
                  //_currentIndex = 1;
                  // 跳转到朋友圈页面
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SquarePage()
                      )
                  );
                });
              }),
          IconButton(
              iconSize: _bottomIconSize,
              icon: const Icon(Icons.mail),
              onPressed: () {
                setState(() {
                  _currentIndex = 2;
                });
              }),
          IconButton(
              iconSize: _bottomIconSize,
              icon: const Icon(Icons.person),
              onPressed: () {
                setState(() {
                  _currentIndex = 3;
                });
              }),
        ],
      ),
    );
  }

  /// 发布栏目
  /// goto: PublishPage(1~4)
  Widget _showPublishItem() {
    return Container(
      padding: const EdgeInsets.all(10),
      /*  decoration: BoxDecoration(
         color: Colors.white54,
         borderRadius: BorderRadius.all(Radius.circular(20))
       ), */
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextButton(
            //FlatButton(
            child: const Text(
              "表白墙",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                wordSpacing: 5,
              ),
            ),
            onPressed: () {
              // 手动关闭模态框
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const PublishPage(1);
                //return const Text("PublishPage(1)");
              }));
            },
          ),
          const Divider(
            height: 2,
            color: Colors.white,
          ),
          TextButton(
            child: const Text(
              "万能墙",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                wordSpacing: 5,
              ),
            ),
            onPressed: () {
              // 手动关闭模态框
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PublishPage(2);
                //return const Text("PublishPage(2)");
              }));
            },
          ),
          const Divider(
            height: 2,
            color: Colors.white,
          ),
          TextButton(
            child: const Text(
              "谏言贴",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                wordSpacing: 5,
              ),
            ),
            onPressed: () {
              print("****谏言贴--3****");
              // 手动关闭模态框
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PublishPage(3);
                //return const Text("PublishPage(3)");
              }));
            },
          ),
          const Divider(
            height: 2,
            color: Colors.white,
          ),
          TextButton(
            child: const Text(
              "兼职汇",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                wordSpacing: 5,
              ),
            ),
            onPressed: () {
              // 手动关闭模态框
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PublishPage(4);
                //return const Text("PublishPage(4)");
              }));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      body: _bodys[_currentIndex],
      bottomNavigationBar: _createBottomAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: Colors.lightBlue,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
              ),
              context: context,
              builder: (context) {
                return _showPublishItem();
              }
          );
        },
        tooltip: '发布',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

