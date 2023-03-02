import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_app_learn/utils/bju_timeline_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_app_learn/constants/bju_constant.dart';
import 'package:flutter_app_learn/api/api.dart';
import 'package:flutter_app_learn/net/bju_net.dart';
import 'package:flutter_app_learn/models/response.dart';
import 'package:flutter_app_learn/pages/details/moving_details_page.dart';
///
/// 动态模型
/// 2020/2/23 22:06
///
class Moving {
  int movingAuthorId;
  String movingAuthorAvatar;
  String movingAuthorName;
  String movingAuthorPhone;
  String movingContent;

  ///
  int movingId;

  /// 图片组：英文‘,’分割
  List movingImages;

  String movingType;

  /// 话题组：英文‘,’分割
  List movingTopics;

  int movingLike;

  /// 点赞用户组：英文‘,’分割
  List movingLikeUsers;

  int movingBrowse;
  int movingCommentCount;
  String movingCreateTime;


  Moving({
    this.movingAuthorId = -1,
    this.movingAuthorAvatar = "http://www.devio.org/img/avatar.png",
    this.movingAuthorName = "芒果A",
    this.movingAuthorPhone = "no phone",
    this.movingContent = """今天天气很棒，晴空万里！飞机划过天空留下了一条优美的掠影，仿佛在
        向我们示意它要去何方？希望疫情快点结束，我从未向现在这样渴望上学过。中国加油，武汉加油！""",
    this.movingId = -1,
    this.movingImages = const [
      "http://www.devio.org/img/avatar.png",
      "http://www.devio.org/img/avatar.png",
      "http://www.devio.org/img/avatar.png"
     ],
    this.movingType = "unknown type",
    this.movingTopics = const ['女神','小仙女','男神','二次元','小姐姐','小哥哥'],
    this.movingLike = -1,
    this.movingLikeUsers = const [],
    this.movingBrowse = -1,
    this.movingCommentCount = -1,
    this.movingCreateTime = ""
  });

  factory Moving.fromJson(Map<String,dynamic> json) => Moving(
    movingAuthorId: int.parse(json['movingAuthorId'].toString()),
    movingAuthorAvatar: json['movingAuthorAvatar'],
    movingAuthorName: json['movingAuthorName'],
    movingAuthorPhone: json['movingAuthorPhone'],
    movingContent: json['movingContent'],
    movingId: int.parse(json['movingId'].toString()),
    movingImages: json.putIfAbsent('movingImages', () => "").toString().split(','),
    movingType: json['movingType'],
    movingTopics: json.putIfAbsent('movingTopics', () => "").toString().split(','),
    movingLike: int.parse(json['movingLike'].toString()),
    movingLikeUsers: json.putIfAbsent('movingLikeUsers', () => "").toString().split(','),
    movingBrowse: int.parse(json['movingBrowse'].toString()),
    movingCommentCount: int.parse(json['movingCommentCount'].toString()),
    movingCreateTime: json['movingCreateTime']
  );

