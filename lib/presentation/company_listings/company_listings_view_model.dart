//뷰모델은 상태도 가지고 있음
import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:stock_app/domain/repository/stock_repository.dart';
import 'package:stock_app/presentation/company_listings/company_listings_action.dart';
import 'package:stock_app/presentation/company_listings/company_listings_state.dart';

class CompanyListingViewModel with ChangeNotifier {
  // usecase 를 사용 하는 경우 유즈케이스를 적용해도 무방함
  final StockRepository _repository;

  var _state = CompanyListingsState();

  Timer? _debounce;

  CompanyListingsState get state => _state;

  CompanyListingViewModel(this._repository) {
    _getCompanyListings();
  }

  void onAction(CompanyListingsAction action) {
    action.when(
        refresh: () => _getCompanyListings(fetchFromRemote: true),
        onSearchQueryChange: ((query) {
          _debounce?.cancel();

          _debounce = Timer(const Duration(milliseconds: 500), () {
            _getCompanyListings(query: query);
          });
        }));
  }

  Future<void> _getCompanyListings({
    bool fetchFromRemote = false,
    String query = '',
  }) async {
    //로딩 시작
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.getCompanyListings(fetchFromRemote, query);
    result.when(
      success: (listings) {
        _state = state.copyWith(companies: listings);
      },
      error: (e) {
        //TODO : 에러 처리
        debugPrint('[error] : remote error +${e.toString()}');
      },
    );
    //로딩 완료
    _state = state.copyWith(isLoading: false);
    notifyListeners(); // <=== 상태가 바뀔 때 마다 넣어줘야 함
  }

  //상태가 많아지면 관리하기 어려워지니 state class 를 만드는게 더 좋아 보임
}
