import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mr_invoice/models/TandC.dart';
import 'package:mr_invoice/models/client.dart';
import 'package:mr_invoice/models/service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'models/invoice.dart';

Widget getInvoicePdfPreview(Invoice invoice) {
  return PdfPreview(
      allowPrinting: false,
      canChangePageFormat: false,
      maxPageWidth: 700,
      build: (pageFormat) {
        return buildInvoicePdf(pageFormat, invoice);
      });
}

Future<Uint8List> buildInvoicePdf(
    PdfPageFormat pageFormat, Invoice invoice) async {
  // print("Invoice ID: ${invoice.id}");
  // print("Invoice ListOfProductIds ${invoice.listofProductIds}");
  // print("Invoice ListOfTandCIds ${invoice.tAndCId}");
  Client client = await getClientDetails(invoice.forName);
  List<Service> services =
      await Service.getServiceFromIds(invoice.listofProductIds);
  List<TandC> terms = await TandC.getTermsByIds(invoice.tAndCId);
  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
      margin: pw.EdgeInsets.all(10.0),
      header: _buildHeader,
      footer: null,
      build: (context) {
        return [
          _buildInvoiceContent(context, invoice, client, services, terms)
        ];
      }));

  return doc.save();
}



Future<Client> getClientDetails(String name) async {
  var client = await Client.getClientByName(name);
  return client;
}

pw.Widget _buildHeader(pw.Context context) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
    child:
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Container(
                alignment: pw.Alignment.centerLeft,
                padding: pw.EdgeInsets.all(8.0),
                height: 72,
                child: pw.PdfLogo()),
            pw.SizedBox(width: 40),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Company Name"),
                  pw.Text("Sender's Name"),
                  pw.Text("Address", maxLines: 2),
                  pw.Text("Email ID"),
                  pw.Text("Contact No"),
                  pw.Text("Website")
                ]),
          ]),
      pw.Divider(),
      if (context.pageNumber > 1) pw.SizedBox(height: 20)
    ]),
  );
}

pw.Widget _buildInvoiceContent(pw.Context context, Invoice invoice,
    Client client, List<Service> services, List<TandC> terms) {
  return pw.Padding(
      padding: pw.EdgeInsets.all(8.0),
      child: pw.Column(
        children: [
          pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text("INVOICE",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 24))),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 30),
                      pw.Text("Invoice To",
                          style: pw.TextStyle(
                              fontSize: 22, fontWeight: pw.FontWeight.bold)),
                      pw.Text(client.name == null
                          ? "Customer Name"
                          : "${client.name}",style: pw.TextStyle(
                          fontSize: 18)),
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
                          invoice.id == null
                              ? "Invoice Number"
                              : "INV ${invoice.id}",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      pw.Text(invoice.date == null
                          ? "Date Of Invoice"
                          : "${invoice.date}",style: pw.TextStyle(
                          fontSize: 16))
                    ])
              ]),
          pw.SizedBox(height: 20),
          _contentTable(context, services, invoice.amount),
          pw.SizedBox(height: 20),
          _termsAndConditions(context, terms)
        ],
      ));
}

pw.Widget _contentTable(
    pw.Context context, List<Service> services, int amount) {
  const tableHeaders = ["No.", "Products/Services", "Amount"];
  return pw.Column(children: [
    pw.Table.fromTextArray(
        border: pw.TableBorder(),
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration:
            pw.BoxDecoration(borderRadius: 2, color: PdfColors.blue),
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
            border: pw.BoxBorder(
          bottom: true,
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
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(width: 40),
            pw.Container(
                padding: pw.EdgeInsets.all(16.0),
                color: PdfColors.blue,
                alignment: pw.Alignment.centerRight,
                child: pw.Text(amount == null ? "Amount" : "$amount",
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold))),
          ]))
    ])
  ]);
}

pw.Widget _termsAndConditions(pw.Context context, List<TandC> terms) {
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
                  border: pw.BoxBorder(
                    top: true,
                    color: PdfColors.blue,
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
                      "${index+1}. ${terms[index].terms}",
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
        pw.Text("Signature"),
        pw.Text("Mukund Thakkar Productions")
      ]))
    ])
  ]);
}

// pw.Widget _buildFooter(pw.Context context) {
//   return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
//     pw.Text("Pdf generated by Mr Invoice for  Mukund Thakkar Productions")
//   ]);
// }
