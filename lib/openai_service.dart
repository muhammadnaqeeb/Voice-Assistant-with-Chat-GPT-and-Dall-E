import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voice_assistant/secrets.dart';

class OpenAIService {
  final List<Map<String, String>> masseges = [];
  // this function tell us whether it is chatGPTAPI or dallEAPI request
  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKEY3"
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content":
                  "Dose user is talking about picture, image, art ? \" $prompt.\" Simply answer with a yes or no."
            },
          ],
        }),
      );
      //print("-------------------");
      //print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res = await dallEAPI(prompt);
            print("dall-e is called");
            return res;
          // no case (default)
          default:
            final res = await chatGPTAPI(prompt);
            print("chatGPTAPI is called");
            return res;
        }
      }
      return "An internal error occur";
    } catch (e) {
      return e.toString();
    }
  }

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
}
