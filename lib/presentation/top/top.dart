import 'package:firestore_firebaseauth/presentation/top/top_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Top extends StatelessWidget {
  const Top({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TopModel>(
        create: (_) => TopModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('QR Code Demo'),
          ),
          body: Center(
            child: QrImage(
              data: 'https://twitter.com',
              size: 200,
              embeddedImage: AssetImage('images/twitter.png'),
              embeddedImageStyle: QrEmbeddedImageStyle(size: Size(50, 50)),
            ),
          ),
        ));
  }
}
