import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'client.dart';

//================== App Bar Widget =======================
AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.black,
    title: const Text(
      "Universal Clipboard",
      style: TextStyle(
          fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.bold),
    ),
    automaticallyImplyLeading: false,
    centerTitle: true,
  );
}
//================== App Bar Widget =======================

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ========================== All Variables ==============================
  bool signinstate = false;
  bool signupstate = false;
  final username = TextEditingController();
  final password = TextEditingController();
  // ========================== End Variables ==============================
  // ========================== All Function ===============================
  // ignore: non_constant_identifier_names
  void SignIn() {
    setState(() {
      signupstate = signupstate ? false: false;
      signinstate = true;
    });
  }
  // ignore: non_constant_identifier_names
  void SignUp() {
    setState(() {
      signinstate = signinstate ? false: false;
      signupstate = true;
    });
  }

  // ========================== End Function ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
  // ========================== All Widgets ==============================
  Widget _buildBody() {
    Widget cardWidget = Container();
    if (signinstate) {
      cardWidget = _buildSignInCard();
    }
    else if (signupstate) {
      cardWidget = _buildSignUpCard();
    }
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Credentials',
            style: TextStyle(
                color: Colors.lightGreenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 28),
          ),
          // _buildAppDetail(),
          const Text(
            'Have an account "Sign in" else "Sign up"',
            style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.w300,
                fontSize: 17),
          ),
          _buildSignAction(),
          cardWidget
        ],
      ),
    );
  }

  // Widget _buildAppDetail(){
  //   return FutureBuilder (
  //       future: Fetch().appDetails(),
  //       builder: (BuildContext context, AsyncSnapshot snapshot){
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.done:return Text(snapshot.data.version);break;
  //           case ConnectionState.waiting:return Text('Connecting to Server');break;
  //           default:return Container();
  //         }
  //       }
  //   );
  // }

  Widget _buildSignAction() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      // ignore: deprecated_member_use
      RaisedButton(
        child: const Text(
          'Sign Up',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
        ),
        color: Colors.black26,
        onPressed: () async {
          SignUp();
          if (username.text != '' || password.text == '') {
            username.text = '';
            password.text = '';
          }
          },
      ),
      // ignore: deprecated_member_use
      RaisedButton(
        child: const Text(
          'Sign In',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        color: Colors.black26,
        onPressed: () async {
          SignIn();
          final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          var savedPassword = await sharedPreferences.getString('password');
          var savedUsername = await sharedPreferences.getString('username');
          if (savedUsername != "" || savedPassword != "") {
            username.text = savedUsername.toString();
            password.text = savedPassword.toString();
          }
        },
      )
    ]);
  }

  Widget _buildSignInCard() {
    return Column(
      children: [
        Card(
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.only(left: 16, right: 16),child: _textFormFieldUser(),),
              Padding(padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),child: _textFormFieldPassword(),)
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 10,
        ),
        _floatingActionButton("Sign In")
      ],
    );
  }
  Widget _buildSignUpCard() {
    return Column(
      children: [
        Card(
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.only(left: 16, right: 16),child: _textFormFieldUser(),),
              Padding(padding: const EdgeInsets.only(left: 16, right: 16),child: _textFormFieldPassword(),),
              // Padding(padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),child: _textFormFieldPassword("Retype Password", "Rewrite MongoDB Atlas Password"),)
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          borderOnForeground: true,
        ),
        _floatingActionButton("Sign Up")
      ],
    );
  }

  FloatingActionButton _floatingActionButton(action) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.black12,
      icon: const Icon(
        Icons.arrow_forward_rounded,
        color: Colors.grey,
      ),
      label: Text(
        action,
        style: const TextStyle(color: Colors.grey),
      ),
      onPressed: () async {
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        if (action == 'Sign In') {
          var givenPassword = await sharedPreferences.getString('password');
          var givenUsername = await sharedPreferences.getString('username');
          if (username.text == givenUsername && password.text == givenPassword) {
            Navigator.pushNamed(context, action);
          }
        }
        else if (action == 'Sign Up') {
          if (username.text != "" || password.text != ""){
            await sharedPreferences.setString('username', username.text);
            await sharedPreferences.setString('password', password.text);
            SignIn();
          }
          else {
          }
        }
      }
    );
  }

  // Widget build(BuildContext context) {
  //   return AlertDialog(
  //     title: Text("Empty Cells",
  //       style: Theme.of(context).textTheme.,
  //     ),
  //     actions: this.actions,
  //     content: Text(
  //       this.content,
  //       style: Theme.of(context).textTheme.body1,
  //     ),
  //   );
  // }

  Widget _textFormFieldUser(){
    return TextFormField(
      controller: username,
      decoration: const InputDecoration(
          hintText: "Username", labelText: "Type you MongoDB Atlas Username"),
    );
  }
  Widget _textFormFieldPassword(){
    return TextFormField(
      controller: password,
      decoration: const InputDecoration(
          hintText: "Password", labelText: "Type you MongoDB Atlas Username"),
    );
  }
// ========================== End Widgets ==============================
}