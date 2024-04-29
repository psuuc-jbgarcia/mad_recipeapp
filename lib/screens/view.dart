import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ViewRecipe extends StatelessWidget {
  final String url;

  const ViewRecipe({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.redAccent; // Appetizing red

    return WebviewScaffold(
      url: url,
      appBar: AppBar(
centerTitle: true,
        title: Text(
          "View",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: primaryColor,
      ),
    );
  }
}
