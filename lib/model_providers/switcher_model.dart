import 'package:flutter/foundation.dart';

class SwitcherModel with ChangeNotifier {
  int pageId = 0;

  setPage(int page) {
    pageId = page;
    notifyListeners();
  }
}
