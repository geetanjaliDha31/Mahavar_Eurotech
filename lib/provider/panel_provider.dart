import 'package:flutter/cupertino.dart';

class PanelProvider extends ChangeNotifier {
  Widget widget;
  double height;

  PanelProvider({this.height = 0, this.widget = const SizedBox.shrink()});

  void openPanel(Widget data, double h) async {
    widget = data;
    height = h;
    notifyListeners();
  }
}
