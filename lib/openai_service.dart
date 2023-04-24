import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voice_assistant/secrets.dart';

class OpenAIService {
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
    return "CHATGPT";
  }

  Future<String> dallEAPI(String prompt) async {
    return "DALL-E";
  }
}
