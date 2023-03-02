import "dart:math";
import 'package:flutter_app_learn/models/comment.dart';
import 'package:flutter_app_learn/models/moving.dart';

/// 动态详情模型
/// 2020/3/20 15:42
class MovingDetails {

  int movingAuthorId;
  // String movingAuthorAvatar;
  String movingAuthorName;
  String movingAuthorPhone;
  String movingContent;
  int movingId;
  /// 图片组：英文‘,’分割
  List movingImages;
  String movingType;
  /// 话题组：英文‘,’分割
  List movingTopics;
  int movingLike;
  /// 点赞用户组：英文‘,’分割
  List<String> movingLikeUsers;
  int movingBrowse;
  String movingCreateTime;

  // 评论列表
  List<CommentVO> commentReplyList;


  MovingDetails({
    this.movingAuthorId = -1,
    // this.movingAuthorAvatar,
    this.movingAuthorName = "",
    this.movingAuthorPhone = "",
    this.movingContent = "",
    this.movingId = -1,
    this.movingImages = const [],
    this.movingType = "",
    this.movingTopics = const [],
    this.movingLike = -1,
    this.movingLikeUsers = const [],
    this.movingBrowse = -1,
    this.movingCreateTime = "",
    this.commentReplyList = const []
  });

  factory MovingDetails.fromJson(Map<String, dynamic> json) => MovingDetails(
      movingAuthorId: int.parse(json['movingAuthorId'].toString()),
      // movingAuthorAvatar: json['movingAuthorAvatar'],
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
      movingCreateTime: json['movingCreateTime'],
      commentReplyList: (
          json.putIfAbsent(
              'commentReplyList',
                  () => const []
          ) as List
      ).map<CommentVO>((m) =>
          CommentVO.fromJson(m)
      ).toList()
  );

  @override
  String toString() {
    return '{movingAuthorId: ' + this.movingAuthorId.toString()
        // +', movingAuthorAvatar:' + this.movingAuthorAvatar
        +', movingAuthorName:' + this.movingAuthorName
        +', movingAuthorPhone:' + this.movingAuthorPhone
        +', movingContent:' + this.movingContent
        +', movingId:' + this.movingId.toString()
        +', movingImages:' + this.movingImages.toString()
        +', movingType:' + this.movingType
        +', movingTopics:' + this.movingTopics.toString()
        +', movingLike:' + this.movingLike.toString()
        +', movingLikeUsers:' + this.movingLikeUsers.toString()
        +', movingBrowse:' + this.movingBrowse.toString()
        +', movingCreateTime:' + this.movingCreateTime
        +', commentReplyList:' + this.commentReplyList.toString() + '}';
  }
  //////////////////////////////////////////////////////////////////////////////
  static MovingDetails generateMovingDetailsForTest(){
    MovingDetails movingDetails = MovingDetails();
    movingDetails.movingAuthorId = Random().nextInt(10000);
    movingDetails.movingAuthorName = "movingAuthorName";
    movingDetails.movingAuthorPhone = "movingAuthorPhone";
    movingDetails.movingContent = "movingContent";
    movingDetails.movingId = Random().nextInt(10000);
    movingDetails.movingImages = const [
      "https://c-ssl.duitang.com/uploads/item/201708/15/20170815163956_nyt4u.jpeg",
      "https://img2.woyaogexing.com/2018/08/21/799350d803dd45f79099d19c4c0ae301!400x400.jpeg",
      "https://img2.woyaogexing.com/2018/08/21/83354d48f55d40768656cdbf83801a5a!400x400.jpeg"
    ];
    movingDetails.movingType = "movingType";
    movingDetails.movingTopics = const ["黑", "白", "红"];
    movingDetails.movingLike = Random().nextInt(1000);
    movingDetails.movingLikeUsers = const ["张三", "李四", "王五"];
    movingDetails.movingBrowse = Random().nextInt(10000);
    movingDetails.movingCreateTime = "0";
    //List<CommentVO>
    movingDetails.commentReplyList = CommentVO.generateCommentListForTest(10);
    return movingDetails;
  }
  //////////////////////////////////////////////////////////////////////////////
}