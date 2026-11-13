import 'package:flutter/material.dart';
import '../utils/validadores.dart';
import '../viewmodels/auth_viewmodel.dart';

class CadastroView extends StatelessWidget {
  CadastroView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  void _tentarCadastro(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final sucesso = await authViewModel.cadastrar(
        _nomeController.text.trim(),
        _emailController.text.trim(),
        _senhaController.text,
      );

      if (!context.mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este e-mail já está em uso!'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome Completo', border: OutlineInputBorder()),
                validator: validarNome,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: validarEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
                obscureText: true,
                validator: validarSenha,
              ),
              const SizedBox(height: 24),
              const Text('Preferências do Aplicativo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              
              // ListenableBuilder escuta apenas as mudanças do viewModel para redesenhar esta parte
              ListenableBuilder(
                listenable: authViewModel,
                builder: (context, _) {
                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: authViewModel.temaSelecionado,
                        decoration: const InputDecoration(labelText: 'Tema do App', border: OutlineInputBorder()),
                        items: ['Claro', 'Escuro'].map((String valor) {
                          return DropdownMenuItem<String>(value: valor, child: Text('Tema $valor'));
                        }).toList(),
                        onChanged: (novoValor) => authViewModel.atualizarTemaSelecionado(novoValor!),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('Ativar Notificações do App'),
                        contentPadding: EdgeInsets.zero,
                        value: authViewModel.receberNotificacoes,
                        onChanged: (bool valor) => authViewModel.atualizarNotificacoes(valor),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: () => _tentarCadastro(context), child: const Text('Cadastrar')),
            ],
          ),
        ),
      ),
    );
  }
}