import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:machine_test/Models/model_patientlist.dart';

class PdfExportAndViewPage extends StatefulWidget {
  final Patient patient;
  PdfExportAndViewPage({super.key, required this.patient});

  @override
  State<PdfExportAndViewPage> createState() => _PdfExportAndViewPageState();
}

class _PdfExportAndViewPageState extends State<PdfExportAndViewPage> {
  String? pdfFilePath;
  bool isLoading = false;

  Future<void> createAndSavePDF() async {
    setState(() => isLoading = true);
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();

    try {
      const double margin = 10;
      const double imageSize = 100;
      final double pageWidth = page.getClientSize().width;

      final ByteData watermarkData = await rootBundle.load(
        'assets/asset.jpg');
      // );
      final Uint8List watermarkBytes = watermarkData.buffer.asUint8List();
      final PdfBitmap watermarkImage = PdfBitmap(watermarkBytes);

      page.graphics.save();
      page.graphics.setTransparency(0.1);
      page.graphics.drawImage(
        watermarkImage,
        Rect.fromLTWH(
          0,
          0,
          page.getClientSize().width,
          page.getClientSize().height,
        ),
      );
      page.graphics.restore();

      final ByteData imageData = await rootBundle.load('assets/asset.jpg');
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      final PdfBitmap logo = PdfBitmap(imageBytes);

      page.graphics.drawImage(
        logo,
        Rect.fromLTWH(margin, margin, imageSize, imageSize),
      );

      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      final branch = widget.patient.branch;
      final String branchDetails =
          '''
${branch?.name ?? '-'}
${branch?.address ?? '-'}
${branch?.mail ?? '-'}
${branch?.phone ?? '-'}
${branch?.gst ?? '-'}
''';

      page.graphics.drawString(
        branchDetails,
        font,
        bounds: Rect.fromLTWH(
          pageWidth / 2,
          margin,
          pageWidth / 2 - 2 * margin,
          imageSize,
        ),
      );

      double headerBottom = margin + imageSize + 10;
      page.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 1),
        Offset(margin, headerBottom),
        Offset(pageWidth - margin, headerBottom),
      );

