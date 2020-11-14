import 'package:flutter/cupertino.dart';
import 'package:wikipedia_app/data/di/injector.dart';
import 'package:wikipedia_app/data/model/local_model/wiki_detail.dart';
import 'package:wikipedia_app/data/sources/repositories/wikipedia_detail/wiki_repository.dart';

class WikiDetailViewModel extends ChangeNotifier {
  WikiRepository repository;
  WikiDetail wikiDetail;
  bool isLoadData = false;

  WikiDetailViewModel() {
    repository = Injector().onGetDetail;
  }

  void onGetDetail(String title) {
    assert(repository != null);
    repository
        .onGetWikiDetail(title)
        .then((response) => getDetailSuccess(response))
        .catchError((error) => getDetailError());
  }

  void getDetailSuccess(WikiDetail response) {
    wikiDetail = WikiDetail();
    wikiDetail = response;
    isLoadData = false;
    notifyListeners();
  }

  void getDetailError() {
    isLoadData = false;
    notifyListeners();
  }
}
