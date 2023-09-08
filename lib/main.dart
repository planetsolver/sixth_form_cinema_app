import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sixth_form_cinema_app/adminAccount.dart';
import 'package:sixth_form_cinema_app/basket.dart';
import 'package:sixth_form_cinema_app/theatre.dart';
import 'package:sixth_form_cinema_app/util.dart';

import 'accounts/login.dart';
import 'firebase_options.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (false) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  late ScreenSize screenSize;

  List<Seat> basketSeats = [];

  void addToBasket(Seat newSeat) {
    for (Seat seat in basketSeats) {
      if ((seat.row == newSeat.row) && (seat.col == newSeat.col)) {
        return;
      }
    }
    setState(() {
      basketSeats.add(newSeat);
    });
  }

  void removeFromBasket(int row, int col) {
    for (int index = 0; index < basketSeats.length; index++) {
      if ((basketSeats[index].row == row) && (basketSeats[index].col == col)) {
        setState(() {
          basketSeats.removeAt(index);
        });
        return;
      }
    }
  }

  void clearBasket() {
    setState(() {
      basketSeats = [];
    });
  }

  late User? user;
  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Setup public variables
    if (MediaQuery.sizeOf(context).width < 250) {
      screenSize = ScreenSize.watch;
    }
    else if (MediaQuery.sizeOf(context).width < 600) {
      screenSize = ScreenSize.phone;
    } else if (MediaQuery.sizeOf(context).width < 960) {
      screenSize = ScreenSize.tabletVertical;
    } else if (MediaQuery.sizeOf(context).width < 1280) {
      screenSize = ScreenSize.tabletHorizontal;
    } else {
      screenSize = ScreenSize.desktop;
    }
    return SafeArea(
      child: MaterialApp(
        title: 'SyncList Studio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routes: {
          "/login": (context) => const LoginPage(),
          "/home": (context) => HomePage(screenSize: screenSize),
          "/theatre": (context) => TheatrePage(screenSize: screenSize, addSeatToBasket: addToBasket, basket: basketSeats, removeFromBasket: removeFromBasket),
          "/basket": (context) => BasketPage(basket: basketSeats, removeFromBasket: removeFromBasket, clearBasket: clearBasket),
          "/account": (context) => const AdminAccountPage(),
        },
        initialRoute: (user == null) ? "/login" : "/home",
      ),
    );
  }
}
