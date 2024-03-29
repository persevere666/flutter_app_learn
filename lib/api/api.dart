
///
/// BJU应用的API接口
///
class API {
  ///
  // ****************** indicate ***********************
  static const bool isNowTestMode = false;
  // ****************** 服务器信息 ***********************
  static const String protocol = 'http://';
  // static final String hostName = '192.168.85.1'; // 服务器IP地址 （本机模拟器使用）
  static const String hostName = 'bju.server.hzwei.top'; // 服务器IP地址 手机（真机）使用
  static const int port = 8080;
  static const String appName = 'bjuInformationService'; // app name
  // static final String baseUri = '$protocol$hostName:$port/$appName'; // 基本路径地址（本机模拟器使用）
  //static const String baseUri = '$protocol$hostName/$appName'; // 基本路径地址 手机（真机）使用
  static const String baseUri = 'http://192.168.199.161:8081/$appName';
  //  ******************** passport ********************
  /// 账号密码登录 === [POST]
  static const String npLogin = '$baseUri/passport/login/upLogin';
  /// 新用户注册接口 === [POST]
  static const String register = '$baseUri/passport/register/doRegister';
  /// 阿里手机验证码发送接口 [SMS/verifyCode/{phoneNumber}]===[POST]
  static const String  sms = '$baseUri/SMS/verifyCode/';
  /// 验证码验证 === [GET]
  static const String verifyCode = '$baseUri/passport/register/validate/code';
  /// 检测昵称唯一性接口 [passport/register/validate/nickname] === [POST]
  static const String  existNickname = '$baseUri/passport/register/validate/nickname';
  /// 检测手机号码唯一性接口 [passport/register/validate/mobile] === [POST]
  static const String  existMobile = '$baseUri/passport/register/validate/mobile';
  /// JPush推送接口 === [POST]
  static const String pushAll = '$baseUri/notification/all';  // 用于管理员发送公告推送信息

  /// 动态发布接口 === [POST]
  static const String publishMoving = '$baseUri/moving/publish';

  /// 用户中心计数项接口 === [GET]
  static const String allCounts = "$baseUri/user/info/counts";

  /// 获取模块下话题接口 === [GET]
  static const String topics = '$baseUri/module/topic';

  /// 获取院系及专业信息 === [GET] 
  static const String allFacultyAndSpecialty = '$baseUri/faculties';

  /// 获取最新动态 === [GET]
  static const String newMoving = '$baseUri/moving/new';

  /// 获取最新动态 === [GET]
  static const String hotMoving = '$baseUri/moving/hot';

  /// 获取指定动态的详情（路径参数） === [GET]
  static const String movingDetailsById = '$baseUri/moving/details/';

  /// 添加评论 === [POST]
  static const String addComment = '$baseUri/moving/comment/add';

  /// 模糊搜索@用户列表 === [GET]
  static const String searchAtUser = '$baseUri/user/fuzzy';

  /// 按照id获取用户信息（路径参数）=== [GET]
  static const String getUserInfoById = '$baseUri/user/info/';

  /// 校园新闻地址
  static const String campusNews = 'http://www.bjwlxy.edu.cn';

  /// 平台系统用户默认头像地址
  static const String defaultAvatarURL = '$baseUri/static/avatars/default_avatar.jpg';

  /// 修改用户信息 === [PUT]
  static const String updateUserInfo = '$baseUri/user/info/edit';

  /// 模糊搜索动态信息({searchKeyword}) === [GET]
  static const String fuzzySearchMoving = '$baseUri/moving/fuzzy/';

  /// 按照模块ID获取动态信息（{moduleId}） === [GET]
  static const String queryMovingByModuleId = '$baseUri/moving/module/';

  /// 退出登录APP == [POST]
  static const String logout = '$baseUri/passport/login/logout';

  /// 动态浏览量更新 === [PUT]
  static const String updateBrowseCount = '$baseUri/refresh/browse';

  /// 动态点赞量及点赞用户列表的更新 === [PUT]
  static const String updateMovingLikeData = '$baseUri/moving/refresh/like';

  /// 评论点赞量及点赞用户列表的更新 === [PUT]
  static const String updateCommentLikeData = '$baseUri/moving/comment/like';

  /// 动态图片访问的URL前缀
  static const String movingImagesBaseUrl = '$baseUri';

  /// 用户密码修改 === [PUT]
  static const String modifyPassword = '$baseUri/user/safe/password/modify';

  /// 用户头像修改 === [POST]
  static const String modifyAvatar = '$baseUri/user/info/avatar';

  /// 获取指定用户所有已发布的动态 === [GET]
  /// * 路径参数 userId
  static const String allMovingWithUser = '$baseUri/moving/published/';

  /// 获取指定用户草稿箱 === [GET]
  /// * 路径参数 userId
  static const String draftMovingWithUser = '$baseUri/moving/draft/';

  /// 保存动态到草稿箱 === [POST]
  /// * multipart/form-data
  static const String saveDraftMoving = '$baseUri/moving/temporary';

  /// 重新发布动态（草稿箱中的）=== [PUT]
  /// * 路径参数 movingId
  static const String republishMoving = '$baseUri/moving/republish/';

  /// 删除动态（已发布or草稿箱）=== [DELETE]
  /// * 路径参数 movingId
  static const String deleteMoving = '$baseUri/moving/delete/';

  ////获取URL的正确地址：
  static String getURL(String str){
    if(str == null || str.isEmpty){
      return "";
    }
    if(API.isNowTestMode){
      return str.trim();
    }else{
      return API.baseUri + str;
    }
  }
  //
}