import 'dart:convert';

import 'package:agro_plus_app/EC%20Part/models/cartItem.dart';
import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/cart/cart_screen.dart';
import 'package:agro_plus_app/General%20Part/home_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WinnerNotificationScreen extends StatefulWidget {
  static String routeName = '/winner_notification_screen';
  const WinnerNotificationScreen({super.key});

  @override
  State<WinnerNotificationScreen> createState() =>
      _WinnerNotificationScreenState();
}

class _WinnerNotificationScreenState extends State<WinnerNotificationScreen> {
  Map<String, dynamic> messageData = {};
  late String winnerId;
  late ConfettiController _controller;
  AudioPlayer player = AudioPlayer();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    _controller.play();
    player.play(AssetSource('congratSound.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      Map? pushArguments = arguments as Map;

      if (pushArguments != null && pushArguments.containsKey('message')) {
        setState(() {
          messageData = json.decode(pushArguments['message']);
          winnerId = messageData['recipientId'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 248, 201, 118),
              Color.fromARGB(237, 253, 146, 139),
            ],
          )),
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _controller,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        numberOfParticles: 10,
                        gravity: 0.1,
                        emissionFrequency: 0.05,
                      ),
                    ),
                    const Text(
                      'You won an auction!',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Congratulations！\n Please place the order immediately.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            '${messageData['image']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // Text(
                    //   'Order ID: ${messageData['auctionId']}',
                    //   style: const TextStyle(fontSize: 16),
                    // ),
                    const SizedBox(height: 20),
                    Text(
                      'Product: ${messageData['productName']}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Bid Amount: RM ${messageData['bidAmount']}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true; // Set loading state to true
                          });

                          final cartItem = CartItem(
                            productId: messageData['productId'],
                            productName: messageData['productName'],
                            price: double.parse(messageData['bidAmount']),
                            image: messageData['image'],
                            sellerId: messageData['sellerId'],
                            numOfItem: 1,
                          );
                          final result = await cartProvider.addToCart(cartItem);
                          setState(() {
                            isLoading =
                                false; // Set loading state to false when done
                          });
                          // ignore: use_build_context_synchronously
                          if (result == AddToCartResult.success) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CartScreen(matric: winnerId),
                              ),
                            );
                          } else if (result == AddToCartResult.alreadyInCart) {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomepageScreen(
                                          matric: winnerId,
                                        )));
                          }
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(350, 45)),
                          // Change the size as needed
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              // Adjust the radius as needed
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 197, 0, 0)),
                          // Change the color to your desired color
                        ),
                        child: const Text(
                          "Proceed to Make Payment",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
