import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///
/// 网页视图
/// 2020/04/02 15:20
///
class BrowserPage extends StatefulWidget {

  /// 页面标题
  final String _pageTitle;
  /// 网页连接
  final String _url;

  const BrowserPage(this._pageTitle,this._url,{Key? key}) : super(key: key);

  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late final WebViewController controller;
  @override
  void initState() {
    // TODO: implement initState
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget._url));
    super.initState();
  }
  ///
  /// web页面体
  Widget _webBody(){
    return widget._url.trim().isEmpty
     ? const Center(child: Text('无效页面！连接地址错误...', style: TextStyle(color: Colors.red),),)
     : WebViewWidget(controller: controller);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed:(){
          Navigator.of(context).pop();
        }),
        title: Text(widget._pageTitle??'无效页面'),
      ),
      body: _webBody(),
    );
  }
}