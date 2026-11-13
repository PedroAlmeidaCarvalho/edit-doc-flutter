import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../models/services/banco_local_service.dart';

class AuthViewModel extends ChangeNotifier {
  ThemeMode temaAtual = ThemeMode.light;
  String temaSelecionado = 'Claro';
  bool receberNotificacoes = true;
  String nomeUsuarioLogado = 'Convidado';

  AuthViewModel() {
    _carregarTema();
  }

  Future<void> _carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    final temaEscuroAtivo = prefs.getBool('isDark') ?? false;
    temaAtual = temaEscuroAtivo ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); 
  }

  Future<void> alternarTema(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
    temaAtual = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void atualizarTemaSelecionado(String novoValor) {
    temaSelecionado = novoValor;
    notifyListeners();
  }

  void atualizarNotificacoes(bool valor) {
    receberNotificacoes = valor;
    notifyListeners();
  }

  Future<bool> fazerLogin(String email, String senha) async {
    final usuarioLogado = await BancoDadosLocal.autenticar(email, senha);
    if (usuarioLogado != null) {
      nomeUsuarioLogado = usuarioLogado.nome;
      return true;
    }
    return false;
  }

  Future<bool> cadastrar(String nome, String email, String senha) async {
    final novoUsuario = Usuario(nome: nome, email: email, senha: senha);
    final sucesso = await BancoDadosLocal.cadastrarUsuario(novoUsuario);
    if (sucesso) {
      bool isDark = temaSelecionado == 'Escuro';
      await alternarTema(isDark);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificacoes', receberNotificacoes);
    }
    return sucesso;
  }
}

// Instância global simplificada (para a etapa 4)
final authViewModel = AuthViewModel();