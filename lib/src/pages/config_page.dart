import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:qrreaderapp/src/providers/theme_changer.dart';
import 'package:qrreaderapp/src/shared_prefs/preferencias.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  Color _primaryColor;
  bool _darkMode;

  final prefs = new PreferenciasUsuario();
  final scansBloc = new ScansBloc();

  @override
  void initState() {
    super.initState();
    _primaryColor = prefs.primaryColor;
    _darkMode = prefs.darkMode;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    Color primaryColor = Theme.of(context).primaryColor;
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('primaryColor').tr(),
          subtitle: Text('primaryColorSubtitle').tr(),
          trailing: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            height: 30.0,
            width: 30.0,
          ),
          onTap: () => colorPicker(context, theme),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.only(right: 2.0, left: 16.0),
          value: _darkMode,
          onChanged: (value) {
            setState(() {
              changeTheme(value, _primaryColor, theme);
            });
          },
          title: Text('darkMode').tr(),
          subtitle: Text('darkModeSubtitle').tr(),
          activeColor: _primaryColor,
        ),
        ListTile(
          onTap: () => languageDialog(),
          title: Text('language').tr(),
          subtitle: Text('languageSubtitle').tr(),
          trailing: Icon(
            Icons.translate,
            color: _primaryColor,
          ),
        ),
        ListTile(
          title: Text('cleanHistory').tr(),
          subtitle: Text('cleanHistorySubtitle').tr(),
          trailing: Icon(
            Icons.delete_forever,
            color: _primaryColor,
          ),
          onTap: () => alertDialog(context),
        ),
        SizedBox(
          height: 50.0,
        ),
        Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Image(
                image: AssetImage('assets/logo.png'),
                height: 40.0,
              ),
            ),
            Text(
              'version',
              style: TextStyle(fontSize: 12.0),
            ).tr(),
          ],
        ),
      ],
    );
  }

  void alertDialog(BuildContext context) {
    var alert = AlertDialog(
      title: Text('Alerta!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('¿Está seguro que desea borrar el historial de los scans?'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
            child: Text('Aceptar'),
            onPressed: () {
              scansBloc.borrarScansTODOS();
              Navigator.of(context).pop();
            }),
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void changeColor(Color color) {
    setState(() {
      _primaryColor = color;
      prefs.primaryColor = color;
    });
  }

  void colorPicker(BuildContext context, theme) {
    var colorpicker = AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _primaryColor,
          onColorChanged: changeColor,
          showLabel: false,
          pickerAreaHeightPercent: 0.8,
          enableAlpha: false,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text('Cambiar'),
          onPressed: () {
            setState(() {
              changeTheme(_darkMode, _primaryColor, theme);
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
        context: context, builder: (BuildContext context) => colorpicker);
  }

  void changeTheme(bool darkMode, Color primaryColor, ThemeChanger theme) {
    _darkMode = darkMode;
    _primaryColor = primaryColor;
    prefs.primaryColor = primaryColor;
    prefs.darkMode = darkMode;
    theme.setTheme(
      ThemeData(
        brightness: prefs.darkMode ? Brightness.dark : Brightness.light,
        primaryColor: prefs.primaryColor,
      ),
    );
    theme.setNavigationBarTheme(
      FFNavigationBarTheme(
        barBackgroundColor: prefs.darkMode ? Colors.black12 : Colors.white,
        selectedItemBorderColor: prefs.darkMode ? Colors.black12 : Colors.white,
        selectedItemBackgroundColor: _primaryColor,
        selectedItemIconColor: prefs.darkMode ? Colors.black : Colors.white,
        selectedItemLabelColor: prefs.darkMode ? Colors.white : Colors.black,
      ),
    );
  }

  void languageDialog() {
    Widget optionOne = SimpleDialogOption(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Deutsch'),
          Image(
            image: AssetImage('assets/flags/germany.png'),
            height: 20.0,
          ),
        ],
      ),
      onPressed: () {
        cambiarIdioma('de');
        Navigator.of(context).pop();
      },
    );
    Widget optionTwo = SimpleDialogOption(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('English'),
          Image(
            image: AssetImage('assets/flags/usa.png'),
            height: 20.0,
          ),
        ],
      ),
      onPressed: () {
        cambiarIdioma('en');
        Navigator.of(context).pop();
      },
    );
    Widget optionThree = SimpleDialogOption(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Español'),
          Image(
            image: AssetImage('assets/flags/spain.png'),
            height: 20.0,
          ),
        ],
      ),
      onPressed: () {
        cambiarIdioma('es');
        Navigator.of(context).pop();
      },
    );
    Widget optionFour = SimpleDialogOption(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Français'),
          Image(
            image: AssetImage('assets/flags/france.png'),
            height: 20.0,
          ),
        ],
      ),
      onPressed: () {
        cambiarIdioma('fr');
        Navigator.of(context).pop();
      },
    );
    Widget optionFive = SimpleDialogOption(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Italiano'),
          Image(
            image: AssetImage('assets/flags/italy.png'),
            height: 20.0,
          ),
        ],
      ),
      onPressed: () {
        cambiarIdioma('it');
        Navigator.of(context).pop();
      },
    );

    // set up the SimpleDialog
    SimpleDialog dialog = SimpleDialog(
      title: const Text('chooseLanguage').tr(),
      children: <Widget>[
        optionOne,
        optionTwo,
        optionThree,
        optionFour,
        optionFive,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  void cambiarIdioma(String code) {
    EasyLocalizationProvider.of(context).locale = Locale(code);
    prefs.language = code;
  }
}
