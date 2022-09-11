
import 'dart:io';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:torch_controller/torch_controller.dart';

import '../../../Config.dart';
import '../../../utilities/CheckPermission.dart';

class BarcodeScannerComponent extends StatefulWidget {
  const BarcodeScannerComponent({
    Key? key,
    required this.addFunc,
  }) : super(key: key);

  final Future<void> Function(String) addFunc;

  @override
  State<BarcodeScannerComponent> createState() => _BarcodeScannerComponentState();
}

class _BarcodeScannerComponentState extends State<BarcodeScannerComponent> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final TorchController _torchController = TorchController();

  late CheckPermission _checkPermission;
  late QRViewController _scannerController;

  Barcode? _result;
  bool _hasVibrator = false;
  bool _hasTorchLight = false;
  bool _activeVibrator = true;
  bool _activeFlashLight = false;

  @override
  void initState() {
    super.initState();

    initialize();

    _checkPermission = CheckPermission(context: context);
  }

  void initialize() async {
    _hasVibrator = await Vibration.hasVibrator() ?? false;
    bool? hasTorch = await _torchController.hasTorch;
    if (hasTorch != null) {
      _hasTorchLight = hasTorch;
    } else {
      _hasTorchLight = false;
    }
    setState(() {});
  }

  Widget _buildQrScanner(BuildContext context) {
    return QRView(
      key: qrKey, onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Config.shadowColor, borderWidth: 10,
        borderRadius: Config.activityBorderRadius, borderLength: 30,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    _scannerController = controller;

    _scannerController.resumeCamera();

    _scannerController.scannedDataStream.listen((res) async {
      _vibrate();
      if (_result == null) {
        _result = res;
        _scannerController.pauseCamera();
        if (res.code != null) {
          await widget.addFunc(res.code!);
        }

        Timer(const Duration(milliseconds: Config.animDuration), () {
          _result = null;
          _scannerController.resumeCamera();
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController controller, bool p) {
    log(
      '${DateTime.now().toIso8601String()}_onPermissionSet $p', name: Config.appName,
    );

    if (!p) {
      _checkPermission.serviceIsEnabled(
        context: context, device: Device.camera, callback: () {},
      );
    }
  }

  void _vibrate() {
    if (_hasVibrator && _activeVibrator) {
      Vibration.vibrate(duration: Config.animDuration * 2);
    }
  }

  Widget _buildControllers() {
    return Padding(
      padding: const EdgeInsets.all(Config.padding / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Wrap(
            children: <Widget>[
              _hasTorchLight ?
              Padding(
                padding: const EdgeInsets.only(bottom: Config.padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        try {
                          _scannerController.toggleFlash();
                        } catch (error) {
                          log(
                            'ScanProductsScreen: _buildControllers: error {$error}',
                            name: Config.appName,
                          );
                        }
                        setState(() {
                          _activeFlashLight = !_activeFlashLight;
                        });
                      },
                      icon: Icon(
                        Icons.flash_on, size: Config.iconSize,
                        color: _activeFlashLight
                            ? Config.textColorOnPrimary
                            : Config.textColorOnPrimary.withOpacity(.3),
                      ),
                    ),
                  ],
                ),
              ) : const SizedBox(),

              _hasVibrator ?
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _activeVibrator = !_activeVibrator;
                      });
                      if (_activeVibrator) {
                        _vibrate();
                      }
                    },
                    icon: Icon(
                      Icons.vibration, size: Config.iconSize,
                      color: _activeVibrator
                          ? Config.textColorOnPrimary
                          : Config.textColorOnPrimary.withOpacity(.3),
                    ),
                  ),
                ],
              ) : const SizedBox(),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  _scannerController.flipCamera();
                },
                icon: const Icon(
                  Icons.flip_camera_ios, size: Config.iconSize,
                  color: Config.textColorOnPrimary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) {
      _scannerController.pauseCamera();
    }
    _scannerController.resumeCamera();
  }

  @override
  void dispose() {
    if (mounted) {
      _scannerController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildQrScanner(context),

        _buildControllers(),
      ],
    );
  }
}