 @override
  String toString() {
    return '''{ movingAuthorId: $movingAuthorId
     , movingAuthorAvatar: $movingAuthorAvatar
     , movingAuthorName: $movingAuthorName
     , movingAuthorPhone: $movingAuthorPhone
     , movingContent: $movingContent
     , movingId: $movingId
     , movingImages: ${movingImages.toString()}
     , movingType: $movingType
     , movingTopics: ${movingTopics.toString()}
     , movingLike: $movingLike
     , movingLikeUsers: ${movingLikeUsers.toString()}
     , movingBrowse: $movingBrowse
     , movingCommentCount: $movingCommentCount
     , movingCreateTime: $movingCreateTime 
    }''';
  }
 static Future<List<Moving>?> getMovingListByIndex(int index) async{
   /// for test
   if(API.isNowTestMode){
     return [
       Moving(),
       Moving(),
       Moving()
     ];
   }
   //
   ResponseData resData = await BjuHttp.get(
       index == 0 ? API.newMoving : API.hotMoving
   ).then((onValue) =>
       ResponseData.fromJson(onValue.data)
   ).catchError((onError){
     showToast('请求服务器异常！');
     return ResponseData();
   });

   try{
     if(resData.statusCode == 0) {
       return (resData.res as List<dynamic>).map<Moving>((moving) {
         return Moving.fromJson(moving);
       }).toList();
     }else{
       showToast("statusCode is not equal 0, resData=${resData.toString()}");
       return null;
     }
   }catch(e){
     showToast("解析错误：resData = ${resData.toString()}");
      return null;
   }
 }
  ///
  ///
  static gotoMovingDetails(Moving moving, BuildContext context) async {

    // 获取当前点击的动态ID
    if(moving == null) return;

    final int movingId = moving.movingId;
    if(movingId == 0){
      showToast('动态信息有误！');
      return;
    }
    //
    // print('进入用户动态详情页面: movingId='+movingId.toString());
    // 跳转到动态详情页面，返回时自动修改当前动态中的数据（点赞量，浏览量，评论量）
    final Map<String,int>? countsMap = await Navigator.push<Map<String,int>>(
        context,
        MaterialPageRoute(builder:
            (context)=> MovingDetailsPage(movingId)
        )
    );
    //print('获得返回的数据为：countsMap= ' + countsMap.toString());
    return;
    // 修改当前动态的数据
  }
  ///
  ///
  static Widget createTopicsWidget(List<dynamic> topics){
   if(topics ==null || topics.isEmpty){
     return const Text("no topics in moving !!!");
   }else{
     return Wrap(
       spacing: 1,
       runAlignment: WrapAlignment.center,
       children: topics.map((topic){
         return ChoiceChip(
           avatar: const Icon(FontAwesomeIcons.heart),
           selectedColor: Colors.grey[300], // 选中时的颜色
           label: Text(
             topic.toString(),
             style: const TextStyle(
                 color: Colors.lightBlue,
                 fontSize: 12,
                 fontWeight: FontWeight.w300
             ),
           ),
           selected: true,
         );
       }).toList(),
    );
   }
   return Container();
 }
  ///
  ///
  static Widget createImagesWidget(List<dynamic> images){
   if(images ==null || images.isEmpty){
     return const SizedBox();
   }else {
     return GridView.count(
       shrinkWrap: true,
       padding: const EdgeInsets.all(2),
       // 内边距
       crossAxisCount: 3,
       // 列
       mainAxisSpacing: 2,
       // 纵向间距
       crossAxisSpacing: 2,
       // 水平间距
       //childAspectRatio: 16 / 9, // 宽高比，默认1.0
       children: images.map((img) {
         return FadeInImage.assetNetwork(
           placeholder: 'assets/gif/loading.jpg',
           image: API.getURL(img),
           fit: BoxFit.fill,
         );
       }).toList(),
     );
   }
  }
  static Widget crateTabBarView(List<Moving>? movingList, BuildContext context){
    if(movingList ==null || movingList!.isEmpty){
      return const Center(
          child: Text(
              '没有动态信息！',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black38,
                wordSpacing: 2,
              )
          )
      );
    }else{
      return ListView.separated(
        itemBuilder: (context,index){
          int movingListLength = movingList!.length;
          //
          Moving tmpMoving = movingList![index];
          //
          final topicsWidget = createTopicsWidget(tmpMoving.movingTopics);
          //
          double edgeBottomLen = (index != movingList!.length-1)?0:10;
          //
          final movingImages = tmpMoving.movingImages;
          //
          String movingAuthorAvatarURL = API.getURL(tmpMoving.movingAuthorAvatar);
          //API.baseUri+tmpMoving.movingAuthorAvatar??API.defaultAvatarURL;
          //
          String movingCreateTime = BjuTimelineUtil.formatDateStr(tmpMoving.movingCreateTime)??'无效时间';
          //
          String movingAuthorName = tmpMoving.movingAuthorName;
          //
          String movingType = tmpMoving.movingType;
          //
          String movingContent = tmpMoving.movingContent;
          //
          String movingLike = tmpMoving.movingLike.toString();
          //
          String movingBrowse = tmpMoving.movingBrowse.toString();
          //
          String movingCommentCount = tmpMoving.movingCommentCount.toString();

          return Card(
            elevation: 5,
            shape:const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))
            ),
            margin: EdgeInsets.fromLTRB(5,0,5,edgeBottomLen),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 实际高度为所有子元素的高度和
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start, // 水平对齐方式
              children: <Widget>[
                // 动态发布者信息
                ListTile(
                  leading: ClipOval(
                      child:FadeInImage.assetNetwork(
                        placeholder: 'assets/gif/loading.jpg',
                        image: movingAuthorAvatarURL,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      )
                  ),
                  title: GestureDetector(
                    child: Text(
                      movingAuthorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.lightBlue,
                      ),
                    ),
                    onTap: (){
                      showToast("TODO...");
                      // 进入用户详情页面
                    },
                  ),
                  subtitle: Text(movingCreateTime),
                ),
                //Divider(),
                // 动态文本内容
                Padding(
                  padding: const EdgeInsets.only(left:5,right:3),
                  child: Text(movingContent,textAlign: TextAlign.start),
                ),
                // 图片信息
                createImagesWidget(movingImages)
                ,
                const Divider(),
                // 动态类型及标签
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:6,right:3),
                      child: Text(
                        movingType,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      // flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: topicsWidget,
                      ),
                    )
                  ],
                ),
                const Divider(),
                // 操作
                Row(
                  mainAxisSize:MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: GestureDetector(
                        child: badges.Badge(
                          //alignment:Alignment.topRight ,
                          // BadgePosition
                          badgeContent: Text(movingLike),
                          child: const Icon(FontAwesomeIcons.solidThumbsUp),
                        ),
                        onTap: (){
                          // 动态详情页面
                          gotoMovingDetails(tmpMoving, context);
                          return;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: GestureDetector(
                        child: badges.Badge(
                          badgeContent: Text(movingBrowse),
                          child: const Icon(FontAwesomeIcons.eye),
                        ),
                        onTap: (){
                          // print('朋友圈-->浏览');
                          // 动态详情页面
                          gotoMovingDetails(tmpMoving, context);
                          return;
                        },
                      ),
                    ),

                    Padding(//
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: GestureDetector(
                        child: badges.Badge(
                          badgeContent: Text(movingCommentCount),
                          child: const Icon(FontAwesomeIcons.commentDots),
                        ),
                        onTap: (){
                          // print('朋友圈-->评论');
                          // 动态详情页面
                          gotoMovingDetails(tmpMoving, context);
                          return;
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
        //
        separatorBuilder: (context,index){
          // 元素间的分割区
          // return SizedBox(height: 10,child: Divider(height: ScreenUtil().setHeight(10),));
          return SizedBox(height: ScreenUtil().setHeight(20),);
        },
        itemCount: movingList!.length,

      );
    }

  }

  //
}



