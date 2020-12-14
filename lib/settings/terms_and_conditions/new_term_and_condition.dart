import 'package:flutter/material.dart';
import 'models/TandC.dart';


class NewTerm extends StatefulWidget {

  bool _isEdit;
  TandC _term;


  NewTerm({isEdit,term}):_isEdit=isEdit,_term=term;

  @override
  _NewTermState createState() => _NewTermState();

}



class _NewTermState extends State<NewTerm> {

  bool isChecked;
  var termValue;
  TextEditingController _termController;
  @override
  void initState() {
    super.initState();
    this.isChecked = widget._isEdit == true ? (widget._term.type == "default" ? true : false) : false;
    this._termController = widget._isEdit == true ? TextEditingController(text: widget._term.terms):TextEditingController();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Builder(
          builder: (BuildContext bc){
            return Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 300,
                  child: CircleAvatar(
                    radius: 120,
                    child: Icon(Icons.analytics_outlined,size: 210,),

                  ),
                ),
                Text("T&C details",style: TextStyle(fontSize: 32,color: Colors.white)),
                Padding(padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                  child:Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    color: Color(0xFF346588),
                    elevation: 8.0,
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.all(4.0),
                      leading: Icon(Icons.analytics_outlined,size: 30,color: Colors.white,),
                      title: TextField(
                        maxLines: 5,
                        style: TextStyle(fontSize: 18,color: Colors.white),
                        controller: _termController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(12.0)
                          ),
                          hintText: "Enter Term ",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "Term",
                            labelStyle:
                            TextStyle(color: Colors.grey[400])
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                    child: CheckboxListTile(
                      value: this.isChecked,
                      title: Text("Mark as default",style: TextStyle(color: Colors.white,fontSize: 18),),
                      onChanged: (value){
                        termValue = _termController.text;

                        print("TermValue: $termValue");
                        //print("Outside setState() isChecked: $this.isChecked");
                        setState(() {
                          //print("setState() isChecked: $this.isChecked");
                          this.isChecked = value;


                          //print("setState() isChecked after inversion: $this.isChecked");
                        });
                        print("TermControllerText: ${_termController.text}");
                        _termController.text = termValue;

                      },
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
                        if (_termController.text.isEmpty) {
                          Scaffold.of(bc).showSnackBar(SnackBar(
                              content: Text("Term value can't be empty!")));
                          return;
                        }

                        var type = isChecked == true ? "default":"normal";
                        if (widget._isEdit == false) {
                          TandC tandC = TandC( terms:_termController.text, type:type);
                          TandC.insertTermIntoDB(tandC);
                          Scaffold.of(bc).showSnackBar(SnackBar(
                              content: Text("Added new Term Successfully!")));
                        } else {
                          TandC tandC = TandC(id:widget._term.id,terms:_termController.text, type:type);
                          TandC.updateTerms(tandC);
                          Scaffold.of(bc).showSnackBar(SnackBar(
                              content: Text("Updated Term successfully!")));
                        }
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }


}
