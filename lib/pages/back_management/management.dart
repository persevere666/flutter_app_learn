import 'package:flutter_app_learn/api/api.dart';
import 'package:flutter_app_learn/models/response.dart';
import 'package:flutter_app_learn/net/bju_net.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

///
/// 推送信息到全员用户
/// 2020/04/20 15:15
///
class BackManagement extends StatefulWidget {
  BackManagement({Key? key}) : super(key: key);

  @override
  _BackManagementState createState() => _BackManagementState();
}

class _BackManagementState extends State<BackManagement> {


  /// 文本编辑控制器
  TextEditingController  _contentTextController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed:(){
          Navigator.of(context).pop();
        }),
        title: const Text('后台管理'),
      ),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: _contentTextController,
                keyboardType: TextInputType.text,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: '请输入全平台推送通知的信息...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10,),
              child: ElevatedButton(
                // padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                // color: Colors.lightBlue[400],
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.fromLTRB(0, 3, 0, 3)
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Colors.lightBlue[400],
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  )
                ),
                child: const Text(
                  '全员推送（ALL STAFF PUSH）',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if(_contentTextController.text.trim().isEmpty){
                      showToast('请输入推送的内容！');
                      return;
                  }
                  // 向服务器发起推送请求
                  ResponseData resData = await BjuHttp.post(API.pushAll,params: {
                    'messageType' : 0,
                    'content' : _contentTextController.text
                  }).then((onValue) => ResponseData.fromJson(onValue.data))
                  .catchError((onError){
                    print('全员推送，请求服务器异常！');
                    print(onError);
                    showToast('服务器请求异常！');
                    return ResponseData();
                  });

                  if(resData.statusCode!=0){
                    Future.delayed(const Duration(milliseconds: 1500), () => showToast('请求失败！') );
                    return;
                  }
                  // 弹出提示
                  showToast(resData.message);
                  if(resData.statusCode == 0){
                    // 清空输入框文本
                    _contentTextController.clear();
                  }
                }
              ),
            )
          ],
        ),
        ),
    );
  }
}