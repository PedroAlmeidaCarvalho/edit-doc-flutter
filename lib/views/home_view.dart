import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/services/banco_local_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void _mostrarPreferencias(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    final notificacoes = prefs.getBool('notificacoes') ?? false;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Minhas Preferências'),
        content: Text('Tema Atual: ${isDark ? "Escuro" : "Claro"}\nNotificações Ativadas: ${notificacoes ? "Sim" : "Não"}'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fechar'))],
      ),
    );
  }

  void _mostrarUsuarios(BuildContext context) async {
    final usuarios = await BancoDadosLocal.obterTodosUsuarios();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usuários no Banco de Dados'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: usuarios.length,
            itemBuilder: (c, i) => ListTile(
              leading: const Icon(Icons.person),
              title: Text(usuarios[i].nome),
              subtitle: Text(usuarios[i].email),
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fechar'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? null : Colors.lightBlue[100],
      appBar: AppBar(
        title: const Text('Tela Principal'),
        backgroundColor: isDark ? null : Colors.blue,
        foregroundColor: isDark ? null : Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network('https://media.giphy.com/media/p6zElcl27INBS/giphy.gif', height: 200),
            const SizedBox(height: 16),
            Text(
              'Bem-vindo(a), ${authViewModel.nomeUsuarioLogado}!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () => _mostrarPreferencias(context),
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(children: [Icon(Icons.settings, size: 40, color: Colors.blue), SizedBox(width: 16), Text('Ver Minhas Preferências', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))]),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () => _mostrarUsuarios(context),
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(children: [Icon(Icons.group, size: 40, color: Colors.green), SizedBox(width: 16), Text('Ver Usuários do Banco', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))]),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: isDark ? Colors.grey[900] : Colors.blue,
        child: const Center(child: Text('Desenvolvido por: Pedro Almeida Carvalho', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
      ),
    );
  }
}