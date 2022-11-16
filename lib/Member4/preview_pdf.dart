import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlvapp/Member4/indicator.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
const sep = 120.0;

Future<Uint8List> generateResume(PdfPageFormat format) async { //, String did
  final doc = pw.Document(title: 'Report', author: 'Mental Health App');
  const tableHeaders = ['Category', 'Civil Status', 'Stress levels'];

  const dataTable = [
    ['Software Engineers', 'Single', 90],
    ['Engineer - QA', 'Married', 70],
    ['Doctors', 'Single', 95],
    ['Civil Engineers', 'Married', 80],
    ['Construction Workers', 'Single', 30],
    ['Bank Workers', 'Married', 95],
    ['Insurance Agents', 'Single', 40],
  ];
  const baseColor = PdfColors.cyan;
  final theme = pw.ThemeData.withFont(
    base: await PdfGoogleFonts.openSansRegular(),
    bold: await PdfGoogleFonts.openSansBold(),
  );
  final expense = dataTable
      .map((e) => e[2] as num)
      .reduce((value, element) => value + element);

  final table = pw.Table.fromTextArray(
    border: null,
    headers: tableHeaders,
    data: List<List<dynamic>>.generate(
      dataTable.length,
          (index) => <dynamic>[
        dataTable[index][0],
        dataTable[index][1],
        dataTable[index][2],
        // (dataTable[index][1] as num) - (dataTable[index][2] as num),
      ],
    ),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontWeight: pw.FontWeight.bold,
    ),
    headerDecoration: const pw.BoxDecoration(
      color: baseColor,
    ),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: baseColor,
          width: .5,
        ),
      ),
    ),
    cellAlignment: pw.Alignment.centerRight,
    cellAlignments: {0: pw.Alignment.centerLeft},
  );

  // final pageTheme = await _myPageTheme(format);

  doc.addPage(
    pw.Page(
      // pageFormat: pageFormat,
      theme: theme,
      build: (context) {
        const chartColors = [
          PdfColors.blue300,
          PdfColors.green300,
          PdfColors.amber300,
          PdfColors.pink300,
          PdfColors.cyan300,
          PdfColors.purple300,
          PdfColors.lime300,
        ];

        return pw.Column(
          children: [
            pw.Flexible(
              child: pw.Chart(
                title: pw.Text(
                  'Mental Health Analysis',
                  style: const pw.TextStyle(
                    // color: baseColor,
                    fontSize: 20,
                  ),
                ),
                grid: pw.PieGrid(),
                datasets: List<pw.Dataset>.generate(dataTable.length, (index) {
                  final data = dataTable[index];
                  final color = chartColors[index % chartColors.length];
                  final value = (data[2] as num).toDouble();
                  final pct = (value / expense * 100).round();
                  return pw.PieDataSet(
                    legend: '${data[0]}\n$pct%',
                    value: value,
                    color: color,
                    legendStyle: const pw.TextStyle(fontSize: 10),
                  );
                }),
              ),
            ),
            table,
          ],
        );
      },
    ),
  );
  return doc.save();
}

// Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
//   final bgShape = await rootBundle.loadString('assets/resume.svg');
//
//   format = format.applyMargin(
//       left: 2.0 * PdfPageFormat.cm,
//       top: 4.0 * PdfPageFormat.cm,
//       right: 2.0 * PdfPageFormat.cm,
//       bottom: 2.0 * PdfPageFormat.cm);
//   return pw.PageTheme(
//     pageFormat: format,
//     buildBackground: (pw.Context context) {
//       return pw.FullPage(
//         ignoreMargins: true,
//         child: pw.Stack(
//           children: [
//             pw.Positioned(
//               child: pw.SvgImage(svg: bgShape),
//               left: 0,
//               top: 0,
//             ),
//             pw.Positioned(
//               child: pw.Transform.rotate(
//                   angle: pi, child: pw.SvgImage(svg: bgShape)),
//               right: 0,
//               bottom: 0,
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
//
// class _UrlText extends pw.StatelessWidget {
//   _UrlText(this.text, this.url);
//
//   final String text;
//   final String url;
//
//   @override
//   pw.Widget build(pw.Context context) {
//     return pw.UrlLink(
//       destination: url,
//       child: pw.Text(text,
//           style: const pw.TextStyle(
//             decoration: pw.TextDecoration.underline,
//             color: PdfColors.blue,
//           )),
//     );
//   }
// }