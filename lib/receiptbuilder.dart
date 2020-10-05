import 'dart:typed_data';
import 'dart:io';
import 'models/reciept.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'models/user.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


Widget getPdfPreview(double width, double height,Receipt receipt
    ) {


        return Scaffold(
          appBar: AppBar(title: Text("View Receipt Preview"),),
          body: PdfPreview(
             //pdfFileName: "${receipt == null ? "rcpt_1 ":"rcpt_${receipt.id}"}",
            allowPrinting: false,
            canChangePageFormat: false,
            actions: [
              PdfPreviewAction(
                icon: Icon(Icons.email),
                onPressed: (context,__,___){
                  sendEmail(context);
                }
              )
            ],
            build: (pageFormat) =>
                buildReceiptPdf(pageFormat, width, height,receipt),
          ),
        );


}

void sendEmail(BuildContext context) {
  // TODO Send email to client directly
}

PdfImage _logo;
PdfImage _sign;
Future<Uint8List> buildReceiptPdf(PdfPageFormat pageFormat, double width,
    double height, Receipt receipt) async {
  final document = pw.Document();
  pw.RichText.debug = false;

  //TODO Implement logic to pick image or draw

  // _logo = PdfImage.file(document.document,
  //    bytes:
  //        (await rootBundle.load('images/moneybag.png')).buffer.asUint8List());

  // Receipt receipt = Receipt.getReceiptById(id)

  User user = await User.getUserFromDatabase();




  document.addPage(pw.Page(
      pageFormat: PdfPageFormat(width, height),
      build: (context) {
        return pw.Padding(
            padding: pw.EdgeInsets.all(8.0),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context,receipt,user),
                  _receiptContent(context, receipt,user),
                  pw.SizedBox(height: 40),
                  _buildFooter(context,receipt,user)
                ]
            )
        );
      }
  ));

  return document.save();
}


pw.Widget _buildHeader(pw.Context context,Receipt receipt,User user) {
  return pw.Padding(
      padding: pw.EdgeInsets.all(8.0),
      child: pw.Column(
        children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(
                    alignment: pw.Alignment.centerLeft,
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.PdfLogo()),
                pw.Spacer(),
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("${(user == null || user.companyName == null ) ? "CompanyName":"${user.companyName}"}",style: pw.TextStyle(fontSize: 14)),
                      pw.Text("${( user == null || user.address == null )? "Address":"${user.address}"}", maxLines: 2,style: pw.TextStyle(fontSize: 14)),
                      pw.Text("${(user == null || user.email == null)?"Email":"${user.email}"}",style: pw.TextStyle(fontSize: 14)),
                      pw.Text("${(user == null || user.phoneNo == null)?"PhoneNo":"${user.phoneNo}"}",style: pw.TextStyle(fontSize: 14)),
                      pw.Text("${(user == null || user.website == null)?"Website":"${user.website}"}",style: pw.TextStyle(fontSize: 14))
                    ]),
                pw.Spacer(flex: 6),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                  pw.Text("RECEIPT",
                      style:
                      pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 22)),
                  pw.Text("${receipt.id ==null?"Receipt No:1":"Receipt No:${receipt.id}"}",style: pw.TextStyle(fontSize: 16)),
                  pw.Text("${receipt.date == null ? "Date":"${receipt.date}"}",style: pw.TextStyle(fontSize: 16)),
                ])
              ]),
          pw.SizedBox(height: 10),
          pw.Divider(),
        ],
      ));
}

pw.Widget _buildFooter(pw.Context context,Receipt receipt,User user) {
  return pw.Padding(
    padding: pw.EdgeInsets.all(8.0),
    child:  pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Thank you for your payment against "),
                      pw.Text("${receipt.forInvoice == null ? "LumpSum":"Invoice No: ${receipt.forInvoice}"}"),
                      pw.SizedBox(height: 40),
                    ]
                ),
                pw.SizedBox(height: 40),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("Sign"),
                      pw.Text("SenderName"),
                      pw.Text("Signature"),
                      pw.SizedBox(height: 40),
                      // _promotionFooter(context)
                    ]
                ),
              ]
          ),
          pw.Padding(
              padding: pw.EdgeInsets.all(8.0)
          )
        ]
    )
  );

}

pw.Widget _receiptContent(pw.Context context, Receipt receipt,User user) {
  return pw.Padding(
    padding: pw.EdgeInsets.all(8.0),
    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Received From:",style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 5),
                pw.Text(
                    "${receipt.fromName == null ? "Customer Name here" : receipt
                        .fromName}", style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold))
              ]
          ),
          pw.Text("${receipt.amount == null ? "Amount in Rs" : "Rs ${receipt.amount}"}",style: pw.TextStyle(fontSize: 20))
        ]
    )
  );

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
