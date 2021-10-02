import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mr_invoice/models/TandC.dart';
import 'package:mr_invoice/models/client.dart';
import 'package:mr_invoice/models/service.dart';
import 'package:mr_invoice/models/user.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../models/invoice.dart';

class InvoiceBuilder {
  bool _regenerate;

  late List<Service> services;
  late Client client;
  late List<TandC> terms;
  late User user;
  late Invoice _invoice;
  late int invId;
  late bool _isEstimate;

  InvoiceBuilder({regenerate, invoice, isEstimate})
      : _regenerate = regenerate,
        _invoice = invoice,
        _isEstimate = isEstimate;

  Widget getInvoicePdfPreview() {
    print("Invoice Builder Estimate $_isEstimate");

    return PdfPreview(
        pdfFileName: (_isEstimate == true)
            ? "Estimate_${_invoice.date}.pdf"
            : "Invoice_${_invoice.date}.pdf",
        allowPrinting: false,
        canChangePageFormat: false,
        actions: [
          PdfPreviewAction(
              icon: Icon(Icons.done),
              onPressed: (context, _, __) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              })
        ],
        maxPageWidth: 700,
        build: (pageFormat) {
          return buildInvoicePdf(pageFormat);
        });
  }

  Future<Uint8List> buildInvoicePdf(PdfPageFormat pageFormat) async {
    client = await getClientDetails(this._invoice.forName);
    services = await Service.getServiceFromIds(this._invoice.listofProductIds);
    terms = await TandC.getTermsByIds(this._invoice.tAndCId);
    user = await User.getUserFromDatabase();
    invId = _invoice == null ? await Invoice.getLatestId() : _invoice.id!;
    if (!_regenerate) {
      Invoice.insertInvoice(this._invoice);
    }

    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
        margin: pw.EdgeInsets.all(10.0),
        header: _buildHeader,
        build: (context) {
          return [_buildInvoiceContent(context)];
        }));

    return doc.save();
  }

  Future<Client> getClientDetails(String name) async {
    var client = await Client.getClientByName(name);
    return client;
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Padding(
      padding:
          pw.EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child:
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              // pw.Container(
              //     alignment: pw.Alignment.centerLeft,
              //     padding: pw.EdgeInsets.all(8.0),
              //     height: 72,
              //     child: pw.PdfLogo()),
              // pw.SizedBox(width: 40),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(user.companyName == null
                        ? "Company Name"
                        : "${user.companyName}"),
                    pw.Text(
                        user.address == null ? "Address" : "${user.address}",
                        maxLines: 2,
                        textAlign: pw.TextAlign.justify),
                    pw.Text(user.email == null ? "Email" : "${user.email}"),
                    pw.Text(
                        user.phoneNo == null ? "Phone No" : "${user.phoneNo}"),
                    if (user.website != null) pw.Text("${user.website}"),
                  ]),
            ]),
        pw.Divider(),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ]),
    );
  }

  pw.Widget _buildInvoiceContent(pw.Context context) {
    return pw.Stack(children: [
      pw.Container(
          height: 700,
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
                      fit: pw.BoxFit.contain)))

          // decoration: pw.BoxDecoration(
          //   image: pw.DecorationImage(
          //     fit: pw.BoxFit.cover,
          //     image: PdfImage.file(context.document, bytes: File(user.logoImagePath).readAsBytesSync(),
          //     )
          //   )
          ),
      pw.Padding(
          padding: pw.EdgeInsets.all(8.0),
          child: pw.Column(
            children: [
              pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(this._isEstimate ? "ESTIMATE" : "INVOICE",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 24))),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 30),
                          pw.Text(
                              this._isEstimate ? "Estimate To" : "Invoice To",
                              style: pw.TextStyle(
                                  fontSize: 22,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(
                              client.name == null
                                  ? "Customer Name"
                                  : "${client.name}",
                              style: pw.TextStyle(fontSize: 18)),
                          pw.SizedBox(height: 2),
                          pw.Text(client.email == null
                              ? "Customer Email"
                              : "${client.email}"),
                          pw.Text(client.phoneNo == null
                              ? "Customer Contact No"
                              : "${client.phoneNo}")
                        ]),
                    pw.Spacer(),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              this._isEstimate
                                  ? "Estimate"
                                  : invId == null
                                      ? "Invoice Number"
                                      : "INV $invId",
                              style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(
                              this._invoice.date == null
                                  ? "Date Of Invoice"
                                  : "${this._invoice.date}",
                              style: pw.TextStyle(fontSize: 16))
                        ])
                  ]),
              pw.SizedBox(height: 20),
              _contentTable(context),
              pw.SizedBox(height: 20),
              _termsAndConditions(context)
            ],
          ))
    ]);
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = ["No.", "Products/Services", "Amount"];
    return pw.Column(children: [
      pw.Table.fromTextArray(
          border: pw.TableBorder(),
          cellAlignment: pw.Alignment.centerLeft,
          headerDecoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(2.0),
              color: PdfColors.blue),
          headerHeight: 25,
          cellHeight: 40,
          headerStyle: pw.TextStyle(
              color: PdfColors.white, fontWeight: pw.FontWeight.bold),
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.center,
            2: pw.Alignment.center,
          },
          rowDecoration: pw.BoxDecoration(
              border: pw.Border(
            bottom: pw.BorderSide(
              width: .5,
            ),
          )),
          headers: List<String>.generate(
              tableHeaders.length, (index) => tableHeaders[index]),
          data: List<List<String>>.generate(
              services.length,
              (row) => List<String>.generate(
                  tableHeaders.length, (col) => services[row].getIndex(col)))),
      pw.SizedBox(height: 20),
      pw.Row(children: [
        pw.Expanded(flex: 1, child: pw.SizedBox()),
        pw.Expanded(
            flex: 1,
            child: pw.Row(children: [
              pw.Text("Grand Total:",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(width: 40),
              pw.Container(
                  padding: pw.EdgeInsets.all(16.0),
                  color: PdfColors.blue,
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                      this._invoice.amount == null
                          ? "Amount"
                          : "${this._invoice.amount}",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold))),
            ]))
      ])
    ]);
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Column(children: [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(color: PdfColors.blue),
                    ),
                  ),
                  padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                  child: pw.Text(
                    'Terms & Conditions',
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.blue,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.ListView.builder(
                    itemCount: terms.length,
                    itemBuilder: (context, index) {
                      return pw.Text(
                        "${index + 1}. ${terms[index].terms}",
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                          fontSize: 12,
                          lineSpacing: 2,
                          color: PdfColors.blueGrey800,
                        ),
                      );
                    }),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.SizedBox(),
          ),
        ],
      ),
      pw.SizedBox(
        height: 40,
      ),
      pw.Row(children: [
        pw.Expanded(flex: 2, child: pw.SizedBox()),
        pw.Expanded(
            child: pw.Column(children: [
          pw.Container(
              width: 150,
              height: 50,
              child: pw.Image(
                  pw.MemoryImage(File(user.signImagePath).readAsBytesSync()),
                  fit: pw.BoxFit.fill)),
          pw.Text("${user.userName}"),
          pw.Text("${user.companyName}")
        ]))
      ])
    ]);
  }

// pw.Widget _buildFooter(pw.Context context) {
//   return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
//     pw.Text("Pdf generated by Mr Invoice for  Mukund Thakkar Productions")
//   ]);
// }
}
