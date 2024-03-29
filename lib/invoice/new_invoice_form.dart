import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mr_invoice/settings/services/services_list_page.dart';
import '../models/client.dart';
import '../models/invoice.dart';
import 'package:intl/intl.dart';

class NewInvoiceForm extends StatefulWidget {
  bool _isEstimate;

  @override
  _NewInvoiceFormState createState() => _NewInvoiceFormState();

  NewInvoiceForm({isEstimate}) : _isEstimate = isEstimate;
}

class _NewInvoiceFormState extends State<NewInvoiceForm>
    with TickerProviderStateMixin {
  String _currentDate = DateFormat("dd-MM-yyyy").format(DateTime.now());

  late TextEditingController _clientNameController;
  late AnimationController _productController;
  late Animation<Offset> slideInAnimation;

  @override
  void initState() {
    super.initState();
    _productController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    slideInAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _productController,
            curve: Curves.easeIn,
            reverseCurve: Curves.easeOut));
    _clientNameController = TextEditingController();
    //_productController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Invoice.getLatestId(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Colors.blue,
              height: 50,
              child: Row(
                mainAxisAlignment: widget._isEstimate
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (!widget._isEstimate)
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "INV ${snapshot.data}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      child: Text(
                        "$_currentDate",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030));
                        setState(() {
                          _currentDate =
                              DateFormat("dd-MM-yyyy").format(selectedDate!);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  style: TextStyle(color: Colors.white),
                  autofocus: false,
                  controller: _clientNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      labelText: "Client Name",
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Client Name"),
                ),
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(suggestion.toString()),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _productController.forward();
                  this._clientNameController.text = suggestion.toString();
                },
                suggestionsCallback: (pattern) async {
                  if (pattern != "") {
                    return await Client.getClientsByPattern(pattern);
                  }else{
                    return [];
                  }

                },
                noItemsFoundBuilder: (context) {
                  return ListTile(
                      leading: Icon(
                        Icons.clear,
                        color: Theme.of(context).errorColor,
                      ),
                      title: Text(
                        "No items found",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            color: Theme.of(context).errorColor),
                      ));
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  Future.delayed(Duration(milliseconds: 100));
                  return SizeTransition(
                    child: suggestionsBox,
                    sizeFactor: CurvedAnimation(
                      parent: controller!.view,
                      curve: Curves.easeIn,
                      reverseCurve: Curves.easeOutBack,
                    ),
                  );
                },
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    color: Colors.blueGrey[300],
                    elevation: 6.0,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(16.0),
                        bottomLeft: Radius.circular(16.0))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SlideTransition(
                  position: slideInAnimation,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(color: Colors.white),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0))),
                      child: Text("NEXT"),
                      onPressed: () {
                        if (_clientNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Client Name can't be empty!!"),
                          ));
                          return;
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          Invoice invoice = Invoice(
                              date: _currentDate,
                              forName: _clientNameController.text);
                          return ServiceListPage(
                            isSelectable: true,
                            invoice: invoice,
                            isEstimate: widget._isEstimate,
                          );
                        }));
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
