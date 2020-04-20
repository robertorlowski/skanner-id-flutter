import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanner_id/camera_page.dart';
import 'package:scanner_id/i18/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale(ui.window.locale.languageCode),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('pl', 'PL'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: FutureBuilder<Map<PermissionGroup, PermissionStatus>>(
        future:
            PermissionHandler().requestPermissions([PermissionGroup.camera]),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data[PermissionGroup.camera] ==
                  PermissionStatus.granted) {
            return CameraPage();
          }
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Container(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate("awaiting_for_permissions"),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
