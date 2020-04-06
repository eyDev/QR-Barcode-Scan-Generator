import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/providers/sca_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class QrgenPage extends StatefulWidget {
  @override
  _QrgenPageState createState() => _QrgenPageState();
}

class _QrgenPageState extends State<QrgenPage> {
  final txtController = TextEditingController();
  String data = '';
  double _valorSlider = 100.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Color _primaryColor = Theme.of(context).primaryColor;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _crearTextfield(context, _primaryColor),
          SizedBox(height: 20.0),
          _crearBoton(width, context, _primaryColor),
          _crearSlider(_primaryColor),
          _crearQRimage(width, context),
        ],
      ),
    );
  }

  Widget _crearTextfield(BuildContext context, Color _primaryColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: txtController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _primaryColor),
          ),
          hintText: 'hintTextGen'.tr(),
          icon: Icon(Sca.qrcode, color: _primaryColor),
          labelText: 'labelTextGen'.tr(),
          labelStyle: TextStyle(
            color: _primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _crearBoton(double width, BuildContext context, Color _primaryColor) {
    return RaisedButton(
      onPressed: () {
        setState(() {
          data = txtController.text;
        });
      },
      child: Container(
        width: width * 0.75,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Center(child: Text('buttonText').tr()),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 0.0,
      color: _primaryColor,
      textColor: Colors.white,
    );
  }

  Widget _crearQRimage(double width, BuildContext context) {
    return QrImage(
      data: data,
      version: QrVersions.auto,
      size: width * 0.8 * (_valorSlider / 100),
      gapless: false,
      backgroundColor: Colors.white,
    );
  }

  Widget _crearSlider(Color _primaryColor) {
    return Slider(
      activeColor: _primaryColor,
      value: _valorSlider,
      min: 30.0,
      max: 100.0,
      onChanged: (valor) {
        setState(() {
          _valorSlider = valor;
        });
      },
    );
  }
}
