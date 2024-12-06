import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'my_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors.primaryColor,
        foregroundColor: MyColors.whiteColor,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.more_vert),
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
