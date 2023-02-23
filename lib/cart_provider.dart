import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/db_helper.dart';
import 'model/cart_model.dart';

class CartProvider with ChangeNotifier{

  DBHelper db = DBHelper();
  int _counter = 0;
  int get counter => _counter;

  double _totalprice = 0.0;
  double get totalPrice => _totalprice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart ;

  Future<List<Cart>> getData () async{
    _cart = db.getCartList();
    return _cart;
  }

  void _setPrefItems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalprice);
    notifyListeners();
  }

  void _getPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalprice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }
  void addTotalPrice (double productprice)async{
    _totalprice = _totalprice + productprice;
    _setPrefItems();
    notifyListeners();
  }
  void removeTotalPrice (double productprice)async{
    _totalprice = _totalprice - productprice;
    _setPrefItems();
    notifyListeners();
  }
  double getTotalPrice (){
    _getPrefItems();
    return _totalprice;
  }
  void addCounter (){
    _counter++;
    _setPrefItems();
    notifyListeners();
  }
  void removeCounter (){
    _counter--;
    _setPrefItems();
    notifyListeners();
  }
  int getCounter (){
    _getPrefItems();
    return _counter;
  }
}