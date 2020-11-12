import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wikipedia_app/data/model/local_model/wikipedia.dart';
import 'package:wikipedia_app/ui/components/custom_image.dart';
import 'package:wikipedia_app/ui/components/text_custom_style.dart';
import 'package:wikipedia_app/values/styles.dart';
import 'package:wikipedia_app/values/colors.dart' as colors;

class ItemWikipediaWidget extends StatelessWidget {
  final Wikipedia wikipedia;

  ItemWikipediaWidget({@required this.wikipedia});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 80,
              child: Stack(
                children: [
                  Center(
                    child: SpinKitCircle(
                      color: colors.loadingColor,
                      size: 30.0,
                    ),
                  ),
                  wikipedia.thumbnail != ""
                      ? Container(
                          color: colors.primaryColor,
                          child: CustomImage.network(
                              url: "https:" + wikipedia.thumbnail,
                              fit: BoxFit.scaleDown),
                        )
                      : Container(),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width /
                  (wikipedia.thumbnail != null ? 1.62 : 1.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      child: TextCustomStyle(wikipedia.title,
                          style: styleRegularBlue,
                          maxLine: 2,
                          isOverflow: true)),
                  Html(data: wikipedia.excerpt),
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      child: TextCustomStyle(
                        wikipedia.description,
                        style: styleRegularLightGreen,
                        maxLine: 2,
                        isOverflow: true,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
