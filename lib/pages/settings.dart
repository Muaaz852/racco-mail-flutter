import 'package:flutter/material.dart';

import 'package:racco_mail/models/sender_data.dart';

import 'package:racco_mail/pages/setup.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    'firstName': null,
    'lastName': null,
    'email': null,
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _readFormDataFromPrefs(),
      builder: (BuildContext context, AsyncSnapshot<SenderData> snapshot) {
        SenderData _senderData = SenderData(name: '', surname: '', email: '');
        if (snapshot.data.name != null || snapshot.data.surname != null || snapshot.data.email != null) {
          _senderData = SenderData(name: snapshot.data.name, email: snapshot.data.email, surname: snapshot.data.surname);
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Color.fromRGBO(30, 52, 70, 1),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context, false),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.settings),
                SizedBox(
                  width: 10.0,
                ),
                Text('IMPOSTAZIONI'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildFirstNameLabelAndTextField(_senderData.name ?? ''),
                    SizedBox(height: 5),
                    _buildLastNameLabelAndTextField(_senderData.surname ?? ''),
                    SizedBox(height: 5),
                    _buildEmailLabelAndTextField(_senderData.email ?? ''),
                    SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        color: Color.fromRGBO(225, 28, 60, 1),
                        child: Text(
                          'SALVA I TUOI DATI',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _submitForm();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFirstNameLabelAndTextField(String initialValue) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Text(
            'Nome',
            style: TextStyle(fontSize: 17),
          ),
        ),
        SizedBox(width: 57.6),
        Expanded(
          child: Tooltip(
            message: 'inserisci il tuo nome',
            child: TextFormField(
              initialValue: initialValue,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                helperText: ' ',
                contentPadding: EdgeInsets.all(6.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Per favore inserisci il tuo nome';
                }
              },
              onSaved: (String value) {
                _formData['firstName'] = value;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastNameLabelAndTextField(String initialValue) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Text(
            'Cognome',
            style: TextStyle(fontSize: 17),
          ),
        ),
        SizedBox(width: 30),
        Expanded(
          child: Tooltip(
            message: 'inserisci il tuo cognome',
            child: TextFormField(
              initialValue: initialValue,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                helperText: ' ',
                contentPadding: EdgeInsets.all(6.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Per favore inserisci il tuo cognome';
                }
              },
              onSaved: (String value) {
                _formData['lastName'] = value;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailLabelAndTextField(String initialValue) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Text(
            'Tua email',
            style: TextStyle(fontSize: 17),
          ),
        ),
        SizedBox(width: 30),
        Expanded(
          child: Tooltip(
            message: 'inserisci la tua email, dove invieremo la ricevuta pec',
            child: TextFormField(
              initialValue: initialValue,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                helperText: ' ',
                contentPadding: EdgeInsets.all(6.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (String value) {
                if (value.isEmpty ||
                    !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                        .hasMatch(value)) {
                  return 'Inserisci una email valida';
                }
              },
              onSaved: (String value) {
                _formData['email'] = value;
              },
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    final SenderData _senderData = SenderData(
        name: _formData['firstName'],
        surname: _formData['lastName'],
        email: _formData['email']);

    _saveFormDataToPrefs(_senderData);

    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => SetupPage()));
  }

  void _saveFormDataToPrefs(SenderData senderData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', senderData.name);
    prefs.setString('lastName', senderData.surname);
    prefs.setString('email', senderData.email);
  }

  Future<SenderData> _readFormDataFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    SenderData _senderData = SenderData(
        name: prefs.getString('firstName'),
        surname: prefs.getString('lastName'),
        email: prefs.getString('email'));

    return _senderData;
  }
}
