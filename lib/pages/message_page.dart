import 'package:flutter_app_learn/providers/jpush_provider.dart';
import 'package:flutter_app_learn/providers/login_provider.dart';
//import 'package:flutter_app_learn/utils/db_util.dart';
//import 'package:flutter_app_learn/constants/bju_constant.dart';
//import 'package:flutter_app_learn/pages/details/message_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final List<String> _msgItems = ['平台通知', '@我的', '评论我', '赞我'];

  final List<Icon> _msgItemIcons = [
    Icon(FontAwesomeIcons.bullhorn, color: Colors.lightBlue[400]),
    Icon(FontAwesomeIcons.at, color: Colors.lightBlue[400]),
    Icon(FontAwesomeIcons.comments, color: Colors.lightBlue[400]),
    Icon(FontAwesomeIcons.thumbsUp, color: Colors.lightBlue[400])
  ];

  @override
  Widget build(BuildContext context) {
    // 初始化屏幕大小用于适配
    ScreenUtil.init(context, designSize: const Size(750, 1334));
    //
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //leading:Icon(Icons.account_circle),
        title: const Text('消息'),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.help_outline),
          )
        ],
      ),
      body: Consumer2<LoginProvider, JPushProvider>(
        builder: (context, loginProvider, jpushProvider, child) {
          // loginProvider.isLogin ? Center(child: Text('同学，您还没有登录唷~')) :
          return ListView.separated(
              padding: const EdgeInsets.only(left: 5, right: 5),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: _msgItemIcons[index],
                  title: Text(_msgItems[index]),
                  trailing: Icon(
                    FontAwesomeIcons.chevronRight,
                    size: 32,
                    color: Colors.grey[400],
                  ),
                  onTap: () {
                    // 用户未登录并点击了 ['@我','评论我','赞我'],给出提示信息
                    if (!loginProvider.isLogin && index != 0) {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                                title: const Icon(
                                  Icons.warning,
                                  color: Colors.deepOrangeAccent,
                                ),
                                content: const Text('同学请先登录，在查看！'),
                                actions: [
                                  //FlatButton(
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('知道了'),
                                  ),
                                ]);
                          });
                      return;
                    }
                    print('用户点击了---$index]');
                    print('messageList:' +
                        jpushProvider.messageList(index).toString());

                    // 跳转到消息详情页面
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          /// here I change the push page!!!
                          ///
                          //builder: (context) => MessageDetailsPage(index)));
                            builder: (context) => Text("$index")));
                  },
                );
              },
              separatorBuilder: (context, index) {
                return child ?? Container();
              },
              itemCount: _msgItems.length);
        },
        child: const Divider(height: 10),
      ),
    );
  }
}
