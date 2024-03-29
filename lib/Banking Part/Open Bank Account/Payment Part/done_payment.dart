import 'dart:async';

import 'package:agro_plus_app/General%20Part/home_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonePaymentScreen extends StatefulWidget {
  final String id;
  const DonePaymentScreen({super.key, required this.id});

  @override
  State<DonePaymentScreen> createState() => _DonePaymentScreenState();
}

class _DonePaymentScreenState extends State<DonePaymentScreen> {
  int countdown = 3; // Initial countdown value
  late Timer timer;
  late ConfettiController _controller;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startCountdown();
    _controller = ConfettiController(duration: const Duration(seconds: 5));
    _controller.play();
    player.play(AssetSource('congratSound.mp3'));
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          // When the countdown reaches 0, navigate to the next screen
          timer.cancel();

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomepageScreen(matric: widget.id),
              ),
              (route) => false);
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Color.fromARGB(255, 229, 48, 48),
                  Color.fromARGB(255, 127, 18, 18)
                ])),
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(100)
                        //more than 50% of width makes circle
                        ),
                    child: Icon(
                      Icons.done,
                      color: const Color.fromARGB(255, 134, 27, 27),
                      size: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Your account is activated successfully!",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 80),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        timer
                            .cancel(); // Cancel the timer when the button is pressed
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomepageScreen(matric: widget.id),
                            ));
                      },
                      child: Text(
                        "NEXT",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Redirect you to home page after $countdown seconds", // Display the countdown
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ConfettiWidget(
                  confettiController: _controller,
                  blastDirectionality: BlastDirectionality.explosive,
                  colors: [
                    const Color.fromARGB(255, 255, 230, 2),
                    Color.fromARGB(255, 248, 209, 255),
                    Color.fromARGB(255, 255, 212, 103),
                    Color.fromARGB(255, 151, 246, 243),
                    Color.fromARGB(255, 184, 255, 193)
                  ],
                  // colors: [
                  //   Colors.yellow,
                  //   Colors.pink,
                  //   Colors.orange,
                  //   Colors.purple,
                  //   Color.fromARGB(255, 138, 27, 27)
                  // ],
                  shouldLoop: false,
                  numberOfParticles: 20,
                  gravity: 0.3,
                  emissionFrequency: 0.03,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
