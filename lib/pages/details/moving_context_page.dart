import 'package:flutter_app_learn/api/api.dart';
import 'package:flutter_app_learn/models/comment.dart';
import 'package:flutter_app_learn/models/moving_details.dart';
import 'package:flutter_app_learn/models/response.dart';
import 'package:flutter_app_learn/models/user.dart';
import 'package:flutter_app_learn/net/bju_net.dart';
import 'package:flutter_app_learn/pages/at_choose_page.dart';
import 'package:flutter_app_learn/providers/login_provider.dart';
import 'package:flutter_app_learn/utils/bju_timeline_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class MovingContextPage extends StatefulWidget{
  //User? _user;
  final MovingDetails _movingDetails;
  const MovingContextPage(this._movingDetails,{Key? key}): super(key:key);
  @override
  State<MovingContextPage> createState() => MovingContextPageState();

}
//
class MovingContextPageState extends State<MovingContextPage>{
  late final MovingDetails _movingDetails;
  @override
  void initState(){
    super.initState();
    _movingDetails = widget._movingDetails;
  }
  @override
  Widget build(BuildContext context){
    final User? user = Provider.of<LoginProvider>(context, listen:false).loginUser;
    return ListView(
        shrinkWrap: true,
        // mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //movingAuthorName and time
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // movingAuthorName
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                child: Text(
                    _movingDetails.movingAuthorName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      wordSpacing: 2,
                      // height: 1.5,
                      color: Colors.lightBlue,
                    )
                ),
              ),
              // movingCreateTime
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                child: Text(
                    "${BjuTimelineUtil.formatDateStr(_movingDetails.movingCreateTime)}发布",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      wordSpacing: 2,
                      height: 1.5,
                      color: Colors.black54,
                    )
                ),
              ),
            ],
          ),
          // movingContent
          Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 8, 0, 0),
                child: Text(
                  _movingDetails.movingContent??'动态的内容',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    wordSpacing: 2.5,
                    height: 1.5,
                  ),
                ),
              )
          ),
          // movingImages 图片信息
          //(_movingDetails.movingImages != null && _movingDetails.movingImages.length > 0)
          _movingDetails.movingImages.isEmpty ? const SizedBox() : Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: GridView.count(
              shrinkWrap: true,
              padding: const EdgeInsets.all(2), // 内边距
              crossAxisCount: 3, // 列
              mainAxisSpacing: 2, // 纵向间距
              crossAxisSpacing: 2, // 水平间距
              //childAspectRatio: 16 / 9, // 宽高比，默认1.0
              children:_movingDetails.movingImages.map((img) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/gif/loading.jpg',
                  image: API.getURL(img),
                  fit: BoxFit.fill,
                ),
              ) ).toList(),
            ),
          ),
          // movingType and movingTopics 动态类型及标签
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    _movingDetails.movingType??'错误墙',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.lightBlue[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: _movingDetails.movingTopics.isEmpty ? const Text("没有标签信息！") : Wrap(
                      spacing: 1,
                      runAlignment: WrapAlignment.center,
                      children: _movingDetails.movingTopics.map((topic){
                        return ChoiceChip(
                          // avatar: Icon(FontAwesomeIcons.heart),
                          selectedColor: Colors.lightBlue[400], // 选中时的颜色
                          label: Text(topic,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                          selected: true,
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(),
          // 操作
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
            child: Row(
              mainAxisSize:MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // 浏览 点击后什么也不做 , movingBrowse 浏览次数
                GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 8, 5),
                        child: Icon(
                          FontAwesomeIcons.eye,
                          color: Colors.lightBlue[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text((_movingDetails.movingBrowse??0).toString()),
                      ),
                    ],
                  ),
                  onTap: (){
                    showToast('浏览');
                  },
                ),
                // 点赞
                GestureDetector(
                  //List<String> movingLikeUsers;
                  onTap: _movingDetails.movingLikeUsers?.contains(user?.userId.toString()??0)??false ? null : () async {
                    print('动态点赞');
                    if( user == null){
                      print('点赞失败，用户未登录');
                      showToast('请先登录！');
                      return;
                    }
                    // 已经点击过点赞按钮
                    if(_movingDetails.movingLikeUsers?.contains(user?.userId.toString())??false){
                      return;
                    }
                    //
                    final Map<String,dynamic> paramsMap = {
                      "movingId": _movingDetails.movingId,
                      "content" : _movingDetails.movingContent,
                      "alias" : _movingDetails.movingAuthorPhone,
                      "likeUserId": user.userId,
                      "likeUserNickname" : user.userNickname,
                      "likeUserAvatar" : user.userAvatar
                    };
                    // 请求服务器刷新数据
                    ResponseData resData = await BjuHttp.put(
                        API.updateMovingLikeData,
                        params: paramsMap
                    ).then((onValue) => ResponseData.fromJson(onValue.data))
                        .catchError((onError){
                      print('用户点赞请求异常！');
                      print(onError);
                      showToast('请求服务器异常');
                      //return;
                    });
                    if(resData == null){
                      showToast('网络错误！');
                      return;
                    }
                    if(resData.statusCode == 0){
                      if(!mounted) return;
                      setState(() {
                        _movingDetails.movingLike += 1;
                        // 新的点赞列表
                        final List<String> newUserList = _movingDetails.movingLikeUsers??[];
                        newUserList.add(user.userId.toString());
                        _movingDetails.movingLikeUsers = newUserList;
                      });
                      print('点赞过后，动态的点赞量为：' + _movingDetails.movingLike.toString() + ' 动态的点赞用户列表为：' + _movingDetails.movingLikeUsers.toString());
                    }
                    // 弹出提示信息
                    showToast(resData.message);

                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 8, 5),
                        child: Icon(
                          FontAwesomeIcons.solidThumbsUp,
                          color: _movingDetails.movingLikeUsers?.contains(user?.userId.toString()??0)??false
                              ? Colors.lightBlue[400] : Colors.black38,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(_movingDetails.movingLike?.toString()??'0'),
                      ),
                    ],
                  ),
                ),
                // 评论
                GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 8, 5),
                        child: Icon(
                          FontAwesomeIcons.commentDots,
                          color: (_movingDetails.commentReplyList?.length??0) > 0 ? Colors.lightBlue[400] : Colors.black38,),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(_movingDetails.commentReplyList?.length?.toString()??'0'),
                      ),
                    ],
                  ),
                  onTap: (){
                    //////////////////////////print('评论');/////////////////////
                    // 用户登录与否
                    if(user == null){
                      showToast('请先登录！');
                      return;
                    }

                    //_showCommentWindow(context,user);

                  },
                ),
              ],
            ),
          ),

          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                  child: Text('全部评论如下', style: TextStyle(
                    fontSize: 16,
                    wordSpacing: 4,
                    fontWeight: FontWeight.w600,
                    color: Colors.lightBlue[300],
                  ),
                  ),
                ),
                // 右侧图标
                Icon(FontAwesomeIcons.ellipsisVertical, color: Colors.lightBlue[300],)
              ],
            ),
          ),
          Divider(color: Colors.blueGrey[200]),
        ]
    );
  }
}