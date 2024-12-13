import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vtext/views/otpView/otp_send_view.dart';

import '../my_colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _speechWords = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    initializeSpeech();
    super.initState();
  }

  // Function to send a message to the SMS app
  Future<void> sendStopMessage() async {
    const phoneNumber = '21213';
    const message = 'STOP txtvc';

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message}, // pre-fill message
    );

    // Check if the URL can be launched (i.e., if SMS is available)
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri); // Opens SMS app with pre-filled message
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch SMS')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: MyColors.primaryColor,
        foregroundColor: MyColors.whiteColor,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                  onPressed: () async {
                    await showPopover(
                        context: context,
                        bodyBuilder: (context) => Column(
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      await sendStopMessage();
                                      await Future.delayed(
                                          const Duration(seconds: 6));
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return OtpSendView();
                                      }));
                                    },
                                    child: const Text(
                                      "Unsubscribe",
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            ),
                        width: 120,
                        height: 50,
                        backgroundColor: MyColors.blackColor,
                        direction: PopoverDirection.bottom);
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: MyColors.whiteColor,
                  ));
            },
          )
        ],
        title: _speechToText.isNotListening && _confidenceLevel > 0
            ? Text(
                "Confidence:${(_confidenceLevel * 100).toStringAsFixed(1)}% ",
                style: const TextStyle(fontWeight: FontWeight.bold))
            : const Text(
                "Confidence: 0%",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              _speechToText.isListening
                  ? "Listening..."
                  : _speechEnabled
                      ? "Tap the microphone button.."
                      : "Speech Not Available!",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 30,
            ),
            SelectableText(
              _speechWords,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 80,
        width: 80,
        margin: const EdgeInsets.only(bottom: 25),
        child: AvatarGlow(
          animate: _speechToText.isListening,
          glowColor: MyColors.primaryColor,
          duration: const Duration(milliseconds: 1000),
          repeat: true,
          child: FloatingActionButton(
            backgroundColor: MyColors.primaryColor,
            foregroundColor: MyColors.whiteColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            onPressed:
                _speechToText.isListening ? _stopListening : _startListening,
            child: Icon(
              _speechToText.isListening ? Icons.mic : Icons.mic_off,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }

  void initializeSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void onSpeechResult(result) {
    setState(() {
      _speechWords = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }
}
