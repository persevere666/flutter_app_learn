import 'package:flutter_app_learn/api/api.dart';
import 'package:flutter_app_learn/models/response.dart';
import 'package:flutter_app_learn/models/user.dart';
import 'package:flutter_app_learn/net/bju_net.dart';
import 'package:flutter_app_learn/pages/register_page.dart';
import 'package:flutter_app_learn/providers/jpush_provider.dart';
import 'package:flutter_app_learn/providers/login_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

///
/// 登录页
///
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  /// 焦点
  final FocusNode _focusNodeUserName =  FocusNode();
  final FocusNode _focusNodePassWord =  FocusNode();
  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  final TextEditingController _userNameController = TextEditingController();

  /// 表单状态
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// 密码
  String _password = '';
  /// 用户名
  String _username = '';
  /// 是否显示密码
  bool _isShowPwd = false;
  /// 
  /// 是否显示输入框尾部的清除按钮
  bool _isShowClear = false;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    //监听用户名框的输入改变
    _userNameController.addListener((){
      //print(_userNameController.text);
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.isNotEmpty) {
        _isShowClear = true;
      }else{
        _isShowClear = false;
      }
      //why
      setState(() {
        
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
    super.dispose();
  }
  // 监听焦点
  Future _focusNodeListener() async{
    if(_focusNodeUserName.hasFocus){
      print("用户名框获取焦点");
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }
  /// 验证用户名
  String? validateUserName(String? value){
    // 正则匹配手机号
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (value==null || value.isEmpty) {
      return '用户名不能为空!';
    }else if (!exp.hasMatch(value)) {
      return '请输入正确手机号';
    }
    return null;
  }
  ///验证密码
  String? validatePassWord(value){
    if (value.isEmpty) {
      return '密码不能为空';
    }else if(value.trim().toString().length < 6){
      return '密码长度不正确';
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {

    //ScreenUtil.init(context, designSize: const Size(750,1334));

    //print(ScreenUtil().scaleHeight);
    // logo 图片区域
    Widget logoImageArea =  Container(
      alignment: Alignment.topCenter,
      // 设置图片为圆形
      child: ClipOval(
        child: Image.asset(
          "assets/avatar/bju_xh.jpg",
          height: 100,
          width: 100,
          fit: BoxFit.fill,
        ),
      ),
    );
    
    //输入文本框区域
    Widget inputTextArea = Container(
      margin: const EdgeInsets.only(left: 20,right: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white
      ),
      child: Form(
        key: _formKey,
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _userNameController,
              focusNode: _focusNodeUserName,
              //设置键盘类型
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "请输入手机号",
                prefixIcon: const Icon(Icons.person),
                //尾部添加清除按钮
                suffixIcon:(_isShowClear) 
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: (){
                                // 清空输入框内容
                                _userNameController.clear();
                              },
                            ) 
                          : null ,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (value){
                _username = value??"";
              },
            ),
            TextFormField(
              focusNode: _focusNodePassWord,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "密码",
                hintText: "请输入密码",
                prefixIcon: const Icon(Icons.lock),
                // 是否显示密码
                suffixIcon: IconButton(
                  icon: Icon((_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                  // 点击改变显示或隐藏密码
                  onPressed: (){
                    setState(() {
                      _isShowPwd = !_isShowPwd;
                    });
                  },
                )
              ),
              obscureText: !_isShowPwd,
              //密码验证
              validator:validatePassWord, 
              //保存数据
              onSaved: (value){
                _password = value??"";
              },
            )
          ],
        ),
      ),      
    );
    // 登录按钮区域
    Widget loginButtonArea = Container(
      margin:const EdgeInsets.only(left: 20,right: 20),
      height: 45.0,
      child:  ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.blue[300]),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          ),
        ),
        //color: Colors.blue[300],
        child: Text(
          "登录",
          style: Theme.of(context).primaryTextTheme.headlineMedium,
        ),
        // 设置按钮圆角
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () async {
          final navigator = Navigator.of(context);
          // 登录成功
          LoginProvider loginProvider = Provider.of<LoginProvider>(context,listen: false);
          JPushProvider jPushProvider = Provider.of<JPushProvider>(context,listen: false);
          //点击登录按钮，解除焦点，回收键盘
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();
          //
          if (_formKey.currentState!=null && _formKey.currentState!.validate()) {
            //只有输入通过验证，才会执行这里
            _formKey.currentState!.save();
             //todo 登录操作
            print('输入数据:');
            print("$_username + $_password");

          // 调用API接口执行登录操作
          ResponseData resData =  await BjuHttp.post(API.npLogin,params: {
              'userMobile':_username,
              'password':_password
            }).then((onValue) => ResponseData.fromJson(onValue.data))
            .catchError((onError){
              //print('登录异常：');
              //print(onError);
              showToast('请求服务器异常！');
              return ResponseData();
            });
            // if(resData == null) {
            //   showToast('网络请求失败！');
            //   return;
            // }
            print('----返回的数据'+resData.toString());
            print('----返回的数据data: ' + resData.toJson().toString());
            if(resData.statusCode != 0){
              showToast(resData.message);
              return;
            }
            final User user = User.fromJson(resData.res['user']);
            print('用户数据model：user：$user');
           // 设置登录数据
           loginProvider.doLogin(user);
           loginProvider.refreshAllCounts(resData.res['allCounts']);
           // 设置JPush的别名
          //  print('jpush:');
           jPushProvider.setAlias(_username);
          //  print(await jPushProvider.jpush.getAllTags());
           print("用户登录，获取到的token为：token= " + resData.res['token'].toString());
           print(resData.res['token']);
           BjuHttp.token(resData.res['token']);
           // 返回
           //Navigator.pop(context);
           navigator.pop();
          }
        },
      ),
    );
    //第三方登录区域
    Widget thirdLoginArea = Container(
      margin: const EdgeInsets.only(left: 20,right: 20),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 80,
                height: 1.0,
                color: Colors.grey,
                
              ),
              const Text('第三方登录'),
              Container(
                width: 80,
                height: 1.0,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 18,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                color: Colors.green[200],
                // 第三方库icon图标
                icon: const Icon(FontAwesomeIcons.weixin),
                iconSize: 40.0,
                onPressed: (){
                  //
                },
              ),
              IconButton(
                color: Colors.green[200],
                icon: const Icon(FontAwesomeIcons.facebook),
                iconSize: 40.0,
                onPressed: (){
                },
              ),
              IconButton(
                color: Colors.green[200],
                icon: const Icon(FontAwesomeIcons.qq),
                iconSize: 40.0,
                onPressed: (){
                },
              )
            ],
          )
        ],
      ),
    );
    //忘记密码  立即注册
    Widget bottomArea = Container(
      margin: const EdgeInsets.only(right: 20,left: 30),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: Text(
              "忘记密码?",
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 16.0,
              ),
            ),
            //忘记密码按钮，点击执行事件
            onPressed: (){},
          ),
          TextButton(
            child: Text(
              "快速注册",
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 16.0,
              ),  
            ),
            //点击快速注册、执行事件
            onPressed: () async {
              var res = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const RegisterPage();
                  })
              );
              if(res==null || res.trim().isEmpty || !mounted) return;
              setState(() {
                // 刚注册的手机号码
                _userNameController.text = res.trim();
              });
            },
          )
        ],
      ),
    );
   
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => Navigator.of(context).pop(),),
          title: const Text('登录'),
        ),
        backgroundColor: Colors.white,
        // 外层添加一个手势，用于点击空白部分，回收键盘
        body: GestureDetector(
          onTap: (){
            // 点击空白区域，回收键盘
            print("点击了空白区域");
            _focusNodePassWord.unfocus();
            _focusNodeUserName.unfocus();
          },
          child: ListView(
            children: [
              const SizedBox(height: 80,),
              logoImageArea,
              const SizedBox(height: 70,),
              inputTextArea,
              const SizedBox(height: 80,),
              loginButtonArea,
              const SizedBox(height: 60,),
              thirdLoginArea,
              const SizedBox(height: 60,),
              bottomArea,
          ],
          ),
        ),
      );
  }
}