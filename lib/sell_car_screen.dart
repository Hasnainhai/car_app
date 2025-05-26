import 'package:fl_carmax/helper/language_constant.dart';
import 'package:fl_carmax/utils/constant.dart';
import 'package:fl_carmax/utils/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class SellCarScreen extends StatelessWidget {
  const SellCarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:   Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              style: blackSemiBold16,
              children: [
                const TextSpan(text: "Please visit the website "),
             TextSpan(
               text: 'wowcar.co.th',
               style: blackSemiBold16.copyWith(
                 decoration: TextDecoration.underline,
                 color: Colors.blue,
               ),
               recognizer: TapGestureRecognizer()
                 ..onTap = () async {
                   final Uri url = Uri.parse('https://www.wowcar.co.th/login-and-register/');
                   if (!await launchUrl(url)) {
                    if(context.mounted){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not launch website')),
                      );
                    }
                   }
                 },
             ),
              ],
            ),
          ),
        ),
      ],
    ),
    );
      /*const WebViewPage(
      url: 'https://www.wowcar.co.th/login-and-register/',
      title: 'Sell Car',
    );*/
  }

}

/*class WebViewPage extends StatelessWidget {
  final String url;
  final String title;

  const WebViewPage({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
        controller: WebViewController()..loadRequest(Uri.parse(url)));
  }
}*/
