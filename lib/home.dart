import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mr_invoice/invoice/invoice_list.dart';
import 'package:mr_invoice/invoicewithpreview.dart';
import 'package:mr_invoice/models/user.dart';
import 'package:mr_invoice/receipt/receipt_list.dart';
import 'package:mr_invoice/receiptwithpreview.dart';
import 'package:mr_invoice/settings/settings.dart';
import 'package:mr_invoice/widgets/top_curve.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with TickerProviderStateMixin{


  late AnimationController _moneyBagSlideController;
  late AnimationController _userNameHelloFadeIn;
  late AnimationController _usernameFadeIn;

  late Animation<Offset> _moneyBagSlideAnimation;
  late Animation<double> _helloFadeInAnimation;
  late Animation<double> _usernameFadeInAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moneyBagSlideController = AnimationController(duration: Duration(milliseconds: 800),vsync: this);
    _usernameFadeIn = AnimationController(duration: Duration(milliseconds: 1000),vsync: this);
    _userNameHelloFadeIn = AnimationController(duration: Duration(milliseconds: 800),vsync: this);
    _moneyBagSlideAnimation = Tween<Offset>(begin: Offset(1,0),end: Offset.zero).animate(_moneyBagSlideController);
    _helloFadeInAnimation = Tween<double>(begin: 0,end: 1).animate(CurvedAnimation(parent: _userNameHelloFadeIn,curve: Curves.bounceOut));
    _usernameFadeInAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _usernameFadeIn,curve: Curves.easeIn));
    _moneyBagSlideController.forward();
    _userNameHelloFadeIn.forward();
    _userNameHelloFadeIn.addListener(() {
      if(_userNameHelloFadeIn.isCompleted){
        _usernameFadeIn.forward();
      }
    });
  }
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
          SlideTransition(
            position: _moneyBagSlideAnimation,
            child: Transform.translate(
                offset: Offset(screenWidth*0.50,screenHeight*0.001),
                child: Transform.rotate(
                    angle: 0.2,
                    child: Image.asset("images/moneybag.png",
                      height: screenHeight/1.9,
                      width: screenWidth/1.9,

                    )
                )
            ),
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
                        FadeTransition(
                          opacity:_helloFadeInAnimation,
                          child: Text(
                            "Hello,",
                            style: TextStyle(color: Colors.white,decoration: TextDecoration.none,fontSize: 32,fontWeight: FontWeight.bold),
                          ),
                        ),
                        FadeTransition(
                          opacity: _usernameFadeInAnimation,
                          child: FutureBuilder(
                            future: User.getUserFromDatabase(),
                            builder:(context,AsyncSnapshot<User> snapshot){
                              if(snapshot.data == null){
                                return Text(
                                  "Welcome to Mr.Invoice",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,decoration: TextDecoration.none,fontSize: 24),
                                );
                              }
                              else{
                                return Text("${snapshot.data!.userName.split(" ")[0]}",style: TextStyle(color: Colors.white,decoration: TextDecoration.none,fontSize: 24),);
                              }

                          }
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Align(
                        heightFactor: 2,
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.settings),

                          color: Color(0xFFffe0a3),
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
                GestureDetector(

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
                GestureDetector(
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
        overlayColor: Color(0xFF2d4059),
          curve: Curves.easeIn,
          overlayOpacity: 0.7,
        animationSpeed: 50,
        tooltip: 'Speed Dial',
        children: [
          SpeedDialChild(
              child: Icon(MdiIcons.note),
              backgroundColor: Colors.blueGrey,
              label: 'New Estimate',
              labelStyle: TextStyle(fontSize: 12.0),
              onTap: (){
                _createNewInvoice(context,true);
              }
          ),
          SpeedDialChild(
            child: Icon(Icons.receipt_long),
            backgroundColor: Color(0xFFf67280),
            label: 'New Receipt',
            labelStyle: TextStyle(fontSize: 12.0),
            onTap: (){
              _createNewReceipt(context);
            }
          ),
          SpeedDialChild(
              child: Icon(MdiIcons.currencyInr),
              backgroundColor: Color(0xFF005792),
              label: 'New Invoice',
              labelStyle: TextStyle(fontSize: 12.0),
            onTap: (){
                _createNewInvoice(context,false);
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

  void _createNewInvoice(BuildContext context, bool isEstimate) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        return InvoiceWithPreview(isEstimate: isEstimate,);
      }
    ));
}


  Widget _getHomeCard(String title, String subtitle){
    return Container(
      color: Colors.transparent,
      child: Card(
        color: Colors.black54,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
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
