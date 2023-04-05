import 'package:flutter_app_learn/api/api.dart';
import 'package:flutter_app_learn/constants/bju_constant.dart';
import 'package:flutter_app_learn/models/user_message.dart';
import 'package:flutter_app_learn/pages/details/moving_details_page.dart';
import 'package:flutter_app_learn/providers/jpush_provider.dart';
import 'package:flutter_app_learn/utils/bju_timeline_util.dart';
import 'package:flutter_app_learn/utils/db_util.dart';
import 'package:flustars/flustars.dart' hide ScreenUtil;
import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

///
/// 消息详情页面
/// 2020/2/23 19:48
///
class MessageDetailsPage extends StatefulWidget {

 // messageType
 int _messageType;

  MessageDetailsPage(this._messageType,{Key? key}) : super(key: key);

  @override
  State<MessageDetailsPage>  createState() => _MessageDetailsPageState(this._messageType);
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {

  // 无消息时的提示信息
  final List<String> _advices = ['没有相关通知！','您还没有被@呦！','没有与您相关的评论！','还没被赞过喔！'];
  // AppBar title text
  final List<String> _titles = ['系统通知','@我的','相关评论','赞我'];
  // 信息类型
  int _messageType;
  // 页面信息集合
  List<UserMessage> _messages = [];

 _MessageDetailsPageState(this._messageType);

 @override
 void initState() { 
   super.initState();
 }

 @override
 void didChangeDependencies() {
   super.didChangeDependencies();
   print('messageType:'+this._messageType.toString());
   _loadMessageByMessageType();
   print('_messages:'+this._messages.toString());

 }


  ///
  /// 通过消息类型ID加载消息
  Future<void> _loadMessageByMessageType() async {
    var mobile = SpUtil.getString(BJUConstants.loginUserMobile, defValue: null);
    if(mobile == null){
      return;
    }
    // 查询数据
    final List<UserMessage> messageList = await DBUtil.queryMessagesWithTypeAndOwner(
        _messageType,
        mobile
        //SpUtil.getString(BJUConstants.loginUserMobile, defValue: null)
    ).catchError((onError){
        print('信息详情页获得信息出错了！');
        print(onError);
        return <UserMessage>[];
    });
    print('信息详情页面，获得信息数据为：messageList=${messageList.toString()}');
    if(messageList.isEmpty) return;
    if(!mounted) return;
    setState(() {
      // 查找的信息不为空，
      _messages = messageList;
    });
    print('信息详情页面，信息详情页的模型为：_messages= ' + _messages.toString());

  }


  @override
  Widget build(BuildContext context) {

    // 初始化屏幕大小用于适配
    // ScreenUtil.init(context, width:750,height:1334);
    
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed:() => Navigator.of(context).pop()),
        title: Text(this._titles[this._messageType]),
      ),
      body: Consumer<JPushProvider>(
        builder: (context, jpushProvider, child){
          return this._messages.isEmpty 
          ? Center(
                child: Text(_advices[this._messageType],style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    wordSpacing: 2,
                    color: Colors.black38,
                  ),
                ),
          ) 
          : RefreshIndicator(
              child: ListView.separated(
                itemBuilder: (context,index){

                  return GestureDetector(
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage:  NetworkImage(API.baseUri + (this._messages[index].fromUserAvatar.isNotEmpty ? this._messages[index].fromUserAvatar : '/images/avatars/bju_app.png'),
                          ),
                      ),
                      title: Text(this._messages[index].title, style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          // letterSpacing: 0.8,
                          color: Colors.black54
                        ),
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // 评论内容
                          Text(this._messages[index].content, 
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                // letterSpacing: 1,
                                color: Colors.black38,
                              ),
                          ),
                          // 时间
                          Text(BjuTimelineUtil.formatDateStr(this._messages[index].receivedTime),
                            maxLines: 2,
                            style:TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.lightBlue[400]
                            )
                          )
                        ],
                      ),
                      trailing: this._messageType == 0 ? null : GestureDetector(
                        child: Icon(FontAwesomeIcons.chevronRight, size: 32, color: Colors.lightBlue[300],),
                        onTap: (){
                          print('去动态详情页面');

                          Navigator.push(context, MaterialPageRoute(builder: (context)=> MovingDetailsPage(this._messages[index].queryId)));

                        },
                      ),
                    ),
                    onTap: (){
                      print('用户点击了评论列表$index');
                    },
                  );
                }, 
                separatorBuilder: (context,index){
                  return Divider(height: 5, thickness: 0.8, color: Colors.blueGrey[200],);
                }, 
                itemCount: this._messages.length == 0 ? 1: this._messages.length
              ), 
              onRefresh: _loadMessageByMessageType,
            );
          
        }
      ),
    );
  }
} 











