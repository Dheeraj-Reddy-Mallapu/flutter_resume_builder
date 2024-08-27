import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_resume_template/flutter_resume_template.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:resume_builder_app/main.dart';
import 'package:resume_builder_app/utils/routes/app_colors.dart';
import 'package:resume_builder_app/views/view_cv/cv_types/business_cv.dart';
import 'package:resume_builder_app/views/view_cv/cv_types/classic_cv.dart';
import 'package:resume_builder_app/views/view_cv/cv_types/modern_cv.dart';
import 'package:resume_builder_app/views/view_cv/cv_types/technical_cv.dart';
import 'package:resume_builder_app/views/widgets/app_bar.dart';
import 'package:pdf/widgets.dart' as pw;

class ViewCv extends StatefulWidget {
  const ViewCv({super.key,required this.templateData});
  final TemplateData templateData;

  @override
  State<ViewCv> createState() => _ViewCvState();
}

class _ViewCvState extends State<ViewCv> with SingleTickerProviderStateMixin {
  GlobalKey key=GlobalKey();
  late TabController tabController;
  double height=2000;

  @override
  void initState() {
    tabController=TabController(length: 4, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(tabBar: tabBar(),).build(context, "CV"),
      body:TabBarView(
        controller: tabController,
          children: [
            ClassicCV(templateData: widget.templateData),
            ModernCv(templateData: widget.templateData),
            TechnicalCV(templateData: widget.templateData),
            BusinessCV(templateData: widget.templateData),
          ]
      ),
    );
  }

  Future<Uint8List> _capturePng(GlobalKey key) async {
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 4.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
  
  Future<void> saveResume()async{
    try {
      final pdf = pw.Document();

      // Capture the widget as an image
      final image = await _capturePng(key);
      final memoryImage=pw.MemoryImage(image);

      // Add the image to a PDF page
      pdf.addPage(
        pw.Page(
          pageFormat:  PdfPageFormat(memoryImage.width?.toDouble() ?? 200 ,memoryImage.height?.toDouble()?? 700,marginAll: 0.0),
          margin: pw.EdgeInsets.zero, // Removes the default margin
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(memoryImage, fit: pw.BoxFit.contain,),
            );
          },
        ),
      );

      // Get the temporary directory and save the file
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/resume.pdf");
      print(file.path);
      await file.writeAsBytes(await pdf.save());

      // Optionally, share or print the PDF
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'resume.pdf');
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }

  Widget tabBar(){
    return TabBar(
        controller: tabController,
        dividerHeight: 0,
        indicatorColor: Colors.white,
        tabs: [
          Tab(child: Text('Classic',style: TextStyle(color: Colors.white,fontSize: 12.sp),),),
          Tab(child: Text('Modern',style: TextStyle(color: Colors.white,fontSize: 12.sp),),),
          Tab(child: Text('Technical',style: TextStyle(color: Colors.white,fontSize: 12.sp),),),
          Tab(child: Text('Business',style: TextStyle(color: Colors.white,fontSize: 12.sp),),),
        ]);
  }
}
