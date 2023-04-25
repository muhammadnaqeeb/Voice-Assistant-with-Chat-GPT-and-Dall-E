# Voice Assistant
A Voice Assistant build in flutter with chat GPT and Dall-E image Generator integration (Machine Learning)

# Feature
* Speech to text
* Generate ChatGPT response on voice command
* Generate image on voice command
* Text to Speech

## Speech to text
```
package
  speech_to_text
Dependency
  speech_to_text: ^6.1.1
```

### Configuration
**IOS**

Go to <project root>/ios/Runner/Info.plist
Add following lines
```
    <key>NSSpeechRecognitionUsageDescription</key>
    <string>Microphone</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Microphone</string>
    
```
**Android**
Go to <project root>/android/app/src/main/AndroidManifest.xml 
```
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.BLUETOOTH"/>
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
```

If you are targeting Android SDK, i.e. you set your targetSDKVersion to 30 or later, then you will need to add the following to your AndroidManifest.xml right after the permissions section. 
```
    <queries>
        <intent>
            <action android:name="android.speech.RecognitionService" />
        </intent>
    </queries>
```
### Code
```
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


  final speechToText = SpeechToText();
  // this lastWords will contains words which user saids.
  String lastWords = "";
  @override
  void initState() {
    super.initState();
    initSpeechToText();
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

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }
```
On button press
```
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            await stopListening();
          } else {
            initSpeechToText();
          }
          print(lastWords);
        },
        child: const Icon(Icons.mic),
      ),
      
```

## Getting Access to API
Visit: https://openai.com/

## Making Chat GPT request

```
final List<Map<String, String>> masseges = []; 

  Future<String> chatGPTAPI(String prompt) async {
    masseges.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKEY3"
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": masseges,
        }),
      );

      //print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        masseges.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return "An internal error occur";
    } catch (e) {
      return e.toString();
    }
  }
```

## Making Dall-E request

```
  Future<String> dallEAPI(String prompt) async {
    masseges.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse("https://api.openai.com/v1/images/generations"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKEY3"
        },
        body: jsonEncode(
          {
            "prompt": prompt,
            "n": 1,
          },
        ),
      );

      //print(res.body);
      if (res.statusCode == 200) {
        String imgUrl = jsonDecode(res.body)['data'][0]['url'];

        masseges.add({
          'role': 'assistant',
          'content': imgUrl,
        });
        return imgUrl;
      }
      return "An internal error occur";
    } catch (e) {
      return e.toString();
    }
  }
```

## Text To Speech

Dependency
```
   flutter_tts: ^3.6.3
```


import
```
import 'package:flutter_tts/flutter_tts.dart';

```
Initial it
```
  final flutterTts = FlutterTts();
```

Make following method & call it on initState()
```
  Future<void> initTextToSpeech() async {
    // for ios
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }
```
Calling upper function in initState()
```
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech(); // this line
  }
```
In dispose method
```
  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop(); // this line
  }
```

Create another function which is responsible for speaking
```
  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content); 
  }
```
This function read out the content pass to it.

