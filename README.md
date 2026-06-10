# 🎮 Minha Biblioteca de Jogos

Aplicativo mobile desenvolvido em Flutter para gerenciamento de uma coleção pessoal de jogos eletrônicos.

O projeto utiliza Firebase Authentication para autenticação de usuários e Cloud Firestore para armazenamento dos dados, permitindo que cada usuário mantenha sua própria biblioteca de jogos de forma segura e organizada.

---

## 📱 Funcionalidades

### 🔐 Autenticação de Usuários

* Cadastro de novos usuários
* Login com e-mail e senha
* Logout da aplicação
* Persistência da sessão autenticada
* Validação de credenciais durante o cadastro

---

### 🎮 Gerenciamento de Jogos

* Cadastro de novos jogos
* Edição de informações dos jogos cadastrados
* Exclusão de jogos da coleção
* Visualização da biblioteca completa
* Atualização automática da lista utilizando Cloud Firestore

---

### 📋 Organização da Biblioteca

* Exibição da quantidade total de jogos cadastrados
* Ordenação alfabética (A → Z)
* Ordenação alfabética reversa (Z → A)
* Interface para gerenciamento individual de cada jogo

---

### 🎨 Interface

* Interface moderna desenvolvida com Flutter
* Tema escuro
* Componentes personalizados
* Feedback visual para operações realizadas
* Mensagens de confirmação para exclusão de registros

---

## 🏗️ Tecnologias Utilizadas

### Front-end

* Flutter
* Dart
* Material Design

### Back-end e Serviços

* Firebase Authentication
* Cloud Firestore

### Armazenamento Local

* Shared Preferences

### Recursos Adicionais

* Image Picker
* HTTP
* Path Provider

---

## 📂 Estrutura do Projeto

```text
lib/
├── components/
├── constants/
├── model/
├── service/
├── view/
├── firebase_options.dart
└── main.dart
```

### Organização

* **components/** → Componentes reutilizáveis da interface.
* **constants/** → Constantes visuais e configurações globais.
* **model/** → Modelos de dados da aplicação.
* **service/** → Comunicação com Firebase e regras de negócio.
* **view/** → Telas da aplicação.

---

## 🔄 Fluxo da Aplicação

1. O usuário abre o aplicativo.
2. O Firebase é inicializado.
3. O sistema verifica se existe uma sessão autenticada.
4. Caso exista:

   * O usuário é direcionado para a biblioteca.
5. Caso contrário:

   * É exibida a tela de login ou cadastro.
6. Após autenticado, o usuário pode:

   * Adicionar jogos;
   * Editar jogos;
   * Excluir jogos;
   * Ordenar sua coleção.

---

## 🚀 Como Executar

### Pré-requisitos

* Flutter SDK
* Firebase configurado
* Android Studio ou VS Code

### Instalação

```bash
git clone https://github.com/mauricio1804/mobile-t3.git

cd mobile-t3

flutter pub get

flutter run
```

---

## 📚 Objetivo Acadêmico

Este projeto foi desenvolvido como atividade acadêmica da disciplina de Desenvolvimento Mobile, aplicando conceitos de:

* Desenvolvimento multiplataforma com Flutter;
* Integração com Firebase;
* Autenticação de usuários;
* Persistência de dados em nuvem;
* Arquitetura de aplicações móveis.

---

## 👨‍💻 Autor

Maurício Fabiano Azevedo Filho

Graduando em Ciência da Computação – UNICENTRO

GitHub: https://github.com/mauricio1804
