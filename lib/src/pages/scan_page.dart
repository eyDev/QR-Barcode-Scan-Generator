import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/model/scan_model.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_share/flutter_share.dart';

class ScanPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.obtenerScans();

    return Scaffold(
      body: StreamBuilder<List<ScanModel>>(
        stream: scansBloc.scansStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final scans = snapshot.data;
          if (scans.length == 0) {
            return Center(
              child: Text('empty').tr(),
            );
          }

          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red),
              onDismissed: (direction) => scansBloc.borrarScan(scans[i].id),
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      _share(scans[i].valor);
                    },
                    color: Theme.of(context).primaryColor),
                title: Text(scans[i].valor),
                trailing: IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: () {
                    _launchURL(scans[i].valor);
                  },
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: scans[i].valor));
                  final snackBar = SnackBar(
                    content: Text('copied').tr(),
                    action: SnackBarAction(
                      label: 'hide'.tr(),
                      onPressed: () {},
                    ),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scanQR(context),
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {
    String futureString;
    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {}
    if (futureString != null) {
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);
      _showAfterScan(context, futureString);
    }
  }

  _launchURL(String texto) async {
    if (await canLaunch(texto)) {
      //await launch(texto);
      await launch(texto);
    } else {
      await launch('https://www.google.com/search?q=$texto');
    }
  }

  Future<void> _share(String scanValor) async {
    await FlutterShare.share(
        title: 'QR code', text: scanValor, chooserTitle: 'share'.tr());
  }

  _showAfterScan(BuildContext context, String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'QRdetected',
            textAlign: TextAlign.center,
          ).tr(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(
                height: 20.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  value,
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'closeD',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ).tr(),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _share(value);
                    },
                    child: Text(
                      'shareD',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ).tr(),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _launchURL(value);
                    },
                    child: Text(
                      'openD',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ).tr(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
