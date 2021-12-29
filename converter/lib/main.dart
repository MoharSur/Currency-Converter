import 'dart:math';

import 'package:converter/api.dart';
import 'package:flutter/material.dart';

// Currency Converter App 

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
class HomePage extends StatefulWidget {

  @override
   HomePageState createState() =>  HomePageState();
}

class HomePageState extends State<HomePage> {
  
  Color mainColor = const Color(0xFF212936);
  Color secondColor = const Color(0xFF2849E5);
  
  String fromCur = 'INR';
  String toCur = 'USD';
  double rate = 0.0;
  double result = 0.0;
  
  List<String> currencies = [];

  ApiClient api = ApiClient();

  TextEditingController inputController = TextEditingController();

   @override
  void initState() {
    super.initState();
      api.getCurrencies().then((_currencies) => 
       setState(() {
        currencies = _currencies;
      }));
  }
  double roundDouble(double value, int places){
     double mod = pow(10.0, places).toDouble();
     return ((value * mod).round().toDouble() / mod);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 15.0),
        padding: const EdgeInsets.all(30.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Expanded(
           child: Column(
             children: const [
                 Text(
                'Currency',
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold
                ),
              ),
               Text(
                'Converter',
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                  fontSize: 28.0,
                ),
              ),
             ],
           )),
          const SizedBox(height: 50.0),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child : TextField( 
               controller: inputController,
               textAlign: TextAlign.center,
               keyboardType: TextInputType.number,
               style: TextStyle(
                color: Colors.grey[800],
                fontSize: 26.0,
                fontWeight: FontWeight.bold
              ),
           ),
          ),
         ),
         const SizedBox(height: 20.0),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
          Container(
             padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
             decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              child:DropdownButton(
                  items: currencies.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      );
                  }).toList(),
                  onChanged: (String? cur) {
                    if(cur != null){
                      setState(() {
                        fromCur = cur;
                      }); 
                    }
                  },
                  value: fromCur,
                  ), 
            ),
             FloatingActionButton(
               onPressed: () async {
                try{ 
                 rate = await api.getCurrencyRate(fromCur, toCur);
                 setState(() {
                    result = double.parse(inputController.text) * rate;
                    result = roundDouble(result, 3);
                   });
                 }catch(e){
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Failed to fetch data ... ')));
                  }
               },
               backgroundColor: secondColor,
               child: const Icon(Icons.swap_horiz, color: Colors.white,)
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),   
                child: DropdownButton(
                    items: currencies.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        );
                    }).toList(),
                    onChanged: (String? cur) {
                      if(cur != null){
                       setState(() {
                         toCur = cur;
                       });
                      }
                    },
                    value: toCur,
                    ),
              ) 
           ],
         ),
         const SizedBox(height: 20.0),
         Container(
           height: 150,
           width: double.infinity,
           decoration: const BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.all(Radius.circular(20.0))
           ),
           padding: const EdgeInsets.all(16.0),
           child: Column(
             children: [
               Text(
              'Result',
               style: TextStyle(
                color: Colors.grey[800],
                fontSize: 24.0,
              ),
             ),
              
            const SizedBox(height: 16.0),
             Text(
              '$result',
               style: TextStyle(
                color: Colors.grey[600],
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
             ),
             const SizedBox(height: 8.0),
              Text(
              '$rate',
               style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12.0,
                letterSpacing: 1.5
                //fontWeight: FontWeight.bold,
              ),
             ),
            ],
          ),
         ) 
        ],
      ),
      ),
      backgroundColor: mainColor
    );
  }
}
