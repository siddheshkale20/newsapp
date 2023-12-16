import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class ViewNews extends StatefulWidget {
  late String url;
  ViewNews(this.url);
  @override
  State<ViewNews> createState() => _ViewNewsState();
}

class _ViewNewsState extends State<ViewNews> {
  late String finalurl;
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    if(widget.url.toString().contains("http://"))
    {
      finalurl=widget.url.toString().replaceAll("http://", "https://");
    }
    else {
      finalurl=widget.url;
    }
    _controller = WebViewController()
      ..loadRequest(
        Uri.parse(finalurl),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
          child: WebViewWidget(controller:_controller)
      ),
    );
  }
}
