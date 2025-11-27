import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jogos_videogame_t3/view/game_page.dart';
import 'package:jogos_videogame_t3/model/game_model.dart';
import 'package:jogos_videogame_t3/service/firestore_service.dart';
import 'package:jogos_videogame_t3/service/auth_service.dart';
import 'package:jogos_videogame_t3/components/game_card.dart';
import 'package:jogos_videogame_t3/components/confirmation_dialog.dart';
import 'package:jogos_videogame_t3/constants/app_constants.dart';

enum OrderOptions { orderAZ, orderZA }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreService firestoreService = FirestoreService();
  List<Game> games = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  void _loadGames() {
    setState(() {
      _loading = true;
    });
  }

  void _signOut() async {
    final authService = AuthService();
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Minha Biblioteca",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
              ),
            ),
            child: PopupMenuButton<OrderOptions>(
              icon: const Icon(Icons.sort, color: Colors.white),
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                PopupMenuItem<OrderOptions>(
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward, color: AppConstants.primaryColor),
                      const SizedBox(width: 8),
                      const Text("Ordenar de A-Z"),
                    ],
                  ),
                  value: OrderOptions.orderAZ,
                ),
                PopupMenuItem<OrderOptions>(
                  child: Row(
                    children: [
                      Icon(Icons.arrow_downward, color: AppConstants.primaryColor),
                      const SizedBox(width: 8),
                      const Text("Ordenar de Z-A"),
                    ],
                  ),
                  value: OrderOptions.orderZA,
                ),
              ],
              onSelected: _orderList,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _signOut,
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: _showGamePage,
          backgroundColor: Colors.transparent,
          elevation: 8,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.add, size: 30, color: Colors.white),
          ),
        ),
      ),
      body: StreamBuilder<List<Game>>(
        stream: firestoreService.read(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppConstants.primaryColor),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    "Erro ao carregar jogos",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final games = snapshot.data ?? [];

          if (games.isEmpty) {
            return _buildEmptyState();
          }

          return _buildGamesList(games);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppConstants.primaryColor.withOpacity(0.1), AppConstants.secondaryColor.withOpacity(0.1)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.games, size: 60, color: AppConstants.primaryColor),
          ),
          const SizedBox(height: 24),
          const Text(
            "Biblioteca Vazia",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Adicione seu primeiro jogo à coleção",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Toque no + para começar",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesList(List<Game> games) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            "Sua Coleção (${games.length})",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: games.length,
            itemBuilder: (context, index) {
              return GameCard(
                game: games[index],
                onTap: () => _showOptions(context, index, games),
                onEdit: () {
                  Navigator.pop(context);
                  _showGamePage(game: games[index]);
                },
                onDelete: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, index, games);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _orderList(OrderOptions result) {
    switch(result) {
      case OrderOptions.orderAZ:
        games.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        games.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void _showGamePage({Game? game}) async {
    final updatedGame = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamePage(game: game)),
    );

    if (updatedGame != null) {
      setState(() {
        _loadGames();
      });
    }
  }

  void _showOptions(BuildContext context, int index, List<Game> games) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          child: Card(
            color: AppConstants.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.games, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    games[index].name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "O que deseja fazer?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit, size: 20),
                      label: const Text("Editar Jogo"),
                      onPressed: () {
                        Navigator.pop(context);
                        _showGamePage(game: games[index]);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete, size: 20),
                      label: const Text("Excluir Jogo"),
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteConfirmation(context, index, games);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index, List<Game> games) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: "Confirmar Exclusão",
        message: "Tem certeza que deseja excluir \"${games[index].name}\"?",
        onConfirm: () {
          Navigator.pop(context);
          _deleteGame(index, games);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _deleteGame(int index, List<Game> games) {
    if (games[index].id != null) {
      firestoreService.delete(games[index].id!);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Jogo excluído com sucesso!"),
          backgroundColor: AppConstants.accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}