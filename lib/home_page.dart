import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:voice_assistant/color_pallete.dart';
import 'package:voice_assistant/widgets/feature_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Assistant"),
        leading: const Icon(Icons.chat_bubble_outline_outlined),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const Center(
            child: Image(
              image: AssetImage("assets/images/chatgpt_icon.png"),
              width: 110,
              height: 110,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin:
                const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Pallete.blackColor),
              borderRadius:
                  BorderRadius.circular(20).copyWith(topLeft: Radius.zero),
            ),
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                "Good Morning, What tast can I do for you",
                style: TextStyle(
                  color: Pallete.mainFontColor,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Container(
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
          // --- Features List
          Column(
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () {},
        child: const Icon(Icons.mic),
      ),
    );
  }
}
