import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'invoicebuilder.dart';
class InvoiceWithPreview extends StatefulWidget {
  @override
  _InvoiceWithPreviewState createState() => _InvoiceWithPreviewState();
}

class _InvoiceWithPreviewState extends State<InvoiceWithPreview> {
  List<Tab> _myTabs = [Tab(text: "Invoice"), Tab(text: "Preview")];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Invoice Builder",
              style: Theme.of(context).textTheme.headline5),
          bottom: TabBar(tabs: _myTabs),
        ),
        body: TabBarView(
          children: [
            _getInvoiceBuilderForm(),
            _getInvoicePdfPreview()
          ],
        ),
      ),
    );
  }

  Widget _getInvoiceBuilderForm(){
    return Text("This will be the invoice builder form");
  }

  Widget _getInvoicePdfPreview(){
    // return Text("This will be the pdf preview page");

   return PdfPreview(
      maxPageWidth: 700,
      build: (pageFormat){
        return buildInvoicePdf(pageFormat);
      }
    );
  }

}
