import 'dart:convert';
import 'package:http/http.dart' as http;

class RawgService {
  static const String _apiKey =
      "95889df062c54410ad9a7259834020f8";
  static const String _baseUrl = "https://api.rawg.io/api";

  static Future<List<Map<String, String>>> searchGameCovers(
    String query, {
    int count = 10,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/games?key=$_apiKey&search=${Uri.encodeQueryComponent(query)}&page_size=$count',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List?;

        if (results != null) {
          List<Map<String, String>> games = [];

          for (var game in results) {
            if (game['background_image'] != null) {
              games.add({
                'name': game['name'] ?? 'Nome não disponível',
                'imageUrl': game['background_image'],
                'released': game['released'] ?? 'Data não disponível',
                'rating': game['rating']?.toString() ?? 'N/A',
              });
            }
          }

          return games;
        }
      } else {
        print("Erro na API RAWG: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Erro ao buscar jogos: $e");
    }

    return [];
  }
}
