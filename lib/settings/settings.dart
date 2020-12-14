import 'package:flutter/material.dart';
import 'package:mr_invoice/clients_list_page.dart';
import 'package:mr_invoice/services_list_page.dart';
import 'package:mr_invoice/user_profile.dart';
import 'tandc_list_page.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2d4059),
      appBar: AppBar(title: Text("Settings"),),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(top: 2.0),
            dense: true,
            onTap: (){
              _openUserSettings(context);
            },
            leading: Icon(Icons.account_circle, color: Colors.white,size: 30,),
            title: Text("User Profile", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            subtitle: Text("Click here to manage the user settings like name, signature, etc", style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w400),),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(top: 2.0),
            dense: true,
            onTap: (){
              _openClientsPage(context);
            },
            leading: Icon(Icons.verified_user, color: Colors.white,size: 30,),
            title: Text("Clients", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            subtitle: Text("Click here to manage the list of clients", style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w400),),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(top: 2.0),
            dense: true,
            onTap: (){
              _openProductsPage(context);
            },
            leading: Icon(Icons.shopping_cart, color: Colors.white,size: 30,),
            title: Text("Products/Services", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            subtitle: Text("Click here to manage the list of services", style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w400),),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(top: 2.0),
            dense: true,
            onTap: (){
              _openTandCPage(context);
            },
            leading: Icon(Icons.analytics_outlined, color: Colors.white,size: 30,),
            title: Text("Terms And Conditions", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            subtitle: Text("Click here to manage the terms and conditions displayed ", style: TextStyle(color:Colors.white70,fontWeight: FontWeight.w400),),
          ),

        ],
      ),
    );
  }
}





void _openUserSettings(BuildContext context) {

  Navigator.of(context).push(MaterialPageRoute(
    builder: (context){
      return UserProfile();
    }
  ));


}
void _openClientsPage(BuildContext context){
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        return ClientsListPage();
      }
  ));
}

void _openProductsPage(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        return ServiceListPage();
      }
  ));
}

void _openTandCPage(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        return TandCListPage();
      }
  ));
}
