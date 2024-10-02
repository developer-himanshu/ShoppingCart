import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/db_helper.dart';

class CartProvider with ChangeNotifier{
  DBHelper db = DBHelper() ;
int _counter=0;
double _totalPrice=0.0;
int get counter=> _counter;
double get totalPrice=>_totalPrice;

// cart me fetch krna hai
late Future<List<Cart>> _cart;
Future <List<Cart>> get cart=>_cart;

//data get kr rhe hai
Future <List<Cart>> getData()async{
  _cart=db.getCartList();
  return _cart;
}


// preference item ka use krte hai to store the
// item in the bag and scren load nahi ho jb bhi start ho app

void _setPrefItems()async {
SharedPreferences prefs=await SharedPreferences.getInstance();
prefs.setInt('cart_item', _counter);
prefs.setDouble('total_price', _totalPrice);
notifyListeners();

}

void _getPrefsItems()async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  
  _counter=prefs.getInt('cart_item')?? 0;
  _totalPrice=prefs.getDouble('total_price')??0.0;
  notifyListeners();
}
// totoal price ke liye code likh rhe hai ab hum

void addTotalPrice( double productPrice){
_totalPrice =_totalPrice+productPrice;
_setPrefItems();
notifyListeners();
}

void removeTotalPrice(double productPrice){
_totalPrice =_totalPrice-productPrice;
_setPrefItems();
notifyListeners();

}

double getTotalPrice(){
_getPrefsItems();
return _totalPrice;

}

// jb item add krenge then counter ko increment karna hoga
void addCounter(){
_counter++;
_setPrefItems();
print(_counter);
notifyListeners();
}

void removeCounter(){
  _counter--;
_setPrefItems();
notifyListeners();

}

int getCounter(){
_getPrefsItems();
return _counter;

}



}