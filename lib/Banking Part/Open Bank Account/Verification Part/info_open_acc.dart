import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/info_steps.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class OpenAccInfoScreen extends StatefulWidget {
  final String id;
  const OpenAccInfoScreen({super.key, required this.id});

  @override
  State<OpenAccInfoScreen> createState() => _OpenAccInfoScreenState();
}

class _OpenAccInfoScreenState extends State<OpenAccInfoScreen> {
  bool isCheckboxChecked = false;

  void _launchURLToPDF() async {
    const pdfUrl =
        'https://www.agrobank.com.my/wp-content/uploads/2020/12/2-Web-Update-Content-TERMS-AND-CONDITIONS-FOR-DEPOSIT-ACCOUNT.pdf'; // Replace with your PDF URL
    if (await canLaunch(pdfUrl)) {
      await launch(pdfUrl);
    } else {
      throw 'Could not launch $pdfUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Color.fromARGB(255, 229, 48, 48),
                  Color.fromARGB(255, 127, 18, 18)
                ])),
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 15),
                    child: const Center(
                      child: Text(
                        "Before we start, you should know:",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromARGB(255, 70, 70, 70)
                                  .withOpacity(0.5))),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: const Text(
                                  "What you need to be eligible for",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: const Text(
                                  "1. Must be a individual Malaysian Citizen",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: const Text(
                                  "2. Age 18 years and above",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: const Text(
                                  "3. Owned a Malaysia-registered mobile phone number and email",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              // Container(
                              //   margin: const EdgeInsets.only(bottom: 15),
                              //   child: const Text(
                              //     "4. Non-Citizen/Non-Resident/Permanent Resident (other than MyKad holder) is not allowed to apply via the online application",
                              //     style: TextStyle(
                              //       color: Color.fromARGB(255, 0, 0, 0),
                              //       fontSize: 16,
                              //     ),
                              //   ),
                              // ),
                              Divider(color: Colors.black.withOpacity(0.5)),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                child: const Text(
                                  "Type of account offered",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  children: [
                                    Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: const Icon(
                                          Icons.account_balance_rounded,
                                          size: 30,
                                        )),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Saving account",
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "with minimum deposit of RM20.00",
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Divider(color: Colors.black.withOpacity(0.5)),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                child: const Text(
                                  "What you need to provide",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Identification Card (MyKad)",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "We need to verify your identity.",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Selfie",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "We need to ensure you are not a bot.",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ... (existing code)

                        Row(
                          children: [
                            Checkbox(
                              fillColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (!states.contains(MaterialState.selected)) {
                                  return Color.fromARGB(255, 255, 255, 255);
                                }
                                return null;
                              }),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 2),
                              checkColor: Color.fromARGB(
                                  255, 153, 31, 31), // color of tick Mark
                              activeColor: Color.fromARGB(255, 255, 204, 0),
                              value: isCheckboxChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isCheckboxChecked = value ?? false;
                                });
                              },
                            ),
                            Row(
                              children: [
                                const Text(
                                  "I agree to the ",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _launchURLToPDF();
                                  },
                                  child: const Text(
                                    "Terms and Conditions",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          Color.fromARGB(255, 255, 239, 168),
                                      color: Color.fromARGB(255, 255, 239, 168),
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: isCheckboxChecked
                              ? () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          StepsInfoScreen(id: id),
                                    ),
                                  );
                                }
                              : null,
                          child: const Text(
                            "Next",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
