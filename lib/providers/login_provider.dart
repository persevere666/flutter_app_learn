import 'package:flutter_app_learn/constants/bju_constant.dart';
import 'package:flutter_app_learn/models/user.dart';
import 'package:flutter_app_learn/net/bju_net.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

///
/// 登录状态Provider
///
class LoginProvider extends ChangeNotifier {
  /// 登录否
  bool _isLogin = false;

  /// 登录的用户信息
  User? _user;

  /// 用户主页计数项
  Map<String, dynamic> _allCounts = {};

  bool get isLogin => _isLogin;

  User? get loginUser => _user;

  int? get userId => loginUser?.userId;

  Map<String, dynamic> get allCounts => _allCounts;


  ///
  /// 用户登录操作
  ///
  void doLogin(User? user) {
    if(user==null){
      return;
    }
    //
    _user = user;
    //一系列判断信息
    _isLogin = true;
    // 存储用户的信息
    SpUtil.putString(BJUConstants.loginUserMobile, user.userMobile);
    notifyListeners();
  }

  ///
  /// 更新用户信息
  ///
  void updateUserInfo(User user) {
    _user = user;
    notifyListeners();
  }

  /// 更新用户头像信息
  /// * [avatarUrl] 用户头像地址
  void refreshUserAvatar(String avatarUrl) {
    _user?.userAvatar = avatarUrl;
    notifyListeners();
  }

  /// 用户退出登录
  void logout() {
    // 消除dio中的token信息
    BjuHttp.disposeToken();
    // 删除登录的用户信息
    _user = null;
    // 登录标志为false
    _isLogin = false;
    // 删除本地持久化的用户号码
    SpUtil.remove(BJUConstants.loginUserMobile);
    notifyListeners();
  }

  /// 刷新用户主页计数项
  void refreshAllCounts(Map<String, dynamic> counts) {
    // 更新counts
    _allCounts = counts;
    notifyListeners();
  }

  @override
  String toString() {
    return '[isLogin : ${isLogin.toString()} ; user: ${_user.toString()}]';
  }
}
