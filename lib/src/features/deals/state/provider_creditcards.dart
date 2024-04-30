import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_creditcards.dart';

final creditcardsProvider =
    ChangeNotifierProvider<CreditCardsNotifier>((ref) => CreditCardsNotifier());

class CreditCardsNotifier extends ChangeNotifier {
  final FetchCreditCardsDealService _creditcardService =
      FetchCreditCardsDealService();
  final String _boxName = 'creditcards';
  int pageNumber = 1;
  int limit = 15;
  bool _isLoading = false;

  List<CreditCardDealData> _creditcards = [];

  bool get isLoading => _isLoading;
  List<CreditCardDealData> get creditcards => _creditcards;

  CreditCardsNotifier() {
    _loadCreditCards();
  }

  Future<void> refreshCreditCards() async {
    _isLoading = true;
    notifyListeners();

    try {
      final serverCreditCards = await _creditcardService.fetchCreditCardDeals(
          _boxName, pageNumber, limit);
      _creditcards = serverCreditCards;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading credit cards: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCreditCards() async {
    _isLoading = true;
    notifyListeners();

    try {
      _creditcards = await _creditcardService.getCachedCreditCards(_boxName);
      notifyListeners();

      final serverCreditCards = await _creditcardService.fetchCreditCardDeals(
          _boxName, pageNumber, limit);
      _creditcards = serverCreditCards;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading credit cards: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreCreditCards() async {
    pageNumber++;
    _isLoading = true;
    notifyListeners();

    try {
      final serverCreditCards = await _creditcardService
          .fetchMoreCreditCardDeals(_boxName, pageNumber, limit);
      _creditcards.addAll(serverCreditCards);
      notifyListeners();
    } catch (e) {
      pageNumber--;
      debugPrint('error loading more credit cards: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
