import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String apiKey = "TU_API_KEY";

  static Future<Map<String, dynamic>> analyzeFoodImage(File image) async {
    final uri = Uri.parse("https://api.openai.com/v1/chat/completions");

    final imgBase64 = base64Encode(await image.readAsBytes());

    final body = {
      "model": "gpt-4o-mini",
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "input_text",
              "text":
                  "Analyze this meal. Return ONLY a JSON with: calories, protein, carbs, fats."
            },
            {
              "type": "input_image",
              "image_url": "data:image/png;base64,$imgBase64"
            }
          ]
        }
      ]
    };

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    final rawText = data["choices"][0]["message"]["content"];

    final parsed = jsonDecode(rawText);

    return {
      "raw": rawText,
      "data": {
        "calories": parsed["calories"] ?? 0,
        "protein": parsed["protein"] ?? 0,
        "carbs": parsed["carbs"] ?? 0,
        "fats": parsed["fats"] ?? 0,
      }
    };
  }
}
