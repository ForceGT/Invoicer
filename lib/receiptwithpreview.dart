import 'package:flutter/material.dart';
import 'package:mr_invoice/models/reciept.dart';
import 'package:mr_invoice/new_receipt_form.dart';
import 'package:printing/printing.dart';
import 'receiptbuilder.dart';

class ReceiptWithPreview extends StatefulWidget {
  const ReceiptWithPreview({Key key}) : super(key: key);

  @override
  ReceiptWithPreviewState createState() => ReceiptWithPreviewState();
}

class ReceiptWithPreviewState extends State<ReceiptWithPreview>
    with SingleTickerProviderStateMixin {






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt Builder",
            style: Theme
                .of(context)
                .textTheme
                .headline5),

      ),
      body: _getReceiptBuilderForm()
    );
  }

  Widget _getReceiptBuilderForm() {
    return NewReceiptForm();
  }

}
