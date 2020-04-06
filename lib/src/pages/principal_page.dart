import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/pages/config_page.dart';
import 'package:qrreaderapp/src/pages/scan_page.dart';
import 'package:qrreaderapp/src/pages/qrgen_page.dart';
import 'package:qrreaderapp/src/providers/sca_icons.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:qrreaderapp/src/providers/theme_changer.dart';
import 'package:provider/provider.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<PrincipalPage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('QR/Barcode Scan and Generator'),
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(primaryColor),
    );
  }

  Widget _crearBottomNavigationBar(Color primaryColor) {
    final theme = Provider.of<ThemeChanger>(context);
    return FFNavigationBar(
      theme: theme.getNavigationBarTheme(),
      selectedIndex: currentIndex,
      onSelectTab: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        FFNavigationBarItem(iconData: Sca.camera, label: 'navScan'.tr()),
        FFNavigationBarItem(iconData: Sca.qrcode, label: 'navGen'.tr()),
        FFNavigationBarItem(iconData: Sca.cog, label: 'navCon'.tr()),
      ],
    );
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return ScanPage();
      case 1:
        return QrgenPage();
      case 2:
        return ConfigPage();
      default:
        return ScanPage();
    }
  }
}
