import 'package:flutter/material.dart';
import 'package:jogos_videogame_t3/service/rawg_service.dart';

class ImageSearchDialog extends StatefulWidget {
  final String initialQuery;

  const ImageSearchDialog({Key? key, required this.initialQuery}) : super(key: key);

  @override
  _ImageSearchDialogState createState() => _ImageSearchDialogState();
}

class _ImageSearchDialogState extends State<ImageSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _games = [];
  bool _loading = false;
  String _currentQuery = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;
    if (widget.initialQuery.isNotEmpty) {
      _searchGames(widget.initialQuery);
    }
  }

  void _searchGames(String query) async {
    if (query.isEmpty) return;
    
    setState(() {
      _loading = true;
      _currentQuery = query;
      _games = [];
      _errorMessage = '';
    });

    try {
      final results = await RawgService.searchGameCovers(query, count: 12);
      
      setState(() {
        _games = results;
        _loading = false;
        
        if (results.isEmpty) {
          _errorMessage = 'Nenhum jogo encontrado para "$query"';
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Erro na busca: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.games, color: Colors.blue, size: 28),
                SizedBox(width: 8),
                Text(
                  'Buscar Capa do Jogo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Digite o nome do jogo',
                hintText: 'Ex: FIFA, GTA V, Minecraft',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchGames(_searchController.text),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: _searchGames,
            ),
            SizedBox(height: 16),
            
            if (_errorMessage.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.orange[800]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
            
            if (_loading) ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Procurando jogos...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Buscando na base de dados RAWG',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ]
            else if (_games.isNotEmpty) ...[
              Text(
                '${_games.length} jogos encontrados para "$_currentQuery"',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _games.length,
                  itemBuilder: (context, index) {
                    return _buildGameCard(_games[index]);
                  },
                ),
              ),
            ]
            else ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 64, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text(
                        _currentQuery.isEmpty 
                            ? 'Pesquise pela capa do jogo' 
                            : 'Nenhum resultado encontrado',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        _currentQuery.isEmpty
                            ? 'Digite o nome do jogo e pressione Enter'
                            : 'Tente outro termo de pesquisa',
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                        textAlign: TextAlign.center,
                      ),
                      if (_currentQuery.isEmpty) ...[
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildSuggestionChip('FIFA'),
                            _buildSuggestionChip('GTA V'),
                            _buildSuggestionChip('Minecraft'),
                            _buildSuggestionChip('Call of Duty'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Cancelar'),
                  ),
                ),
                SizedBox(width: 12),
                if (_games.isNotEmpty) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_games.isNotEmpty) {
                          Navigator.pop(context, _games.first['imageUrl']);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Usar Primeira'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _searchController.text = text;
        _searchGames(text);
      },
      backgroundColor: Colors.blue[50],
      labelStyle: TextStyle(color: Colors.blue),
    );
  }

  Widget _buildGameCard(Map<String, String> game) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, game['imageUrl']);
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                game['imageUrl']!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.grey, size: 40),
                        SizedBox(height: 8),
                        Text(
                          'Erro ao carregar',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game['name']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      if (game['released'] != 'Data não disponível') ...[
                        Text(
                          'Lançamento: ${game['released']!.substring(0, 4)}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                      Text(
                        'Avaliação: ${game['rating']!} ⭐',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}