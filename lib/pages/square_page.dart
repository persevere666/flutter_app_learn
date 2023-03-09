import 'package:flutter/material.dart';

import 'package:badges/badges.dart' as badges;
import 'package:oktoast/oktoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_app_learn/api/api.dart';
import 'package:flutter_app_learn/models/moving.dart';
import 'package:flutter_app_learn/models/response.dart';
import 'package:flutter_app_learn/net/bju_net.dart';
import 'package:flutter_app_learn/pages/details/moving_details_page.dart';
import 'package:flutter_app_learn/pages/search_page.dart';
import 'package:flutter_app_learn/utils/bju_timeline_util.dart';

class SquarePage extends StatefulWidget {
  const SquarePage({Key? key}) : super(key: key);

  @override
  State<SquarePage> createState() => _SquarePageState();
}

class _SquarePageState extends State<SquarePage> with SingleTickerProviderStateMixin{
  //please remember the use of late
  late final TabController  _tabController;
  /// 动态列表
  List<Moving>? _movingList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener((){
      // 加载框
      showToastWidget(
        const CircularProgressIndicator(backgroundColor: Colors.black38),
        context: context,
        duration: const Duration(milliseconds: 3000),
        position: ToastPosition.center,
      );
      ////////////////////////why here////////////////////////////////
      _getMovingListWithTabIndex(_tabController.index);
      ////////////////////////////////////////////////////////////////
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ////////////////////////why here////////////////////////////////
    _getMovingListWithTabIndex(_tabController.index);
    ////////////////////////////////////////////////////////////////
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  ///
  /// ##### 获取动态列表
  /// 依据tab的index属性确定：最新or最热
  /// update the value of _movingList if BjuHttp is success
  /// * [index] tab的index切换与否
  ///
  _getMovingListWithTabIndex(int index) async {
    var tmpMovingList = await Moving.getMovingListByIndex(index);
    if(tmpMovingList == null || tmpMovingList.isEmpty || !mounted) return;
    setState(() {
      _movingList = tmpMovingList;
    });
  }



  @override
  Widget build(BuildContext context) {
    // 初始化屏幕大小用于适配, there is something wrong
    ScreenUtil.init(context, designSize: const Size(750,1334));
    //
    return Material(
        child:NestedScrollView(
          headerSliverBuilder: (context, b){
            return <Widget>[
              SliverAppBar(
                floating: true,
                pinned: true,
                leading: BackButton(
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: ListTile(
                  title: const Text('校园朋友圈'),
                  trailing: GestureDetector(
                    child: const Icon(
                        FontAwesomeIcons.magnifyingGlass
                    ),
                    onTap: ()=> Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchPage()
                        )
                    ),
                  ),
                ),
                centerTitle:true,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(
                      ScreenUtil().setHeight(89)
                  ),
                  child: TabBar(
                    indicatorColor:Colors.white,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.fiber_new),
                            Text("最新")
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(FontAwesomeIcons.fire),
                            Text("最热")
                          ],
                        ),
                      )
                    ],
                    controller: _tabController,
                  ), 
                ),
                /* expandedHeight: 100, */
              )
            ];
          }, 
          body: TabBarView(
            controller: _tabController,
            children: [
              Moving.crateTabBarView(_movingList, context),// new
              Moving.crateTabBarView(_movingList, context),// hot
            ]
          ),
        )
      // ),
    );
  }
}