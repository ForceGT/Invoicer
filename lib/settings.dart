import 'package:flutter/material.dart';
import 'package:mr_invoice/clients_list_page.dart';
import 'package:mr_invoice/services_list_page.dart';
import 'package:mr_invoice/user_profile.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          ListTile(
            onTap: (){
              _openUserSettings(context);
            },
            leading: Icon(Icons.account_circle, color: Colors.white,),
            title: Text("User Profile", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text("Click here to change the user settings like name, signature, etc", style: TextStyle(color: Colors.white),),
          ),
          Divider(color: Colors.black54,),
          ListTile(
            onTap: (){
              _openClientsPage(context);
            },
            leading: Icon(Icons.verified_user, color: Colors.white,),
            title: Text("Clients", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text("Click here to view the list of clients", style: TextStyle(color: Colors.white),),
          ),
          Divider(color: Colors.black54,),
          ListTile(
            onTap: (){
              _openProductsPage(context);
            },
            leading: Icon(Icons.shopping_cart, color: Colors.white,),
            title: Text("Products/Services", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text("Click here to view the list of services", style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    );
  }
}

void _openProductsPage(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        return ServiceListPage();
      }
  ));
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
