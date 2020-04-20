import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mrz_scanner/flutter_mrz_scanner.dart';
import 'package:scanner_id/i18/app_localizations.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isParsed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate("app_title"),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => exit(0))
          ],
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: MRZScanner(
                onParsed: (result) async {
                  if (isParsed) {
                    return;
                  }
                  isParsed = true;
                  await _showDialog(result);
                },
                onError: (error) => print(error),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/id_card_pl.jpg",
                    width: 200,
                  )),
            )
          ],
        ));
  }

  _showDialog(dynamic result) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate("card_details")),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                  '${AppLocalizations.of(context).translate("document_type")}: ${result.documentType}'),
              Text(
                  '${AppLocalizations.of(context).translate("country")}: ${result.countryCode}'),
              Text(
                  '${AppLocalizations.of(context).translate("surnames")}: ${result.surnames}'),
              Text(
                  '${AppLocalizations.of(context).translate("given_names")}: ${result.givenNames}'),
              Text(
                  '${AppLocalizations.of(context).translate("document_number")}: ${result.documentNumber}'),
              Text(
                  '${AppLocalizations.of(context).translate("nationality_code")}: ${result.nationalityCountryCode}'),
              Text(
                  '${AppLocalizations.of(context).translate("birthdate")}: ${result.birthDate}'),
              Text(
                  '${AppLocalizations.of(context).translate("sex")}: ${result.sex}'),
              Text(
                  '${AppLocalizations.of(context).translate("expriy_date")}: ${result.expiryDate}'),
              result.personalNumber == null
                  ? Container()
                  : Text(
                      '${AppLocalizations.of(context).translate("personal_number")}: ${result.personalNumber}'),
              result.personalNumber2 == null
                  ? Container()
                  : Text(
                      '${AppLocalizations.of(context).translate("personal_number_2")}: ${result.personalNumber2}'),
            ]),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                isParsed = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
