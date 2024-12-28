import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Splash(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.w700),
          bodyMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const CounterPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Ensures vertical centering
          crossAxisAlignment:
              CrossAxisAlignment.center, // Ensures horizontal centering
          children: [
            Image.asset('assets/splash.png', height: 300),
            const SizedBox(height: 100),
            if (Platform.isIOS)
              const CupertinoActivityIndicator(
                radius: 50,
              )
            else
              const CircularProgressIndicator(
                color: Color.fromARGB(255, 255, 0, 0),
                strokeWidth: 6,
              )
          ],
        ),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  CounterPageState createState() => CounterPageState();
}

class CounterPageState extends State<CounterPage>
    with TickerProviderStateMixin {
  int _counter = 0;
  bool _isJackpot = false;
  double _probability = 0.01;

  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _buttonScaleAnimation = Tween(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_checkJackpot()) {
        _isJackpot = true;
        _showJackpotDialog();
      } else {
        _probability = (_probability + (Random().nextDouble() * 0.04 + 0.01))
            .clamp(0.01, 0.05);
      }
    });
  }

  bool _checkJackpot() {
    double randomValue = Random().nextDouble();
    return _counter > 10 && _counter % 2 != 0 && randomValue <= _probability;
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _isJackpot = false;
      _probability = 0.01;
    });
  }

  void _showJackpotDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selamat!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color.fromARGB(255, 255, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Anda Jackpot pada angka $_counter',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _resetCounter();
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 2, 15, 37),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Counter Sumhel',
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _isJackpot
                  ? null
                  : () {
                      _incrementCounter();
                      _buttonController.forward().then((_) {
                        _buttonController.reverse();
                      });
                    },
              onTapCancel: () {
                _buttonController.reverse();
              },
              child: ScaleTransition(
                scale: _buttonScaleAnimation,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 255, 17, 0),
                    border: Border.all(color: Colors.black, width: 15),
                  ),
                  child: const Center(
                    child: Text(
                      'HIT ME!',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Current Counter: $_counter',
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                setState(() {
                  _resetCounter();
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Reset Counter',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
