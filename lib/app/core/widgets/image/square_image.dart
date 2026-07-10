import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_image.dart';
class SquareImage extends StatelessWidget {
  const SquareImage({super.key, this.url, this.failUrl, this.emptyUrl, this.width, this.height, this.fit,
    this.withOval=true
  });

  final String? url;
  final String? failUrl;
  final String? emptyUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool? withOval;

  @override
  Widget build(BuildContext context) {

    return
      withOval==true?
      ClipOval(child:

    BaseImage(
      url:url,
      boxFit:fit?? BoxFit.contain,
      // height: 100,
      // width: 100,
    )
      ,):
      BaseImage(
        url: url,
        boxFit:fit?? BoxFit.contain,
      )
    ;
  }
}
