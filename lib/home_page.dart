import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/color_pallete.dart';
import 'package:voice_assistant/openai_service.dart';
import 'package:voice_assistant/widgets/feature_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  // this lastWords will contains words which user saids.
  String lastWords = "";
  final flutterTts = FlutterTts();
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    // for ios
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      // this lastWords contains words which user saids.
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop(); //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Assistant"),
        leading: const Icon(Icons.chat_bubble_outline_outlined),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Image(
                image: AssetImage("assets/images/chatgpt_icon.png"),
                width: 110,
                height: 110,
              ),
            ),
            if (generatedContent != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 40)
                    .copyWith(top: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Pallete.blackColor),
                  borderRadius:
                      BorderRadius.circular(20).copyWith(topLeft: Radius.zero),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    generatedContent!,
                    style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontSize: generatedContent == null ? 20 : 16,
                    ),
                  ),
                ),
              ),

            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(generatedImageUrl!)),
              ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10, left: 22),
                child: const Text(
                  "Here are some features",
                  style: TextStyle(
                    color: Pallete.mainFontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // --- Features List
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: const [
                  FeatureBox(
                    color: Pallete.firstSuggestionBoxColor,
                    headerText: "ChatGPT",
                    descriptionText:
                        "A smarter way to stay organized and informed with ChatGPT",
                  ),
                  FeatureBox(
                    color: Pallete.secondSuggestionBoxColor,
                    headerText: "Dall-E",
                    descriptionText:
                        "A smarter way to stay organized and informed with ChatGPT",
                  ),
                  FeatureBox(
                    color: Pallete.firstSuggestionBoxColor,
                    headerText: "Smart Voice Assistant",
                    descriptionText:
                        "A smarter way to stay organized and informed with ChatGPT",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            final speech = await openAIService.isArtPromptAPI(lastWords);
            if (speech.contains('https')) {
              generatedImageUrl = speech;
              generatedContent = null;
              setState(() {});
            } else {
              generatedImageUrl = null;
              generatedContent = speech;
              setState(() {});
              await systemSpeak(speech);
            }

            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: const Icon(Icons.mic),
      ),
    );
  }
}
