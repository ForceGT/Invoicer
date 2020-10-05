import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mr_invoice/invoice_list.dart';
import 'package:mr_invoice/invoicewithpreview.dart';
import 'package:mr_invoice/receipt_list.dart';
import 'package:mr_invoice/receiptwithpreview.dart';
import 'package:mr_invoice/settings.dart';
import 'package:mr_invoice/widgets/top_curve.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var headerHeight = screenHeight*0.35;
    var headerWidth = screenWidth;
    return Scaffold(
      body: Stack(
        children:<Widget>[
          TopCurve(headerHeight,headerWidth),
          Transform.translate(
              offset: Offset(screenWidth*0.50,screenHeight*0.001),
              child: Transform.rotate(
                  angle: 0.2,
                  child: Image.asset("images/moneybag.png",
                    height: screenHeight/1.9,
                    width: screenWidth/1.9,

                  )
              )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight/16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Hello,",
                          style: TextStyle(color: Colors.white,decoration: TextDecoration.none,fontSize: 32,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Username",
                          style: TextStyle(color: Colors.white,decoration: TextDecoration.none,fontSize: 24),
                        )
                      ],
                    ),
                    Expanded(
                      child: Align(
                        heightFactor: 2,
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.settings),
                          color: Colors.white70,
                          onPressed: () {
                            _openSettings(context);
                          },),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.28,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context){
                          return InvoiceList();
                        }
                    ));
                  },
                  child: _getHomeCard("Invoices","Track all your invoices here"),
                ),

                SizedBox(
                  height: screenHeight*0.1,
                ),
                InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context){
                          return ReceiptList();
                        }
                      ));
                    },
                    child: _getHomeCard("Receipts","Track all your receipts here")
                )
              ],
            ),
          ),

        ]),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor: Colors.grey[600],
          curve: Curves.easeInOut,
          overlayOpacity: 0.5,
        tooltip: 'Speed Dial',
        children: [
          SpeedDialChild(
              child: Icon(Icons.receipt),
              backgroundColor: Colors.red,
              label: 'New Estimate',
              labelStyle: TextStyle(fontSize: 12.0),
              onTap: (){
                _createNewReceipt(context);
              }
          ),
          SpeedDialChild(
            child: Icon(Icons.redeem),
            backgroundColor: Colors.red,
            label: 'New Receipt',
            labelStyle: TextStyle(fontSize: 12.0),
            onTap: (){
              _createNewReceipt(context);
            }
          ),
          SpeedDialChild(
              child: Icon(Icons.account_balance_wallet),
              backgroundColor: Colors.deepOrangeAccent,
              label: 'New Invoice',
              labelStyle: TextStyle(fontSize: 12.0),
            onTap: (){
                _createNewInvoice(context);
            }
          )
        ],

      )

    );
  }

  void _openSettings(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        return SettingsPage();
      }
    ));
  }

  void _createNewReceipt(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        return ReceiptWithPreview();
      }
    ));
  }
}

  void _createNewInvoice(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        return InvoiceWithPreview();
      }
    ));
}


  Widget _getHomeCard(String title, String subtitle){
    return Container(
      child: Card(
        color: Colors.black54,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$title", style: TextStyle(fontSize: 32,fontWeight: FontWeight.w500, color: Colors.white),),
                  Text("$subtitle" ,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),)
                ],
              ),
              SizedBox(
                width: 40,
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.amberAccent,)
            ],
          ),
        ),
      ),
    );
  }
