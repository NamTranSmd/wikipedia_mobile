import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikipedia_app/base/base_state.dart';
import 'package:wikipedia_app/data/model/error/search_error.dart';
import 'package:wikipedia_app/data/model/local_model/wikipedia.dart';
import 'package:wikipedia_app/data/model/response/search_response.dart';
import 'package:wikipedia_app/routes/navigation.dart';
import 'package:wikipedia_app/ui/components/custom_image.dart';
import 'package:wikipedia_app/ui/components/loading.dart';
import 'package:wikipedia_app/ui/modules/home/contract/home_contract.dart';
import 'package:wikipedia_app/ui/modules/home/view_model/home_view_model.dart';
import 'package:wikipedia_app/ui/modules/wikipedia_detail/view/wikipedia_detail.dart';
import 'package:wikipedia_app/ui/components/box_search_textfield.dart';
import 'package:wikipedia_app/ui/components/item_wikipedia.dart';
import 'package:wikipedia_app/utils/check_internet.dart';
import 'package:wikipedia_app/values/images.dart';
import 'package:wikipedia_app/values/strings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> implements HomeContract {
  HomeViewModel mModel;

  @override
  void initState() {
    super.initState();
    mModel = Provider.of<HomeViewModel>(context, listen: false);
    mModel.contract = this;
  }

  @override
  Widget buildWidget() {
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
                child: LoadingWidget(
              message: please_wait,
              status: model.isLoadData,
              child: Stack(
                children: [
                  Container(
                    child: Center(
                      child: CustomImage(
                        url: wikipedia_logo,
                        width: 240,
                        height: 240,
                      ),
                    ),
                  ),
                  _buildBody(model)
                ],
              ),
            )),
          ));
    });
  }

  Widget _buildBody(HomeViewModel model) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildSearch(model),
          model.searchResponse != null && model.searchResponse.pages != null
              ? _buildListWiki(model.searchResponse.pages)
              : Container()
        ],
      ),
    );
  }

  Widget _buildSearch(HomeViewModel model) {
    return Container(
      padding: EdgeInsets.only(top: 30, right: 15, left: 15, bottom: 20),
      child: Column(
        children: [
          BoxSearchTextField(
            controller: model.searchTextController,
            hintText: search_hint_text,
            onSearch: (value) {
              model.onSearch();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListWiki(List<Wikipedia> wikipedia) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: wikipedia.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  checkInterNet().then((value) {
                    if (value != null && value) {
                      pushWithAnimation(context,
                          WikiDetailPage(title: wikipedia[index].title));
                    } else {
                      showDialog();
                    }
                  });
                },
                child: ItemWikipediaWidget(wikipedia: wikipedia[index]));
          }),
    );
  }

  @override
  void onSearchError(SearchError error) {
    mModel.searchError();
  }

  @override
  void onSearchSuccess(SearchResponse response) {
    mModel.searchSuccess(response);
  }

  void showDialog() {
    return showDialogBox(please_connect, error, <Widget>[
      FlatButton(
        onPressed: () {
          pop(context);
        },
        child: Text(close, style: TextStyle(color: Colors.blueAccent)),
      )
    ]);
  }
}
