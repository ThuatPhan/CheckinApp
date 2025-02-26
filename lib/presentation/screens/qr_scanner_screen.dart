import 'dart:convert';

import 'package:checkin_app/data/services/checkin_service.dart';
import 'package:checkin_app/domain/model/error_response.dart';
import 'package:checkin_app/domain/model/qr_code_model.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isFlashOn = false;
  bool isFrontCamera = false;
  bool hasScanned = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('QR Scanner'),
            actions: [
              IconButton(
                icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
                onPressed: isLoading
                    ? null
                    : () {
                  setState(() {
                    isFlashOn = !isFlashOn;
                    cameraController.toggleTorch();
                  });
                },
              ),
              IconButton(
                icon: Icon(isFrontCamera ? Icons.camera_front : Icons.camera_rear),
                onPressed: isLoading
                    ? null
                    : () {
                  setState(() {
                    isFrontCamera = !isFrontCamera;
                    cameraController.switchCamera();
                  });
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: MobileScanner(
                  controller: cameraController,
                  onDetect: (capture) {
                    if (hasScanned || isLoading) return; // Skip if already scanned or loading

                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        setState(() {
                          hasScanned = true;
                        });
                        cameraController.stop(); // Stop the scanner
                        _processQrCode(barcode.rawValue!);
                        break; // Exit after first successful scan
                      }
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black12,
                child: Center(
                  child: Text(
                    isLoading
                        ? 'Đang xử lý điểm danh...'
                        : hasScanned
                        ? 'QR Code scanned!'
                        : 'Align QR code within the frame to scan',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: hasScanned && !isLoading
              ? FloatingActionButton(
            onPressed: () {
              setState(() {
                hasScanned = false;
                cameraController.start(); // Restart the scanner
              });
            },
            child: const Icon(Icons.refresh),
          )
              : null,
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _processQrCode(String scannedValue) async {
    setState(() {
      isLoading = true;
    });

    try {
      final qrCode = QrCodeModel.fromJson(jsonDecode(scannedValue));
      final response = await CheckinService.instance.checkIn(
        qrCodeId: qrCode.id,
        qrCodeNonce: qrCode.nonce,
        locationId: qrCode.location.id,
        longitude: qrCode.location.longitude,
        latitude: qrCode.location.latitude,
      );
      final errorResponse = response.statusCode != 200
          ? ErrorResponse.fromJson(jsonDecode(response.body))
          : null;

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              response.statusCode == 200
                  ? "Điểm danh thành công"
                  : "Xảy ra lỗi khi điểm danh"),
          content: errorResponse != null ? Text(errorResponse.message) : null,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (mounted) {
                  setState(() {
                    hasScanned = false;
                    cameraController.start();
                  });
                }
              },
              child: const Text('Scan Again'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Xảy ra lỗi"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (mounted) {
                  setState(() {
                    hasScanned = false;
                    cameraController.start();
                  });
                }
              },
              child: const Text('Scan Again'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}