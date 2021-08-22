import 'package:custom_barber_shop/screens/home_screen.dart';
import 'package:custom_barber_shop/state/state_management.dart';
import 'package:custom_barber_shop/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:page_transition/page_transition.dart';

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
      onGenerateRoute: (settings){
        switch(settings.name){
          case '/home':
            return PageTransition(
                settings: settings,
                child: HomePage(),
                type: PageTransitionType.fade);
                break;
          default: return null;
        }
      },
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
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends ConsumerWidget {

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();


  //called when we login (not every time we open the app)
  processLogin(BuildContext context) async{
    var user = FirebaseAuth.instance.currentUser;
    if(user == null){
      FirebaseAuthUi.instance()
          .launchAuth([
            AuthProvider.phone()
      ]).then((firebaseUser) async {
          //refresh state
        context.read(userLogged).state = FirebaseAuth.instance.currentUser;
        //start new screen
        await checkLoginState(context, true);

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

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      key: scaffoldState,
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
                child: FutureBuilder(
                  future: checkLoginState(context, false),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    else{
                      var userState = snapshot.data as LOGIN_STATE;
                      if(userState == LOGIN_STATE.LOGGED){
                        return Container();
                      }else{ //if not logged
                        return ElevatedButton.icon(
                          onPressed: ()=> processLogin(context),
                          icon: Icon(Icons.phone, color:Colors.white),
                          label: Text('LOGIN CON TELEFONO', style: TextStyle(color: Colors.white),),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                        );
                      }
                    }

                  }

                )
            )
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //called every start of application
  Future<LOGIN_STATE> checkLoginState(BuildContext context, bool fromLogin) async{
    await Future.delayed(Duration(seconds: fromLogin == true? 0 : 3))
        .then((value) => {
      FirebaseAuth.instance.currentUser
          .getIdToken()
          .then((token){
            //if the token is true, we get it and print it
            print('$token');
            context.read(userToken).state = token;
            //if we got here, we are already logged, we shot the hjome screen
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      })
    });

    return FirebaseAuth.instance.currentUser != null ? LOGIN_STATE.LOGGED : LOGIN_STATE.NOT_LOGGED;
  }
}
