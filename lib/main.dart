import 'package:board_game_manager/views/add_jogador_page.dart';
import 'package:board_game_manager/views/estatisticas_page.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  }

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
      onTap: _onTap,
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
        return MaterialPageRoute(builder: (context) => const EstatisticaPage());
      default:
        return MaterialPageRoute(
            builder: (context) => const Inicio(title: 'Board Game Manager'));
    }
  }
}
