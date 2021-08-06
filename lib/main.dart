import 'package:custom_barber_shop/state/state_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/all.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldStater,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/my_bg.png'),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton.icon(
                onPressed: () => processLogin(context),
                icon: Icon(Icons.phone, color: Colors.white,),
                label: Text('LOGIN CON NUMERO', style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black)
                ),
              )
            )
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  processLogin(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    if(user == null){
      FirebaseAuthUi.instance()
          .launchAuth([
            AuthProvider.phone()
      ]).then((firebaseUser){
          //refresh state
        context.read(userLogged).state = FirebaseAuth.instance.currentUser;
        ScaffoldMessenger.of(scaffoldState.currentContext).showSnackBar
          (SnackBar(content: Text('Login avvenuto con successo ${FirebaseAuth.instance.currentUser.phoneNumber}')));
      }).catchError((ex){
        if(ex is PlatformException){
          if(ex.code == FirebaseAuthUi.kUserCancelledError){
            ScaffoldMessenger.of(scaffoldState.currentContext).showSnackBar
              (SnackBar(content: Text('${ex.message}')));
          }else{
            ScaffoldMessenger.of(scaffoldState.currentContext).showSnackBar
              (SnackBar(content: Text('Errore sconosciuto}')));
          }
        }
      });
    }else{

    }
  }
}
