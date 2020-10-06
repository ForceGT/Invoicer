import 'dart:typed_data';

import 'package:mr_invoice/models/service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Future<Uint8List> buildInvoicePdf(PdfPageFormat pageFormat) async {
  final doc = pw.Document();

  doc.addPage(pw.MultiPage(
      margin: pw.EdgeInsets.all(10.0),
      header: _buildHeader,
      footer: _buildFooter,
      build: (context) => [_buildInvoiceContent(context)]));

  return doc.save();
}

pw.Widget _buildHeader(pw.Context context) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
    child: pw.Column(children: [
      pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
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

pw.Widget _buildInvoiceContent(pw.Context context) {
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
                      pw.SizedBox(height: 20),
                      pw.Text("Invoice To",
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Customer Name"),
                      pw.Text("Customer Email"),
                      pw.Text("Customer Contact No")
                    ]),
                pw.Spacer(),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Invoice Number",
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Date Of Invoice")
                    ])
              ]),
          pw.SizedBox(height: 20),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _termsAndConditions(context)
        ],
      ));
}

pw.Widget _contentTable(pw.Context context) {
  final services = [
    Service(id: 1, name: "Photography", rate: 20.0),
    Service(id: 2, name: "Wedding Filmography", rate: 40.0),
    Service(id: 3, name: "Birthday Photoshoot", rate: 60.0),
    Service(id: 4, name: "Some Services", rate: 80.0)
  ];

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
                child: pw.Text("200.0",
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
                  border: pw.BoxBorder(
                    top: true,
                    color: PdfColors.blue,
                  ),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.blue,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                pw.LoremText().paragraph(40),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: PdfColors.blueGrey800,
                ),
              ),
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

pw.Widget _buildFooter(pw.Context context) {
  return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
    pw.Text("Pdf generated by Mr Invoice for  Mukund Thakkar Productions")
  ]);
}
