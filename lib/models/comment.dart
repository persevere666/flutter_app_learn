import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_learn/utils/bju_timeline_util.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';


import 'package:flutter_app_learn/models/user.dart';
import 'package:flutter_app_learn/api/api.dart';

///
/// 评论VO
/// 2020/03/24 16:45
///
class CommentVO {
  /// 评论ID
  int commentId;
  /// 评论内容
  String commentContent;
  /// 评论点赞量
  int commentLike;
  /// 点赞用户列表
  List<String> commentLikeUsers;
  /// 评论时间
  String commentCreateTime;
  /// 评论人ID
  int commentAuthorId;
  /// 评论人头像
  String commentAuthorAvatar;
  /// 评论人昵称
  String commentAuthorName;
  /// 评论人手机号
  String commentAuthorPhone;
  /// 父评论ID
  int parentCommentId;
  /// 父评论内容
  String parentCommentContent;
  /// 父评论点赞量
  int parentCommentLike;
  /// 父评论创建时间
  String parentCommentCreateTime;
  /// 父评论作者ID
  int parentCommentAuthorId;
  /// 父评论作者头像
  String parentCommentAuthorAvatar;
  /// 父评论作者昵称
  String parentCommentAuthorName;
  /// 父评论作者手机号码
  String parentCommentAuthorPhone;


  CommentVO({
    this.commentId=-1,
    this.commentContent="",
    this.commentLike = -1,
    this.commentLikeUsers = const [],
    this.commentCreateTime = "",
    this.commentAuthorId = -1,
    this.commentAuthorAvatar = "",
    this.commentAuthorName = "",
    this.commentAuthorPhone = "",
    this.parentCommentId = -1,
    this.parentCommentContent = "",
    this.parentCommentLike = -1,
    this.parentCommentCreateTime = "",
    this.parentCommentAuthorId = -1,
    this.parentCommentAuthorAvatar = "",
    this.parentCommentAuthorName = "",
    this.parentCommentAuthorPhone = "",
  });


  factory CommentVO.fromJson(Map<String, dynamic> json) => CommentVO(
      commentId: int.parse(json['commentId'].toString()),
      commentContent: json['commentContent'],
      commentLike: int.parse(json['commentLike'].toString()),
      commentLikeUsers: json.putIfAbsent('commentLikeUsers', () => "").toString().split(","),
      commentCreateTime: json['commentCreateTime'],
      commentAuthorId: int.parse(json['commentLike'].toString()),
      commentAuthorAvatar: json['commentAuthorAvatar'],
      commentAuthorName: json['commentAuthorName'],
      commentAuthorPhone: json['commentAuthorPhone'],
      parentCommentId: json.putIfAbsent('parentCommentId', () => -1),
      parentCommentContent: json.putIfAbsent('parentCommentContent', () => ""),
      parentCommentLike: json.putIfAbsent('parentCommentLike', () => null),
      parentCommentCreateTime: json.putIfAbsent('parentCommentCreateTime', () => null),
      parentCommentAuthorId: json.putIfAbsent('parentCommentAuthorId', () => null),
      parentCommentAuthorAvatar: json.putIfAbsent('parentCommentAuthorAvatar', () => null),
      parentCommentAuthorName: json.putIfAbsent('parentCommentAuthorName', () => null),
      parentCommentAuthorPhone: json.putIfAbsent('parentCommentAuthorPhone', () => null),
  );

  @override
  String toString() {
    /*
    return '''{
      commentId: ${commentId.toString()},
      commentContent: $commentContent,
      commentLike: ${commentLike.toString()},
      commentContent: ${commentContent},
      commentContent: ${commentContent},
      commentContent: ${commentContent},
    }''';
    */
    return '{: commentId: ' + this.commentId.toString()
            +', commentContent: ' + this.commentContent
            +', commentLike: ' + this.commentLike.toString()
            +', commentLikeUsers: ' + this.commentLikeUsers.toString()
            +', commentCreateTime: ' + this.commentCreateTime
            +', commentAuthorId: ' + this.commentAuthorId.toString()
            +', commentAuthorAvatar: ' + this.commentAuthorAvatar
            +', commentAuthorName: ' + this.commentAuthorName
            +', commentAuthorPhone: ' + this.commentAuthorPhone
            +', parentCommentId: ' + this.parentCommentId.toString()
            +', parentCommentContent: ' + this.parentCommentContent
            +', parentCommentLike: ' + this.parentCommentLike.toString()
            +', parentCommentCreateTime: ' + this.parentCommentCreateTime
            +', parentCommentAuthorId: ' + this.parentCommentAuthorId.toString()
            +', parentCommentAuthorAvatar: ' + this.parentCommentAuthorAvatar
            +', parentCommentAuthorName: ' + this.parentCommentAuthorName
            +', parentCommentAuthorPhone: ' + this.parentCommentAuthorPhone + '}';
  }
  //////////////////////////////////////////////////////////////////////////////
  static CommentVO generateCommentForTest(){
    CommentVO commentVO = CommentVO();
    commentVO.commentId=Random().nextInt(1000000);
    commentVO.commentContent="commentContent: this is a long story, long long ago, there ia a evil dragon, then he change to be a little birdh and fly to the moon, at last he become a big apple";
    commentVO.commentLike = Random().nextInt(10000);
    commentVO.commentLikeUsers = const ["commentLikeUsers1","commentLikeUsers2","commentLikeUsers3"];
    commentVO.commentCreateTime = "0";
    commentVO.commentAuthorId = Random().nextInt(10000);
    commentVO.commentAuthorAvatar =
        "https://c-ssl.duitang.com/uploads/item/201710/30/20171030124218_idAfM.jpeg";
    commentVO.commentAuthorName = "commentAuthorName";
    commentVO.commentAuthorPhone = "commentAuthorPhone";

    commentVO.parentCommentId = Random().nextInt(10000);
    commentVO.parentCommentContent = "parentCommentContent:ha ha ha ha, I understand it and then I become the dragon, I kill a lot of people, but I did a good thing, I know what I did. I will never regret for what I did.";
    commentVO.parentCommentLike = Random().nextInt(10000);
    commentVO.parentCommentCreateTime = "parentCommentCreateTime";
    commentVO.parentCommentAuthorId = Random().nextInt(10000);
    commentVO.parentCommentAuthorAvatar =
        "https://www.ssfiction.com/wp-content/uploads/2020/08/20200805_5f2b1669e9a24.jpg";
    commentVO.parentCommentAuthorName = "parentCommentAuthorName";
    commentVO.parentCommentAuthorPhone = "parentCommentAuthorPhone";
    return commentVO;
  }

  static List<CommentVO> generateCommentListForTest(int length){
    List<CommentVO> commentList = [];
    for(int i=0; i<length; i++){
      CommentVO tmpComment = generateCommentForTest();
      commentList.add(tmpComment);
    }
    return commentList;
  }
}