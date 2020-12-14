import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:mr_invoice/receiptbuilder.dart';
import 'package:mr_invoice/common/selectable_invoice_list.dart';
import 'models/reciept.dart';
import 'models/client.dart';

class NewReceiptForm extends StatefulWidget {
  const NewReceiptForm();

  @override
  _NewReceiptFormState createState() => _NewReceiptFormState();
}

class _NewReceiptFormState extends State<NewReceiptForm> {
  final _clientController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var clientName = "";
  var amount;
  String _currentDate = DateFormat("dd-MM-yyyy").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Receipt.getLatestId(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Column(
            children: [
              Container(
                color: Colors.blue,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "RCPT ${snapshot.data}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      child: Text(
                        "$_currentDate",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2025));
                        setState(() {
                          _currentDate =
                              DateFormat("yyyy-MM-dd").format(selectedDate);
                        });
                      },
                    )
                  ],
                ),
              ),
              Form(
                key: this._formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: TextStyle(color: Colors.white),
                            autofocus: false,
                            autocorrect: true,
                            controller: _clientController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                labelText: "Client Name",
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: "Enter your Client Name Here")),
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            leading: Icon(Icons.account_circle),
                            title: Text(suggestion),
                          );
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
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                            color: Colors.blueGrey[300],
                            elevation: 6.0,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                topLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(16.0),
                                bottomLeft: Radius.circular(16.0))),
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          controller.duration = Duration(milliseconds: 100);
                          return SizeTransition(
                            child: suggestionsBox,
                            sizeFactor: CurvedAnimation(
                              parent: controller,
                              curve: Curves.easeIn,
                              reverseCurve: Curves.easeOut,
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          this._clientController.text = suggestion;
                        },
                        suggestionsCallback: (pattern) async {
                          if (pattern != "") {
                            return await Client.getClientsByPattern(pattern);
                          }
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Client Name cannot be empty";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          clientName = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            labelText: "Amount in Rs",
                            labelStyle: TextStyle(color: Colors.grey),
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: "Enter the receipt amount here"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Amount cannot be empty";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          amount = int.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      padding: EdgeInsets.all(14.0),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          var receipt = Receipt(
                              fromName: clientName,
                              amount: amount,
                              forInvoiceId: "",
                              date: _currentDate);
                          var result = await showDialog(
                              context: context,
                              builder: (context) {
                                return buildOptionDialog(context);
                              });
                          if (result) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return SelectableInvoiceList(receipt: receipt);
                            }));
                          } else {
                            ReceiptBuilder receiptBuilder = ReceiptBuilder(
                                regenerate: false, receipt: receipt);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return receiptBuilder.getPdfPreview(
                                  MediaQuery.of(context).size.width*1.5,
                                  MediaQuery.of(context).size.height * 0.45);
                            }));
                          }

                        }
                      },
                      child: Text("PROCEED"),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget buildOptionDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Against Invoice"),
      content: Text("Do you want to associate this receipt with an invoice?"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      actions: [
        MaterialButton(
            child: Text("YES"),
            onPressed: () {
              Navigator.pop(context, true);
            }),
        MaterialButton(
            child: Text("NO"),
            onPressed: () {
              Navigator.pop(context, false);
            })
      ],
    );
  }
}
