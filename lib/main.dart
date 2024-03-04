import 'package:board_game_manager/basicas/jogador.dart';
import 'package:board_game_manager/core/board_game_manager.dart';
import 'package:board_game_manager/views/add_campeonato_page.dart';
import 'package:board_game_manager/views/add_jogador_page.dart';
import 'package:board_game_manager/views/inicio.dart';
import 'package:board_game_manager/views/rodada_page.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'QEbL84fLH0t0ux8eJFPTHKpclc8NT13qsiwVKlhD';
  const keyClientKey = 'M2livvDinvNKlcjwvCdXZXlSu7OthmQy4ZHt7jMB';
  const keyParseServerUrl = 'https://parseapi.back4app.com/parse';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // initialRoute: '/',
      // routes: {
      //   '/campeonato': (context) => AddCampeonatoPage(),
      //   '/rodada': (context) => RodadaPage(),
      // },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedBottomBarItem = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: generateRoute,
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    ));
    // return Scaffold(
    //   appBar: AppBar(
    //     // TRY THIS: Try changing the color here to a specific color (to
    //     // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
    //     // change color while the other colors stay the same.
    //     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     title: Text(widget.title),
    //   ),
    //   bottomNavigationBar: buildBottomNavigationBar(),
    //   body: Center(
    //     // Center is a layout widget. It takes a single child and positions it
    //     // in the middle of the parent.
    //     child: Column(
    //       // Column is also a layout widget. It takes a list of children and
    //       // arranges them vertically. By default, it sizes itself to fit its
    //       // children horizontally, and tries to be as tall as its parent.
    //       //
    //       // Column has various properties to control how it sizes itself and
    //       // how it positions its children. Here we use mainAxisAlignment to
    //       // center the children vertically; the main axis here is the vertical
    //       // axis because Columns are vertical (the cross axis would be
    //       // horizontal).
    //       //
    //       // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
    //       // action in the IDE, or press "p" in the console), to see the
    //       // wireframe for each widget.
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Padding(
    //           padding: EdgeInsets.only(top: 10.0),
    //           child: Text(
    //             'Campeonatos',
    //             style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    //           ),
    //         ),
    //         buildListaCampeonatos(),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () => {
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context) => AddCampeonatoPage()))
    //     },
    //     tooltip: 'Novo Campeonato',
    //     child: const Icon(Icons.add),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }

  // Future<List<ParseObject>> getCampeonatos() async {
  //   QueryBuilder<ParseObject> queryBuilder =
  //       QueryBuilder<ParseObject>(ParseObject('Campeonato'));
  //   final ParseResponse apiResponse = await queryBuilder.query();

  //   if (apiResponse.success && apiResponse.results != null) {
  //     return apiResponse.results as List<ParseObject>;
  //   } else {
  //     return [];
  //   }
  // }

  // Widget buildListaCampeonatos() {
  //   return Expanded(
  //       child: FutureBuilder<List<ParseObject>>(
  //     future: getCampeonatos(),
  //     builder: (context, snapshot) {
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.none:
  //         case ConnectionState.waiting:
  //           return Center(
  //             child: Container(
  //               width: 100,
  //               height: 100,
  //               child: CircularProgressIndicator(),
  //             ),
  //           );
  //         default:
  //           if (snapshot.hasError) {
  //             return const Center(
  //               child: Text('Error...'),
  //             );
  //           }

  //           if (!snapshot.hasData) {
  //             return const Center(
  //               child: Text("Sem Campeonatos"),
  //             );
  //           }

  //           return ListView.builder(
  //             padding: const EdgeInsets.only(top: 10.0),
  //             itemCount: snapshot.data!.length,
  //             itemBuilder: (context, index) {
  //               final varCampeonato = snapshot.data![index];
  //               final varNome = varCampeonato.get<String>('nome')!;
  //               final varQtdJogadores = varCampeonato.get<int>('qtdJogadores')!;

  //               return ListTile(
  //                 title: Text(varNome),
  //                 subtitle: Text('Jogadores: $varQtdJogadores'),
  //               );
  //             },
  //           );
  //       }
  //     },
  //   ));
  // }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedBottomBarItem = index;
  //   });
  // }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.verified_user), label: 'Jogador'),
        BottomNavigationBarItem(icon: Icon(Icons.refresh), label: 'Rodada'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_chart), label: 'Estatistica'),
      ],
      currentIndex: _selectedBottomBarItem,
      selectedItemColor: Colors.indigo,
      onTap: _onTap //(value) {
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => const RodadaPage()));
      // _onItemTapped(value);
      //}
      ,
    );
  }

  void _onTap(int index) {
    switch (index) {
      case 0:
        _navigatorKey.currentState
            ?.pushNamedAndRemoveUntil("Inicio", (route) => false);
        break;
      case 1:
        _navigatorKey.currentState
            ?.pushNamedAndRemoveUntil("Jogador", (route) => false);
        break;
      case 2:
        _navigatorKey.currentState
            ?.pushNamedAndRemoveUntil("Rodada", (route) => false);
        break;
      case 3:
        _navigatorKey.currentState
            ?.pushNamedAndRemoveUntil("Estatistica", (route) => false);
        break;
      default:
    }

    setState(() {
      _selectedBottomBarItem = index;
    });
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "Inicio":
        return MaterialPageRoute(
            builder: (context) => const Inicio(title: 'Board Game Manager'));
      case "Jogador":
        return MaterialPageRoute(
          builder: (context) => const AddJogadorPage(title: "Jogadores"),
        );
      case "Rodada":
        return MaterialPageRoute(builder: (context) => const RodadaPage());
      case "Estatistica":
        return MaterialPageRoute(builder: (context) => const RodadaPage());
      default:
        return MaterialPageRoute(
            builder: (context) => const Inicio(title: 'Board Game Manager'));
    }
  }
}
