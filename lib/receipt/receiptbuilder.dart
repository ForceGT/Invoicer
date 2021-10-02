import 'dart:typed_data';
import 'package:mr_invoice/models/reciept.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:mr_invoice/models/user.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';

class ReceiptBuilder {
  late User user;
  late Receipt _receipt;

  bool _regenerate;
  var rcptId;

  ReceiptBuilder({regenerate, receipt})
      : _regenerate = regenerate,
        _receipt = receipt;

  Widget getPdfPreview(double width, double height) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Receipt Preview"),
      ),
      body: PdfPreview(
        pdfFileName: "rcpt_${this._receipt.date}.pdf",
        allowPrinting: false,
        canChangePageFormat: false,
        actions: [
          PdfPreviewAction(
              icon: Icon(Icons.done),
              onPressed: (context, _, __) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              })
        ],
        build: (pageFormat) =>
            buildReceiptPdf(pageFormat, width, height, this._receipt),
      ),
    );
  }

  void sendEmail(BuildContext context) {
    // TODO Send email to client directly
  }

  Future<Uint8List> buildReceiptPdf(PdfPageFormat pageFormat, double width,
      double height, Receipt receipt) async {
    user = await User.getUserFromDatabase();
    rcptId = _receipt == null ? await Receipt.getLatestId() : _receipt.id;
    if (!_regenerate) Receipt.insertReceipt(receipt);

    final document = pw.Document();
    pw.RichText.debug = false;

    document.addPage(pw.Page(
        pageFormat: PdfPageFormat(width, height),
        margin: pw.EdgeInsets.all(10.0),
        build: (context) {
          return pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              // child:
              child: pw.Stack(children: [
                pw.Container(
                    height: height,
                    width: width,
                    alignment: pw.Alignment.center,
                    child: pw.Opacity(
                        opacity: 0.30,
                        child: pw.Container(
                            width: 200,
                            height: 200,
                            decoration: pw.BoxDecoration(
                              shape: pw.BoxShape.circle,
                            ),
                            child: pw.Image(
                                pw.MemoryImage(
                                    File(user.logoImagePath).readAsBytesSync()),
                                fit: pw.BoxFit.contain)))),
                pw.Column(children: [
                  _buildHeader(context, receipt),
                  _receiptContent(context, receipt),
                  pw.SizedBox(height: 40),
                ]),
                _buildFooter(context, receipt)
              ]));
        }));

    return document.save();
  }

  pw.Widget _buildHeader(pw.Context context, Receipt receipt) {
    return pw.Padding(
        padding: pw.EdgeInsets.all(8.0),
        child: pw.Column(
          children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                            "${(user == null || user.companyName == null) ? "CompanyName" : "${user.companyName}"}",
                            style: pw.TextStyle(fontSize: 14)),
                        pw.Text(
                            "${(user == null || user.address == null) ? "Address" : "${user.address}"}",
                            maxLines: 2,
                            style: pw.TextStyle(fontSize: 14)),
                        pw.Text(
                            "${(user == null || user.email == null) ? "Email" : "${user.email}"}",
                            style: pw.TextStyle(fontSize: 14)),
                        pw.Text(
                            "${(user == null || user.phoneNo == null) ? "PhoneNo" : "${user.phoneNo}"}",
                            style: pw.TextStyle(fontSize: 14)),
                        if (user.website != null)
                          pw.Text("${user.website}",
                              style: pw.TextStyle(fontSize: 14))
                      ]),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("RECEIPT",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 22)),
                        pw.Text(
                            "${rcptId == null ? "Receipt No:1" : "Receipt No:$rcptId"}",
                            style: pw.TextStyle(fontSize: 16)),
                        pw.Text(
                            "${receipt.date == null ? "Date" : "${receipt.date}"}",
                            style: pw.TextStyle(fontSize: 16)),
                      ])
                ]),
            pw.SizedBox(height: 10),
            pw.Divider(),
          ],
        ));
  }

  pw.Widget _buildFooter(pw.Context context, Receipt receipt) {
    // debugPrint("Inside buildFooter");
    // debugPrint("${receipt.date}");
    //return pw.Placeholder();
    return pw.Padding(
        padding: pw.EdgeInsets.all(8.0),
        child:
            pw.Column(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Thank you for your payment"),
                      pw.SizedBox(height: 40),
                    ]),
                pw.SizedBox(height: 40),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Container(
                          width: 100,
                          height: 50,
                          child: pw.Image(
                              pw.MemoryImage(
                                  File(user.signImagePath).readAsBytesSync()),
                              fit: pw.BoxFit.fill)),
                      pw.SizedBox(height: 5),
                      pw.Text("${user.userName}"),
                      pw.SizedBox(height: 40),
                      // _promotionFooter(context)
                    ]),
              ]),
          pw.Padding(padding: pw.EdgeInsets.all(8.0))
        ]));
  }

  pw.Widget _receiptContent(pw.Context context, Receipt receipt) {
    //return pw.Placeholder();

    return pw.Padding(
        padding: pw.EdgeInsets.all(8.0),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Received From:",
                        style: pw.TextStyle(fontSize: 16)),
                    pw.SizedBox(height: 5),
                    pw.Text(
                        "${receipt.fromName == null ? "Customer Name here" : receipt.fromName}",
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold))
                  ]),
              pw.Text(
                  "${receipt.amount == null ? "Amount in Rs" : "Rs ${receipt.amount}"}",
                  style: pw.TextStyle(fontSize: 20))
            ]));
  }

// pw.Widget _promotionFooter(pw.Context context) {
//   return pw.Row(
//       mainAxisAlignment: pw.MainAxisAlignment.center,
//       children: [
//         pw.Text("PDF generated by Mr Invoice for Mr Mukund Thakkar",
//             style: pw.TextStyle(fontStyle: pw.FontStyle.italic))
//       ]
//   );
// }
}
