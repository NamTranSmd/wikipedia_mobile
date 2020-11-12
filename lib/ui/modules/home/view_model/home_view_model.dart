import 'package:flutter/cupertino.dart';
import 'package:wikipedia_app/data/di/injector.dart';
import 'package:wikipedia_app/data/model/local_model/wikipedia.dart';
import 'package:wikipedia_app/data/model/response/search_response.dart';
import 'package:wikipedia_app/data/sources/local/daos/wiki_dao.dart';
import 'package:wikipedia_app/data/sources/local/dbconfig.dart';
import 'package:wikipedia_app/data/sources/repositories/home/home_repository.dart';
import 'package:wikipedia_app/ui/modules/home/contract/home_contract.dart';
import 'package:wikipedia_app/utils/check_internet.dart';

class HomeViewModel extends ChangeNotifier {
  TextEditingController searchTextController;
  HomeRepository repository;
  HomeContract contract;
  SearchResponse searchResponse;
  bool isLoadData;
  bool validateSearch = false;
  WikiDAO _wikiDAO = WikiDAO();

  List<Wikipedia> wikies;

  HomeViewModel() {
    isLoadData = true;
    repository = Injector().onSearch;
    searchTextController = TextEditingController();
    _getDbInstance().then((value) {
      isLoadData =false;
      this.getWikies();
    });
  }

  Future _getDbInstance() async => await DbConfig.getInstance();

  void onSearch(int limit) {
    checkInterNet().then((value) {
      if (value != null && value) {
        assert(repository != null);
        isLoadData = true;
        notifyListeners();
        repository
            .onSearch(searchTextController.text, limit)
            .then((response) => contract.onSearchSuccess(response))
            .catchError((error) => contract.onSearchError(error));
      }
    });
  }

  void searchSuccess(SearchResponse response) {
    searchResponse = SearchResponse();
    searchResponse = response;
    isLoadData = false;
    this.deleteTable();
    searchResponse.pages.forEach((element) {
      _wikiDAO.insert(element);
    });
    notifyListeners();
  }

  void searchError() {
    isLoadData = false;
    notifyListeners();
  }

  void getWikies() async {
    searchResponse = SearchResponse();
    searchResponse.pages = await _wikiDAO.getWikies();
    notifyListeners();
  }

  void deleteTable() async {
    await _wikiDAO.deleteTable();
    notifyListeners();
  }
}
