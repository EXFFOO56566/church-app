import 'package:churchapp_flutter/auth/ForgotPasswordScreen.dart';
import 'package:churchapp_flutter/auth/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateManager.dart';
import '../i18n/strings.g.dart';
import '../utils/Alerts.dart';
import '../utils/TextStyles.dart';
import 'dart:convert';
import 'dart:async';
import '../utils/my_colors.dart';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import '../models/Userdata.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:toast/toast.dart';
import 'dart:io';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['email'],
);

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  LoginScreen();

  @override
  LoginScreenRouteState createState() => new LoginScreenRouteState();
}

class LoginScreenRouteState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  static final FacebookLogin facebookSignIn = new FacebookLogin();
  GoogleSignInAccount _currentUser;

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  verifyFormAndSubmit() {
    String _email = emailController.text.trim();
    String _password = passwordController.text;

    if (_email == "" || _password == "") {
      Alerts.show(context, t.error, t.emptyfielderrorhint);
    } else if (EmailValidator.validate(_email) == false) {
      Alerts.show(context, t.error, t.invalidemailerrorhint);
    } else {
      loginUser(_email, _password, "", "");
    }
  }

  Future<void> loginUser(
      String email, String password, String name, String type) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      var data = {
        "email": email,
        "password": password,
        "name": name,
        "type": type,
      };
      final response = await http.post(Uri.parse(ApiUrl.LOGIN),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // Navigator.pop(context);
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Navigator.of(context).pop();
        print(response.body);
        Map<String, dynamic> res = json.decode(response.body);
        if (res["status"] == "error") {
          Alerts.show(context, t.error, res["message"]);
        } else {
          print(res["user"]);
          //Alerts.show(context, Strings.success, res["message"]);
          Provider.of<AppStateManager>(context, listen: false)
              .setUserData(Userdata.fromJson(res["user"]));

          Navigator.of(context).pop();
        }
        //print(res);
      }
    } catch (exception) {
      Navigator.of(context).pop();
      Alerts.show(context, t.error, exception.toString());
      // Navigator.pop(context);
      // I get no exception here
      print(exception);
    }
  }

  Future<Null> loginWithFacebook() async {
    final FacebookLoginResult result =
        await facebookSignIn.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        var graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}'));
        Map<String, dynamic> profile = json.decode(graphResponse.body);
        print(profile);
        loginUser(profile['email'], "", profile['name'], t.facebook);
        break;
      case FacebookLoginStatus.cancelledByUser:
        Toast.show('Login cancelled by the user.', context);
        break;
      case FacebookLoginStatus.error:
        Toast.show(t.facebookloginerror + ': ${result.errorMessage}', context);
        break;
    }
  }

  applesigning() async {
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.email);
          loginUser(
              result.credential.email,
              "",
              result.credential.fullName.familyName +
                  " " +
                  result.credential.fullName.givenName,
              t.facebook);
          break;
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          Alerts.show(context, t.error,
              "Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }

    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // _handleGetContact();
        print(_currentUser.email);
        loginUser(_currentUser.email, "", _currentUser.displayName, t.google);
      }
    });
    googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      //backgroundColor: Colors.white,
      appBar:
          PreferredSize(child: Container(), preferredSize: Size.fromHeight(0)),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: double.infinity,
          //height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.arrow_back,
                    ),
                  ),
                ),
              ),
              Container(
                height: 25,
              ),
              Column(
                children: [
                  Text(t.appname,
                      style: TextStyles.title(context).copyWith(
                          color: MyColors.primary,
                          fontWeight: FontWeight.bold)),
                  Container(height: 5),
                  Text(t.signintocontinue,
                      style: TextStyles.subhead(context).copyWith()),
                ],
              ),
              Container(height: 25),
              Container(height: 5),
              Container(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(t.emailaddress,
                    style: TextStyles.caption(context).copyWith()),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueGrey[400], width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueGrey[400], width: 2),
                  ),
                ),
              ),
              Container(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(t.password,
                    style: TextStyles.caption(context).copyWith()),
              ),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueGrey[400], width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueGrey[400], width: 2),
                  ),
                ),
              ),
              Container(height: 8),
              Container(
                width: double.infinity,
                child: TextButton(
                  child: Text(
                    t.forgotpassword,
                    style: TextStyle(color: MyColors.primary, fontSize: 15),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(ForgotPasswordScreen.routeName);
                  },
                ),
              ),
              Container(height: 20),
              Container(
                width: double.infinity,
                height: 40,
                child: TextButton(
                  child: Text(
                    t.signin,
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    verifyFormAndSubmit();
                  },
                ),
              ),
              Container(
                width: double.infinity,
                child: TextButton(
                  child: Text(
                    t.signinforanaccount,
                    style: TextStyle(color: MyColors.primary),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(RegisterScreen.routeName);
                  },
                ),
              ),
              Container(height: 25),
              Center(
                child: Text(
                  t.orloginwith,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Container(height: 15),
              Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      icon: Icon(
                        LineAwesomeIcons.facebook,
                        color: Colors.white,
                        size: 20,
                      ), //`Icon` to display
                      label: Text(
                        t.facebook,
                        style: TextStyle(color: Colors.white),
                      ), //`Text` to display
                      onPressed: () {
                        loginWithFacebook();
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red[400],
                      ),
                      icon: Icon(
                        LineAwesomeIcons.google_plus,
                        color: Colors.white,
                        size: 20,
                      ), //`Icon` to display
                      label: Text(
                        t.google,
                        style: TextStyle(color: Colors.white),
                      ), //`Text` to display
                      onPressed: () {
                        _handleSignIn();
                      },
                    ),
                  ),
                  Visibility(
                    visible: Platform.isIOS ? true : false,
                    child: Container(
                      width: double.infinity,
                      child: AppleSignInButton(
                        //style: ButtonStyle.white,
                        type: ButtonType.continueButton,
                        onPressed: () {
                          applesigning();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Container(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