      double detailsTop = headerBottom + 20;
      final PdfFont headerFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        16,
        style: PdfFontStyle.bold,
      );
      page.graphics.drawString(
        'Patient Details',
        headerFont,
        brush: PdfSolidBrush(PdfColor(0, 128, 0)),
        bounds: Rect.fromLTWH(margin, detailsTop, pageWidth - 2 * margin, 25),
      );

      detailsTop += 30;
      final double colWidth = (pageWidth - 2 * margin) / 3;

      final Map<String, String?> patientData = {
        "Name": widget.patient.name,
        "Address": widget.patient.address,
        "Total": widget.patient.totalAmount?.toString(),
        "Discount": widget.patient.discountAmount?.toString(),
        "Whatsapp": widget.patient.phone,
        "Advance": widget.patient.advanceAmount?.toString(),
        "Balance": widget.patient.balanceAmount?.toString(),
        "Booked on": widget.patient.dateNdTime?.toString().split(' ')[0],
      };

      int colIndex = 0;
      int rowIndex = 0;
      patientData.forEach((key, value) {
        final double x = margin + colWidth * colIndex;
        final double y = detailsTop + 20 * rowIndex;
        page.graphics.drawString(
          '$key: ${value ?? '-'}',
          font,
          bounds: Rect.fromLTWH(x, y, colWidth, 20),
        );
        colIndex++;
        if (colIndex > 2) {
          colIndex = 0;
          rowIndex++;
        }
      });

      detailsTop += 20 * ((patientData.length / 3).ceil()) + 10;
      page.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 1),
        Offset(margin, detailsTop),
        Offset(pageWidth - margin, detailsTop),
      );

      detailsTop += 10;
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 5);
      grid.headers.add(1);

      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Treatment';
      header.cells[1].value = 'Price';
      header.cells[2].value = 'Male';
      header.cells[3].value = 'Female';
      header.cells[4].value = 'Total';

      for (int i = 0; i < header.cells.count; i++) {
        header.cells[i].style = PdfGridCellStyle(
          textBrush: PdfBrushes.green,
          borders: PdfBorders(
            left: PdfPen(PdfColor(255, 255, 255)),
            top: PdfPen(PdfColor(255, 255, 255)),
            right: PdfPen(PdfColor(255, 255, 255)),
            bottom: PdfPen(PdfColor(255, 255, 255)),
          ),
        );
      }

      for (var detail in widget.patient.patientdetailsSet) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = detail.treatmentName ?? '-';
        row.cells[1].value = detail.patient?.toString() ?? '0';
        row.cells[2].value = detail.male ?? '0';
        row.cells[3].value = detail.female ?? '0';

        final total =
            (int.tryParse(detail.male ?? '0') ?? 0) +
            (int.tryParse(detail.female ?? '0') ?? 0);
        row.cells[4].value = (total * (detail.patient?.toInt() ?? 0))
            .toString();

        for (int i = 0; i < row.cells.count; i++) {
          row.cells[i].style = PdfGridCellStyle(
            textBrush: PdfBrushes.black,
            borders: PdfBorders(
              left: PdfPen(PdfColor(255, 255, 255)),
              top: PdfPen(PdfColor(255, 255, 255)),
              right: PdfPen(PdfColor(255, 255, 255)),
              bottom: PdfPen(PdfColor(255, 255, 255)),
            ),
          );
        }
      }

      grid.draw(
        page: page,
        bounds: Rect.fromLTWH(margin, detailsTop, pageWidth - 2 * margin, 0),
      );

      detailsTop += 50;
      page.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 1),
        Offset(margin, detailsTop),
        Offset(pageWidth - margin, detailsTop),
      );

      final double summaryTop = detailsTop + 10;
      final PdfFont summaryFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        14,
        style: PdfFontStyle.bold,
      );

      page.graphics.drawString(
        'Total Amount: ${widget.patient.totalAmount?.toString() ?? '-'}',
        summaryFont,
        bounds: Rect.fromLTWH(margin, summaryTop, pageWidth - 2 * margin, 20),
      );

      page.graphics.drawString(
        'Discount: ${widget.patient.discountAmount?.toString() ?? '-'}',
        summaryFont,
        bounds: Rect.fromLTWH(
          margin,
          summaryTop + 20,
          pageWidth - 2 * margin,
          20,
        ),
      );

      page.graphics.drawString(
        'Advance: ${widget.patient.advanceAmount?.toString() ?? '-'}',
        summaryFont,
        bounds: Rect.fromLTWH(
          margin,
          summaryTop + 40,
          pageWidth - 2 * margin,
          20,
        ),
      );

      page.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 1),
        Offset(margin, summaryTop + 85),
        Offset(pageWidth - margin, summaryTop + 85),
      );

      page.graphics.drawString(
        'Balance: ${widget.patient.balanceAmount?.toString() ?? '-'}',
        summaryFont,
        bounds: Rect.fromLTWH(
          margin,
          summaryTop + 60,
          pageWidth - 2 * margin,
          20,
        ),
      );

      page.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 1),
        Offset(margin, summaryTop + 85),
        Offset(pageWidth - margin, summaryTop + 85),
      );

      final PdfFont thankFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        16,
        style: PdfFontStyle.bold,
      );
      final double thankTop = summaryTop + 100;
      page.graphics.drawString(
        'Thank you for choosing us',
        thankFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 128)),
        bounds: Rect.fromLTWH(margin, thankTop, pageWidth - 2 * margin, 25),
      );

      final PdfFont msgFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final double msgTop = thankTop + 25;
      page.graphics.drawString(
        "Your well-being is our commitment, and we're honored\n"
        "you've entrusted us with your health journey",
        msgFont,
        bounds: Rect.fromLTWH(margin, msgTop, pageWidth - 2 * margin, 40),
      );
    } catch (e) {
      print('Error generating PDF: $e');
    }

    List<int> bytes = await document.save();
    document.dispose();

    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/Bill.pdf');
    await file.writeAsBytes(bytes, flush: true);

    setState(() {
      pdfFilePath = file.path;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    createAndSavePDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Export & Viewer')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pdfFilePath != null
          ? SfPdfViewer.file(File(pdfFilePath!))
          : Center(child: Text('Failed to generate PDF')),
    );
  }
}
