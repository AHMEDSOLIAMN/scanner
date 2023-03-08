import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String initQrTitle = 'AHMED SOLIMAN';
  var result = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      text: 'Scan Barcode',
                      icon: Icon(
                        Icons.qr_code_scanner,
                      ),
                    ),
                    Tab(
                      text: 'Create Barcode',
                      icon: Icon(
                        Icons.qr_code,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Center(
                        child: Container(
                          width: 150.w,
                          child: ElevatedButton(
                            onPressed: () {
                              qrCodeScan();
                            },
                            child: Text(
                              "Let's scan it",
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            BarcodeWidget(
                              data: initQrTitle,
                              barcode: Barcode.qrCode(),
                              color: Colors.black,
                              height: 200.h,
                              width: 200.w,
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  initQrTitle = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Links, text, etc.',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

  Future<void> qrCodeScan() async {
    try {
      FlutterBarcodeScanner.scanBarcode(
        '#913175',
        'Cancel',
        true,
        ScanMode.QR,
      ).then((value) {
        setState(() {
          result = value;
        });
        if (result == "-1") {
          return Container();
        } else {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return BottomSheet(
                onClosing: () {},
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 250.h,
                          width: 300.w,
                          child: Center(
                            child: SelectableText(
                              '$result',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            _launchURL(result);
                          },
                          child: Text('Go to link'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
