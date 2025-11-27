import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:jogos_videogame_t3/view/image_search_dialog.dart';
import 'package:jogos_videogame_t3/model/game_model.dart';
import 'package:jogos_videogame_t3/service/firestore_service.dart';
import 'package:jogos_videogame_t3/components/custom_text_field.dart';
import 'package:jogos_videogame_t3/components/custom_dropdown.dart';
import 'package:jogos_videogame_t3/components/image_picker_section.dart';
import 'package:jogos_videogame_t3/constants/app_constants.dart';

class GamePage extends StatefulWidget {
  final Game? game;

  const GamePage({Key? key, this.game}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Game? _editGame;
  bool _gameEdited = false;
  final _nameController = TextEditingController();
  final _realeaseyearController = TextEditingController();
  final _gamecompanyController = TextEditingController();
  final _classificationController = TextEditingController();
  final _priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _loadingImage = false;

  String _selectedPlataform = 'PC';
  String _selectedGender = 'Ação';

  @override
  void initState() {
    super.initState();
    if (widget.game == null) {
      _editGame = Game(
        name: "",
        plataform: _selectedPlataform,
        gender: _selectedGender,
        realeaseyear: "",
        gamecompany: "",
        classification: "",
        price: "",
        img: null,
      );
    } else {
      _editGame = Game.fromMap(widget.game!.toMap());
      _nameController.text = _editGame!.name;
      _selectedPlataform = _editGame!.plataform;
      _selectedGender = _editGame!.gender;
      _realeaseyearController.text = _editGame!.realeaseyear;
      _gamecompanyController.text = _editGame!.gamecompany;
      _classificationController.text = _editGame!.classification;
      _priceController.text = _editGame!.price;
      
      if (_editGame!.img != null && _editGame!.img!.isNotEmpty) {
        _imageFile = File(_editGame!.img!);
      }
    }
  }

  void _saveGame() async {
    if (_editGame!.name.isNotEmpty) {
      _editGame!.plataform = _selectedPlataform;
      _editGame!.gender = _selectedGender;

      if (_imageFile != null) {
        _editGame!.img = _imageFile!.path;
      }

      final firestoreService = FirestoreService();
      
      try {
        if (_editGame!.id != null) {
          await firestoreService.update(_editGame!.id!, _editGame!);
        } else {
          await firestoreService.create(_editGame!);
        }
        
        Navigator.pop(context, _editGame);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao salvar: $e"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Nome é obrigatório!"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _editGame!.name.isEmpty ? "Novo Jogo" : _editGame!.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: _saveGame,
          backgroundColor: Colors.transparent,
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
            child: const Icon(Icons.save, size: 30, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            ImagePickerSection(
              imageFile: _imageFile,
              imagePath: _editGame!.img,
              loadingImage: _loadingImage,
              onTap: _selectImage,
            ),
            const SizedBox(height: 30),
            _buildFormSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
          label: "Nome do Jogo",
          icon: Icons.games,
          onChanged: (text) {
            _gameEdited = true;
            _editGame!.name = text;
          },
        ),
        const SizedBox(height: 16),
        
        CustomDropdown(
          value: _selectedPlataform,
          items: AppConstants.plataformOptions,
          label: "Plataforma",
          icon: Icons.computer,
          onChanged: (String? newValue) {
            setState(() {
              _selectedPlataform = newValue!;
              _gameEdited = true;
            });
          },
        ),
        const SizedBox(height: 16),
        
        CustomDropdown(
          value: _selectedGender,
          items: AppConstants.genderOptions,
          label: "Gênero",
          icon: Icons.category,
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue!;
              _gameEdited = true;
            });
          },
        ),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _realeaseyearController,
          label: "Ano de Lançamento",
          icon: Icons.calendar_today,
          onChanged: (text) {
            _gameEdited = true;
            _editGame!.realeaseyear = text;
          },
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _gamecompanyController,
          label: "Empresa Desenvolvedora",
          icon: Icons.business,
          onChanged: (text) {
            _gameEdited = true;
            _editGame!.gamecompany = text;
          },
        ),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _classificationController,
          label: "Classificação Etária",
          icon: Icons.people,
          onChanged: (text) {
            _gameEdited = true;
            _editGame!.classification = text;
          },
        ),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _priceController,
          label: "Preço",
          icon: Icons.attach_money,
          onChanged: (text) {
            _gameEdited = true;
            _editGame!.price = text;
          },
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }

  Future<void> _selectImage() async {
    final String searchQuery = _editGame!.name.isNotEmpty 
        ? _editGame!.name 
        : "jogo";

    final String? imageUrl = await showDialog<String>(
      context: context,
      builder: (context) => ImageSearchDialog(initialQuery: searchQuery),
    );

    if (imageUrl != null && imageUrl.isNotEmpty) {
      await _downloadAndSaveImage(imageUrl);
    }
  }

  Future<void> _downloadAndSaveImage(String imageUrl) async {
    try {
      setState(() {
        _loadingImage = true;
      });

      final response = await http.get(Uri.parse(imageUrl));
      
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File('${directory.path}/$fileName');
        
        await file.writeAsBytes(response.bodyBytes);
        
        setState(() {
          _imageFile = file;
          _gameEdited = true;
        });
      } else {
        throw Exception('Falha ao baixar imagem: ${response.statusCode}');
      }
    } catch (e) {
      print("Erro ao baixar imagem: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao baixar imagem: $e"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      setState(() {
        _loadingImage = false;
      });
    }
  }
}