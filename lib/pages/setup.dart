import 'package:flutter/material.dart';

import './../widgets/custom_drawer.dart';

import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import 'package:racco_mail/models/sender_data.dart';
import 'package:racco_mail/models/email_data.dart';

import 'dart:io';
import 'package:path/path.dart' as path;

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() {
    return _SetupPageState();
  }
}

class _SetupPageState extends State<SetupPage> {
  SenderData _senderData = SenderData(name: '', surname: '', email: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, String> _formData = {
    'emailSubject': null,
    'receiverEmail': null,
    'emailMessage': null,
  };
  Map<String, String> _filePaths = Map<String, String>();
  bool _acceptPrivacy = false;
  bool _verifyCaptcha = false;
  bool _showPrivacyError = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: SizedBox(
              height: 38,
              child: Image.asset('images/logo-raccomail-esteso.png')),
          backgroundColor: Color.fromRGBO(30, 52, 70, 1),
        ),
        body: WillPopScope(
          onWillPop: () {
            Navigator.pop(context, true);
            return Future.value(true);
          },
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: _readFormDataFromPrefs(),
              builder:
                  (BuildContext context, AsyncSnapshot<SenderData> snapshot) {
                if (snapshot.data?.name != null ||
                    snapshot.data?.surname != null ||
                    snapshot.data?.email != null) {
                  _senderData = snapshot.data;
                }
                return Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _isEmptySenderData()
                            ? _buildSettingsErrorMessage()
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 18.0, bottom: 17.0, left: 30.0, right: 30.0),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                _buildFirstNameLabelAndTextField(
                                    _senderData.name ?? ''),
                                SizedBox(height: 20),
                                _buildLastNameLabelAndTextField(
                                    _senderData.surname ?? ''),
                                SizedBox(height: 20),
                                _buildEmailLabelAndTextField(
                                    _senderData.email ?? ''),
                              ],
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Container(
                            color: Color.fromRGBO(227, 237, 237, 1),
                            height: 360,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _buildSubjectLabelAndTextField(),
                                  SizedBox(height: 5),
                                  _buildReceiverEmailLabelAndTextField(),
                                  SizedBox(height: 5),
                                  Text('Messaggio:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0)),
                                  SizedBox(height: 15),
                                  _buildMessageTextField(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Builder(
                                builder: (BuildContext context) =>
                                    _filePaths != null
                                        ? _buildAttachmentsListView()
                                        : Container(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: FlatButton(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 30.0),
                                  color: Color.fromRGBO(30, 52, 70, 1),
                                  child: Text('AGGIUNGI ALLEGATO',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    _openBottomSheet(context);
                                  },
                                ),
                              ),
                              Container(
                                width: 230,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _buildPrivacyLabelAndCheckbox(),
                                    _showPrivacyError
                                        ? Container()
                                        : Container(
                                            child: Text(
                                              'Devi accettare la privacy',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 13),
                                              textAlign: TextAlign.left,
                                            ),
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                          ),
                                    _buildCaptchaLabelAndCheckbox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 30.0, bottom: 30),
                          child: SizedBox(
                            width: double.infinity,
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              color: Color.fromRGBO(225, 28, 60, 1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Invia la tua PEC Mail',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  SizedBox(width: 10),
                                  Image.asset(
                                    'images/send-mail.png',
                                    color: Colors.white,
                                    scale: 17,
                                  )
                                ],
                              ),
                              onPressed: _submitForm,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }

/* ------------------- These below are just the build function which will build the UI using different widgets ------------------- */

  Widget _buildFirstNameLabelAndTextField(String name) {
    return Row(
      children: <Widget>[
        Text(
          'Nome',
          style: TextStyle(fontSize: 17, color: Colors.black26),
        ),
        SizedBox(width: 57.6),
        Expanded(
          child: TextFormField(
            enabled: false,
            cursorColor: Colors.black,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: name,
              contentPadding: EdgeInsets.all(6.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastNameLabelAndTextField(String lastName) {
    return Row(
      children: <Widget>[
        Text(
          'Cognome',
          style: TextStyle(fontSize: 17, color: Colors.black26),
        ),
        SizedBox(width: 30),
        Expanded(
          child: TextFormField(
            enabled: false,
            cursorColor: Colors.black,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: lastName,
              contentPadding: EdgeInsets.all(6.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailLabelAndTextField(String email) {
    return Row(
      children: <Widget>[
        Text(
          'Tua email',
          style: TextStyle(fontSize: 17, color: Colors.black26),
        ),
        SizedBox(width: 30),
        Expanded(
          child: TextFormField(
            enabled: false,
            cursorColor: Colors.black,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: email,
              contentPadding: EdgeInsets.all(6.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectLabelAndTextField() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Text(
            'Oggetto:',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 30),
        Expanded(
          child: Tooltip(
            message: 'Inserisci oggetto',
            child: TextFormField(
              textAlign: TextAlign.center,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                helperText: ' ',
                hintText: 'Inserisci oggetto',
                contentPadding: EdgeInsets.all(6.0),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Inserisci l\'oggetto della email';
                }
              },
              onSaved: (String value) {
                _formData['emailSubject'] = value;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiverEmailLabelAndTextField() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Text(
            'PEC Email:',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 13),
        Expanded(
          child: Tooltip(
            message: 'Inserisci PEC destinatario',
            child: TextFormField(
              textAlign: TextAlign.center,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                helperText: ' ',
                hintText: 'Inserisci PEC destinatario',
                contentPadding: EdgeInsets.all(6.0),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
              onSaved: (String value) {
                _formData['receiverEmail'] = value;
              },
              keyboardType: TextInputType.emailAddress,
              validator: (String value) {
                if (value.isEmpty ||
                    !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                        .hasMatch(value)) {
                  return 'Inserisci PEC Email';
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:
          _filePaths != null && _filePaths.isNotEmpty ? _filePaths.length : 0,
      itemBuilder: (BuildContext context, int index) {
        final String filePath = _filePaths.values.toList()[index].toString();
        return Row(
          children: <Widget>[
            Text(
              'Allegato ${index + 1}: ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            InkWell(
              child: Text(
                _filePaths.keys.toList()[index],
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                OpenFile.open(filePath);
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildMessageTextField() {
    return Expanded(
      child: Tooltip(
        message: 'Inserisci testo',
        child: TextFormField(
          cursorColor: Colors.black,
          keyboardType: TextInputType.multiline,
          maxLines: 7,
          decoration: InputDecoration(
            hintText: 'Inserisci testo',
            contentPadding: EdgeInsets.all(6.0),
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Inserisci il messaggio';
            }
          },
          onSaved: (String value) {
            _formData['emailMessage'] = value;
          },
        ),
      ),
    );
  }

  Widget _buildCaptchaLabelAndCheckbox() {
    return Container(
      height: 70,
      width: 210,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: ExactAssetImage(
              'images/recaptcha.png',
              scale: 19,
            ),
            alignment: Alignment.centerRight),
        color: Color.fromRGBO(240, 242, 246, 1),
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Checkbox(
            value: _verifyCaptcha,
            onChanged: _verifyCaptchaCheckBox,
            activeColor: Color.fromRGBO(30, 52, 70, 1),
          ),
          Text('I\'m not a robot', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildPrivacyLabelAndCheckbox() {
    return Row(
      children: <Widget>[
        Text('Accetta ', style: TextStyle(fontSize: 16)),
        InkWell(
          child: Text('privacy',
              style: TextStyle(
                  fontSize: 16, decoration: TextDecoration.underline)),
          onTap: () {
            Navigator.pushNamed(context, '/Privacy');
          },
        ),
        Checkbox(
          value: _acceptPrivacy,
          onChanged: _privacyCheckBoxValueDone,
          activeColor: Color.fromRGBO(30, 52, 70, 1),
        ),
      ],
    );
  }

  Widget _buildSettingsErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Text(
              'Per iniziare imposta i tuoi dati CLICCA QUI',
              softWrap: true,
              style: TextStyle(
                  color: Color.fromRGBO(163, 53, 71, 1), fontSize: 15),
            ),
            onTap: () => Navigator.pushNamed(context, '/Settings'),
          ),
        ],
      ),
    );
  }

/*---------------------------------------------------------------------------------------------------------------------------------------------------------*/

// This function will be called when user clicks on add attachments and it will show choice between photo camera and file explorer.
  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            runAlignment: WrapAlignment.spaceEvenly,
            children: <Widget>[
              ListTile(
                title: Text('Fotocamera'),
                leading: Icon(Icons.camera_alt),
                onTap: _openPhotoCamera,
              ),
              ListTile(
                title: Text('File'),
                leading: Icon(Icons.folder_open),
                onTap: _openFileExplorer,
              )
            ],
          );
        });
  }

// This function will open the file explorer to select files which the user wants to attach with the email.
  void _openFileExplorer() async {
    Map<String, String> filesInfo = await FilePicker.getMultiFilePath();

    setState(() {
      _filePaths.addAll(filesInfo);
    });

    int filesSize = 0;

    _filePaths.forEach((key, value) =>
        filesSize += _convertBytesToKb(File(value.toString()).lengthSync()));

    if (!mounted) return;

    setState(() {
      if (filesSize >= 20000) {
        _showSnackBar('Limite dimensioni superato. Limite: 20Mb');
        _filePaths.removeWhere((key, value) => true);
      }

      //Here I filtered out the files which the server does not accept.
      _filePaths.removeWhere((key, value) {
        bool flag = !key.contains('.pdf') &&
            !key.contains('.txt') &&
            !key.contains('.doc') &&
            !key.contains('.docx') &&
            !key.contains('.rtf') &&
            !key.contains('.jpg') &&
            !key.contains('.jpeg') &&
            !key.contains('.png');
        if (flag) {
          _showSnackBar('scegli solo documenti e immagini validi');
        }
        return flag;
      });
    });

    print(_filePaths);
  }

// This function will open the photo camera of the mobile to capture and save photos that will be taken from the camera.
  void _openPhotoCamera() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    Map<String, String> imageInfo = {
      path.basename(imageFile.path): imageFile.path
    };

    setState(() {
      _filePaths.addAll(imageInfo);
    });

    int filesSize = 0;

    // Here I converted the bytes to kilobytes
    _filePaths.forEach((key, value) =>
        filesSize += _convertBytesToKb(File(value.toString()).lengthSync()));

    setState(() {
      if (filesSize >= 20000) {
        _showSnackBar('Limite dimensioni superato. Limite: 20Mb');
        _filePaths.removeWhere((key, value) => true);
      }
    });
  }

// This function will be called when the privacy checkbox is pressed.
  void _privacyCheckBoxValueDone(bool value) {
    setState(() {
      _acceptPrivacy = value;
    });
  }

// This function will be called when the captcha checkbox is pressed.
  void _verifyCaptchaCheckBox(bool value) {
    setState(() {
      _verifyCaptcha = value;
    });
  }

// This function is used to create a snackbar wherever required with the given message as parameter of the function.
  void _showSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

/* 
    This function will be called when user click the send email button.
    It will first verify that the form is validated and all the checks are correct then
    it will send the post request.
*/
  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (_acceptPrivacy == false) {
      setState(() {
        _showPrivacyError = false;
      });
      return;
    }

    if (_acceptPrivacy == true) {
      setState(() {
       _showPrivacyError = true; 
      });
    }
    
    if (_verifyCaptcha == false) {
      final snackbar = SnackBar(
        content: Text('per favore risolvi il captcha'),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
      return;
    }

    _formKey.currentState.save();

    final EmailData _emailData = EmailData(
      subject: _formData['emailSubject'],
      receiverEmail: _formData['receiverEmail'],
      emailBody: _formData['emailMessage'],
      acceptPrivacy: _acceptPrivacy,
      attachments: _filePaths,
    );

    // For Debugging Purpose
    print(_senderData.name);
    print(_senderData.surname);
    print(_senderData.email);
    print(_emailData.subject);
    print(_emailData.receiverEmail);
    print(_emailData.emailBody);
    print(_emailData.attachments);
    print(_emailData.acceptPrivacy);

    _sendDataToServer(_senderData, _emailData);

    _formKey.currentState.reset();
    setState(() {
      _filePaths.clear();
      _acceptPrivacy = false;
      _verifyCaptcha = false;
    });
  }

// This is just a utility function to show the progress of documents uploading to the server in the console for debugging the process.
  void _showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  ///This function will send the post request to the server and post the given data asynchronously
  ///Here I used a dart package called [Dio] to send the form data and documents to the server

  void _sendDataToServer(
      final SenderData senderData, final EmailData emailData) async {
    final dio = Dio();
    dio.options.baseUrl = 'https://www.raccomail.it';
    dio.interceptors.add(LogInterceptor(requestBody: true));

    List<UploadFileInfo> uploadFilesInfo = List<UploadFileInfo>();

    for (var index = 0; index < _filePaths.length; ++index) {
      uploadFilesInfo.add(UploadFileInfo(
          File(_filePaths.values.toList()[index].toString()),
          _filePaths.keys.toList()[index]));
    }

    FormData formData = FormData.from({
      "form[nome]": senderData.name,
      "form[cognome]": senderData.surname,
      "form[mail]": senderData.email,
      "form[valida_mail]": senderData.email,
      "form[oggetto]": emailData.subject,
      "form[mail_pec]": emailData.receiverEmail,
      "form[messaggio]": emailData.emailBody,
      "form[documento]": uploadFilesInfo,
      "form[accetto_privace][]": emailData.acceptPrivacy,
      "form[formId]": 10,
    });

    Response response;

    response = await dio.post(
        // '/_new/manager/index.php?controller=omniRSform&task=sendEmail&token=70e723e37e1f6f0f3d2e3cea25351845', // old api link
        '/manager.php?controller=omniRSform&task=sendEmail&token=70e723e37e1f6f0f3d2e3cea25351845',
        data: formData,
        onSendProgress: _showDownloadProgress);

    if (!response.data.toString().contains('error')) {
      _showSnackBar('Email inviata correttamente');
    } else {
      _showSnackBar('Errore durante l\'invio di e-mail');
    }
    
    print(response.data.toString());
  }

  /// This is a utility function which converts the given bytes into kilobytes;
  int _convertBytesToKb(int bytes) {
    return (bytes / 1000).ceil();
  }

  /// This is just a utility function which checks whether the [SenderData] model has data or not.
  bool _isEmptySenderData() {
    return _senderData.name.isEmpty ||
        _senderData.surname.isEmpty ||
        _senderData.email.isEmpty;
  }

  /// This function will read the data from shared preferences asynchronously and returns a future with the data stored in [SenderData] model.
  Future<SenderData> _readFormDataFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    SenderData _senderData = SenderData(
        name: prefs.getString('firstName'),
        surname: prefs.getString('lastName'),
        email: prefs.getString('email'));
    return _senderData;
  }
}
