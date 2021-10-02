import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../models/service.dart';

//ignore: must_be_immutable
class NewService extends StatefulWidget {
  late Service? _service;
  late bool _isEdit;

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
        ? TextEditingController(text: "${widget._service!.name}")
        : TextEditingController();
    final TextEditingController _rateController = widget._isEdit == true
        ? TextEditingController(text: "${widget._service!.rate}")
        : TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter your details"),
      ),
      body: Builder(
        builder: (BuildContext bc) => ListView(
          children: [
            Container(
              alignment: Alignment.center,
              height: 300,
              child: CircleAvatar(
                radius: 130,
                child: Icon(
                  MdiIcons.cameraImage,
                  size: 210,
                  color: Colors.white60,
                ),
              ),
            ),
            Center(
              child: Text(
                "Service Details",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                color: Color(0xFF346588),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.all(10.0),
                        leading: Icon(Icons.account_balance_wallet,
                            size: 30, color: Colors.white),
                        title: TextField(
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          controller: _nameController,
                          decoration: InputDecoration(
                              hintText: "Name of the service",
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: "Service",
                              labelStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.all(16.0),
                        leading: Icon(
                          MdiIcons.currencyInr,
                          size: 30,
                          color: Colors.white,
                        ),
                        title: TextField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          controller: _rateController,
                          decoration: InputDecoration(
                              hintText: "Rate of the service",
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: "Rate",
                              labelStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      textStyle: TextStyle(color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 14),
                  ),
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _rateController.text.isEmpty) {
                      ScaffoldMessenger.of(bc).showSnackBar(SnackBar(
                          content: Text("Rate and Name can't be empty!")));
                      return;
                    }

                    if (widget._isEdit == true) {
                      Service service = Service(
                          id: widget._service!.id,
                          name: _nameController.text,
                          rate: _rateController.text);
                      Service.updateService(service);
                      ScaffoldMessenger.of(bc).showSnackBar(SnackBar(
                          content: Text("Service updated successfully!")));
                    } else {
                      Service service = Service(
                          name: _nameController.text,
                          rate: _rateController.text);
                      Service.insertService(service);
                      ScaffoldMessenger.of(bc).showSnackBar(SnackBar(
                          content: Text("Service inserted successfully!")));
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
