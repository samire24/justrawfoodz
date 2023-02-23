import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:just_foodz/helpers/db_helper.dart';
import 'package:just_foodz/model/cart_model.dart';
import 'package:provider/provider.dart';

import '../cart_provider.dart';



class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
                animationDuration: Duration(milliseconds: 300),
                child: Icon(Icons.shopping_bag_outlined)),
          ),
          SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
          FutureBuilder(
            future: cart.getData(),
                    builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
               if (snapshot.hasData){

                 if(snapshot.data!.isEmpty){
                   return Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Image(image: AssetImage('images/bank3')),
                       SizedBox(height: 20,),
                       Text('Explore Product', style: Theme.of(context).textTheme.subtitle2,),
                     ],
                   );
                 }else{
                   return Expanded(
                       child: ListView.builder(
                           itemCount: snapshot.data!.length,
                           itemBuilder: (context, index) {
                             return Card(
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Image(
                                             height: 100,
                                             width: 100,
                                             image: NetworkImage(
                                                 snapshot.data![index].image.toString())),
                                         SizedBox(
                                           width: 10,
                                         ),
                                         Expanded(
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             mainAxisAlignment: MainAxisAlignment.start,
                                             children: [
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(
                                                     snapshot.data![index].productName.toString(),
                                                     style: TextStyle(
                                                       fontSize: 16,
                                                       fontWeight: FontWeight.w500,
                                                     ),
                                                   ),
                                                   InkWell(
                                                       onTap: (){
                                                         dbHelper!.delete(snapshot.data![index].id);
                                                         cart.removeCounter();
                                                         cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                       },
                                                       child: Icon(Icons.delete))
                                                 ],
                                               ),

                                               SizedBox(
                                                 height: 5,
                                               ),
                                               Text(snapshot.data![index].unitTag.toString() +
                                                   " " +
                                                   r"$" +
                                                   snapshot.data![index].productPrice.toString(),
                                                 style: TextStyle(
                                                     fontSize: 16,
                                                     fontWeight: FontWeight.w500
                                                 ),
                                               ),
                                               Align(
                                                 alignment: Alignment.centerRight,
                                                 child: InkWell(
                                                   onTap: (){

                                                   },
                                                   child: Container(
                                                     height: 35,
                                                     width: 100,
                                                     decoration: BoxDecoration(
                                                       color: Colors.green,
                                                       borderRadius: BorderRadius.circular(
                                                           5),
                                                     ),
                                                     child: Padding(
                                                       padding: const EdgeInsets.all(4.0),
                                                       child: Row(
                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                         children: [
                                                           InkWell(
                                                               onTap: (){
                                                                 int quantity = snapshot.data![index].quantity!;
                                                                 int price = snapshot.data![index].initialPrice;
                                                                 quantity--;

                                                                 int newprice = price* quantity;

                                                                 if(quantity > 0){
                                                                   dbHelper!.UpdateQuantity(
                                                                       Cart(
                                                                           id: snapshot.data![index].id,
                                                                           productId: snapshot.data![index].id!.toString(),
                                                                           productName: snapshot.data![index].productName,
                                                                           initialPrice: snapshot.data![index].initialPrice,
                                                                           productPrice: newprice,
                                                                           quantity: quantity,
                                                                           unitTag: snapshot.data![index].unitTag,
                                                                           image: snapshot.data![index].image.toString()
                                                                       )
                                                                   ).then((value) {
                                                                     newprice =0 ;
                                                                     quantity = 0;
                                                                     cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                                   }).onError((error, stackTrace) {
                                                                     print(error.toString());
                                                                   });
                                                                 }


                                                               },
                                                               child: Icon(Icons.remove,color: Colors.white,)),
                                                           Center(
                                                             child: Text(snapshot.data![index].quantity.toString(),
                                                               style: TextStyle(
                                                                   color: Colors.white),),
                                                           ),
                                                           InkWell(
                                                               onTap: (){
                                                                 int quantity = snapshot.data![index].quantity!;
                                                                 int price = snapshot.data![index].initialPrice;
                                                                 quantity++;

                                                                 int newprice = price* quantity;

                                                                 dbHelper!.UpdateQuantity(
                                                                     Cart(
                                                                         id: snapshot.data![index].id,
                                                                         productId: snapshot.data![index].id!.toString(),
                                                                         productName: snapshot.data![index].productName,
                                                                         initialPrice: snapshot.data![index].initialPrice,
                                                                         productPrice: newprice,
                                                                         quantity: quantity,
                                                                         unitTag: snapshot.data![index].unitTag,
                                                                         image: snapshot.data![index].image.toString()
                                                                     )
                                                                 ).then((value) {
                                                                   newprice =0 ;
                                                                   quantity = 0;
                                                                   cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                                 }).onError((error, stackTrace) {
                                                                   print(error.toString());
                                                                 });
                                                               },
                                                               child: Icon(Icons.add,color: Colors.white,))
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                               )
                                             ],
                                           ),
                                         )
                                       ],
                                     )
                                   ],
                                 ),
                               ),
                             );
                           }));
                 }

    }
            return CircularProgressIndicator();
          }),
            Consumer<CartProvider>(builder: (context, value, child){
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2)=="0.00"? false : true,
                child: Column(
                  children: [
                    ReUsableWidget(title: "Sub Total", value: r'$'+ value.getTotalPrice().toStringAsFixed(2)),
                    ReUsableWidget(title: "Discount", value: r'$'+ '20'),
                    ReUsableWidget(title: "Total", value: r'$'+ value.getTotalPrice().toStringAsFixed(2)),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
class ReUsableWidget extends StatelessWidget {
  final String title;
  final String value;

  const ReUsableWidget({Key? key,
    required this.title,
    required this.value
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.subtitle2,),
          Text(value.toString(), style: Theme.of(context).textTheme.subtitle2,),
        ],
      ),
    );
  }
}