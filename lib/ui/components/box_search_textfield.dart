import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wikipedia_app/base/base_state.dart';
import 'package:wikipedia_app/ui/components/custom_image.dart';
import 'package:wikipedia_app/values/colors.dart';
import 'package:wikipedia_app/values/dimens.dart';
import 'package:wikipedia_app/values/fonts.dart';
import 'package:wikipedia_app/values/images.dart';

class BoxSearchTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Function onSearch;
  BoxSearchTextField({this.hintText, this.controller,this.onSearch});

  @override
  _BoxSearchTextFieldState createState() => _BoxSearchTextFieldState();
}

class _BoxSearchTextFieldState extends BaseState<BoxSearchTextField> {
  @override
  Widget buildWidget() {
    return
       Container(
        decoration: BoxDecoration(
            color: primaryColor, borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                widget.onSearch();
              },
              child: CustomImage(
                url: ic_search,
                width: 18,
                height: 18,
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            Container(
              width: 8,
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                onEditingComplete: (){
                  widget.onSearch();
                },
                textInputAction: TextInputAction.search,
                style: TextStyle(
                    color: textColorBlack,
                    fontFamily: sanFranciscoRegular,
                    fontSize: fontText),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 0),
                    isDense: true,
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.2),
                        fontFamily: sanFranciscoRegular,
                        fontSize: fontText)),
              ),
            ),
          ],
        ),
    );
  }
}
