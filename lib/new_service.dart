import 'package:flutter/material.dart';
import 'models/service.dart';

class NewService extends StatefulWidget {
  Service _service;
  bool _isEdit;

  NewService({service, isEdit})
      : _service = service,
        _isEdit = isEdit;

  @override
  _NewServiceState createState() => _NewServiceState();
}

class _NewServiceState extends State<NewService> {
  _NewServiceState();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = widget._isEdit == true
        ? TextEditingController(text: "${widget._service.name}")
        : TextEditingController();
    final TextEditingController _rateController = widget._isEdit == true
        ? TextEditingController(text: "${widget._service.rate}")
        : TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter your details"),
      ),
      body: Builder(
        builder: (BuildContext bc) => ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
              child: Card(
                elevation: 8.0,
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(10.0),
                  leading: Icon(Icons.account_balance_wallet,size: 30,),
                  title: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Name of the service",
                      labelText: "Service",
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
              child: Card(
                elevation: 8.0,
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Icon(Icons.account_balance_wallet,size: 30,),
                  title: TextField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18),
                    controller: _rateController,
                    decoration: InputDecoration(
                      hintText: "Rate of the service",
                      labelText: "Rate",
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Center(
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text("Save",style: TextStyle(fontSize: 14),),
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _rateController.text.isEmpty) {
                      Scaffold.of(bc).showSnackBar(SnackBar(
                          content: Text("Rate and Name can't be empty")));
                      return;
                    }
                    Service service = Service(
                        name: _nameController.text, rate: _rateController.text);
                    if (widget._isEdit == true) {
                      Service.updateService(service);
                    } else {
                      Service.insertService(service);
                    }
                    Navigator.pop(context, true);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
