import 'package:dreamwithme/clients/dreamwidth.dart';
import 'package:dreamwithme/pages/friends.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  final DreamWidthClient client;
  
  const LoginPage({ Key key, this.client}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _user, _pwd; 

  final _formKey = GlobalKey<FormState>();

  void _logIn(GlobalKey<FormState> formKey) {
   if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.client.login(_user, _pwd).then((isLogged) {
        if (isLogged) {
          Navigator.of(context).pushReplacementNamed(FriendsPage.tag);
        }
      });
    }  
  }

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('images/dreamwithme.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email or user name',
        filled: true,
        fillColor: Colors.white,
        errorStyle: TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'User identifier cannot be empty';
        }
      },
      onSaved: (value) => _user = value,
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        filled: true,
        fillColor: Colors.white,
        errorStyle: TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      onFieldSubmitted: (_) {
        this._logIn(_formKey);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Password cannot be empty';
        }
      },
      onSaved: (value) => _pwd = value,
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () => this._logIn(_formKey),
        padding: EdgeInsets.all(12),
        color: Colors.black,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton
            ],
          ),
        )
      ),
    );
  }
}
