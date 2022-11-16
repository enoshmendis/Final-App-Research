import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mlvapp/Member4/analysis_report.dart';
import 'package:mlvapp/Member4/preview_pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Preview extends StatefulWidget {
  const Preview({Key? key}) : super(key: key);

  @override
  PreviewState createState() {
    return PreviewState();
  }
}

class PreviewState extends State<Preview> with SingleTickerProviderStateMixin {
  late List<Tab> _myTabs;
  late List<LayoutCallback> _tabGen;
  late List<String> _tabUrl;
  int _tab = 0;
  late TabController _tabController;

  late PrintingInfo printingInfo;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();

    _myTabs = const <Tab>[
      Tab(text: 'Reports'),
    ];

    _tabGen = const <LayoutCallback>[
      generateResume, //MyApp.document_id
    ];

    _tabUrl = const <String>[
      '/Member4/preview_pdf.dart',
    ];

    _tabController = TabController(
      vsync: this,
      length: _myTabs.length,
      initialIndex: _tab,
    );
    _tabController.addListener(() {
      setState(() {
        _tab = _tabController.index;
      });
    });

    setState(() {
      printingInfo = info;
    });
  }

  void _showPrintedToast(BuildContext context) {
    // final scaffold = Scaffold.of(context);
    final scaffold = ScaffoldMessenger.of(context);
    // ignore: deprecated_member_use
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    // final scaffold = Scaffold.of(context);
    final scaffold = ScaffoldMessenger.of(context);
    // ignore: deprecated_member_use
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  Future<void> _saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File(appDocPath + '-report.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;

    if (_tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportView()),
          ),
        ),
        title: const Text('Mental Health'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _myTabs,
        ),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: _tabGen[_tab],
        actions: actions,
        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
      ),
    );
  }
}
