import 'package:flutter_app_learn/api/api.dart';
import 'package:flutter_app_learn/models/response.dart';
import 'package:flutter_app_learn/models/user.dart';
import 'package:flutter_app_learn/net/bju_net.dart';
import 'package:flutter_app_learn/pages/login_page.dart';
import 'package:flutter_app_learn/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

///
/// 我的栏目下的安全设置项
/// 2020/04/17 12:24
/// 
/// * 用户登录密码修改
///

class SaftySettingPage extends StatefulWidget {
  SaftySettingPage({Key? key}) : super(key: key);

  @override
  _SaftySettingPageState createState() => _SaftySettingPageState();
}


class _SaftySettingPageState extends State<SaftySettingPage> {

  /// form表单key
  final GlobalKey<FormState> _formKey = GlobalKey();

  /// 密码输入文本控制器
  final TextEditingController  _passwordController = TextEditingController();

  /// 新密码
  String _newPassword = '';

  /// 密码可见
  bool _isShowNewPassword = false;

   /// 密码可见
  bool _isShowConfirmPassword = false;




  ///
  /// 输入域布局
  ///
  Widget _formLayout(){
    return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 密码
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child:  Text('新密码：', style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              wordSpacing: 2,
                              color: Colors.black54,
                              // backgroundColor: Colors.lightBlue[400],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !_isShowNewPassword,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '请输入6-12有效数字',
                              border: const UnderlineInputBorder(),
                              suffixIcon: IconButton(
                                icon:Icon(_isShowNewPassword ? Icons.visibility : Icons.visibility_off),
                                onPressed: (){
                                  setState(() {
                                    _isShowNewPassword = !_isShowNewPassword;
                                  });
                                },
                              )
                            ),
                            validator: (val) {
                              if(val==null) return null;
                              RegExp exp = RegExp(r'^\d{6,12}$');
                              if(val.trim().isEmpty){
                                return '密码不能为空！';
                              } else if(!exp.hasMatch(val)){
                                return '密码只能是6-12位数字';
                              } 
                              return null;
                            },
                            onSaved: (value){
                              if(value == null || !mounted) return;
                              setState(() {
                                _newPassword = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  // 确认密码
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text('确认密码：', style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              wordSpacing: 2,
                              color: Colors.black54,
                              // backgroundColor: Colors.lightBlue[400],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            obscureText: !_isShowConfirmPassword,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '请输入6-12有效数字',
                              border: const UnderlineInputBorder(),
                              suffixIcon: IconButton(
                                icon:Icon(_isShowConfirmPassword ? Icons.visibility : Icons.visibility_off),
                                onPressed: (){
                                  setState(() {
                                    _isShowConfirmPassword = !_isShowConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (val) {
                              if(val == null) return null;
                              RegExp exp = RegExp(r'^\d{6,12}$');
                              if(val.isEmpty){
                                return '密码不能为空！';
                              } else if(!exp.hasMatch(val)){
                                return '密码只能是6-12位数字';
                              } else if(_passwordController.text.compareTo(val) !=  0){
                                return '两次密码输入不一致！';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  // 修改按钮
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,8,10,0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 80,
                            child: ElevatedButton(
                              // color: Colors.blue[400],
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue[400]),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                )
                              ),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(8)
                              // ),
                              onPressed: () async {
                                print('安全设置，修改密码');
                                // 验证表单
                                if(!(_formKey.currentState?.validate()??false)){
                                  print('密码修改：表单验证不通过！');
                                  return;
                                }
                                // 保存表单中的状态
                                _formKey.currentState?.save();
                                final User? user = Provider.of<LoginProvider>(context, listen: false).loginUser;
                                if(user == null) return;
                                // 向服务器请求
                                ResponseData resData = await BjuHttp.put(API.modifyPassword, params: {
                                  "userMobile" : user.userMobile,
                                  "userNickname" : user.userNickname,
                                  "newPassword" : _newPassword,
                                }).then((onValue) => ResponseData.fromJson(onValue.data))
                                .catchError((onError){
                                  print('密码修改，请求服务器异常！');
                                  print(onError);
                                  showToast('服务器请求异常！');
                                  return ResponseData();
                                });
                                // if(resData == null){
                                 //    Future.delayed(Duration(milliseconds: 1500), () => showToast('请求失败！'));
                                 //    return;
                                 // }
                                 if(resData.statusCode == 1 || resData.statusCode == -1){
                                    showToast(resData.message);
                                    return;
                                 }
                                 // 先退出登录，后跳转登录页面
                                ResponseData logoutRes = await BjuHttp.post(API.logout)
                                    .then((onValue){
                                      return ResponseData.fromJson(onValue.data);
                                    }).catchError( (onError){
                                      print('密码修改，退出登录请求服务器异常！');
                                      print(onError);
                                      showToast('服务器请求异常！');
                                      return ResponseData();
                                    });
                                 print('密码修改成功后退出登录的结果，logoutRes= ' + logoutRes.toString());
                                 if(logoutRes != null && logoutRes.statusCode == 0){
                                    showToast('即将跳转到登录页面...');
                                    Future.delayed(
                                        const Duration(milliseconds: 3000),
                                            () => Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => const LoginPage())
                                            )
                                    );
                                    return;
                                 }
                               },
                              child: const Text('修改（MODIFY PASSWORD）', style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                  
                ],
              ),
              
            );
  }

  /// 
  /// 密码修改设置布局
  Widget _passwordSettingLayout(){

    // 屏幕的Size
    final Size size = MediaQuery.of(context).size;

    return Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Text('密码修改',style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        wordSpacing: 4,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  top: 20,
                  child: Divider(),
                ),
                Positioned(
                  top: 30,
                  width: size.width - 20,
                  child: _formLayout()
                ),
              ],
            ),
          );

  }





  @override
  Widget build(BuildContext context) {
    // 初始化屏幕大小用于适配
    // ScreenUtil.init(context, width:750,height:1334);
    
    return Scaffold(
      appBar: AppBar(
        leading:BackButton(onPressed: () => Navigator.of(context).pop(),),
        title: const Text('安全设置'),
        // actions: <Widget>[
        //   Padding(
        //     padding: EdgeInsets.only(right: 15),
        //     child: InkWell(
        //       child: Text('修改'),
        //       onTap: () => null,
        //     ),
        //   )
        // ],
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          // 密码设置布局
          _passwordSettingLayout(),
        ],
      ),
    );
  }
}