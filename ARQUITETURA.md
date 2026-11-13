# Relatório de Migração Arquitetural (MVVM)
**Desenvolvedor:** Pedro Almeida Carvalho

## 1. Mapeamento de Classes e Widgets


| Estrutura Anterior (DartPad) | Nova Localização (MVVM) | Papel na Arquitetura |
| :--- | :--- | :--- |
| `Usuario` (Classe) | `lib/models/usuario.dart` | **Model:** Define a entidade de dados. |
| `BancoDadosLocal` | `lib/models/services/banco_local_service.dart` | **Service:** Isola a lógica de persistência de dados. |
| Funções de Validação | `lib/utils/validadores.dart` | **Utils:** Funções auxiliares puras. |
| `TelaLogin` | `lib/views/login_view.dart` | **View:** Interface gráfica de autenticação. |
| `TelaCadastro` | `lib/views/cadastro_view.dart` | **View:** Interface gráfica de registro. |
| `TelaHome` | `lib/views/home_view.dart` | **View:** Interface principal do usuário. |
| Variáveis e Funções de Estado | `lib/viewmodels/auth_viewmodel.dart` | **ViewModel:** Centraliza a lógica de negócios e o estado global. |
| `MeuApp` e `main()` | `lib/main.dart` | **Entry Point:** Injeção de rotas e definição do Tema global. |

## 2. Alterações de Estrutura e Imports

A divisão do projeto em múltiplos arquivos exigiu adaptações estruturais e de visibilidade:
* **Injeção de Dependências Visuais (Imports):** Cada arquivo agora declara explicitamente suas dependências. As Views importam seus respectivos ViewModels (`import '../viewmodels/auth_viewmodel.dart';`) e os Utilitários (`import '../utils/validadores.dart';`), evitando acoplamento oculto.
* **Rotas Nomeadas no main.dart:** O arquivo `main.dart` passou a importar as telas da pasta `views/` para registrar o mapa de rotas (`routes: { '/' : (context) => LoginView(), ... }`).
* **Simplificação dos Widgets:** Como o controle lógico saiu das telas, muitas interfaces que antes precisavam herdar de `StatefulWidget` foram convertidas em `StatelessWidget`.

## 3. Mudanças no Gerenciamento de Estado

A maior mudança arquitetural ocorreu na reatividade da aplicação, com a remoção completa da dependência do método `setState()` nas telas:
* **Delegação ao ViewModel:** As variáveis de estado, como `_temaSelecionado` e `_receberNotificacoes`, além dos métodos `_fazerLogin` e `_cadastrar`, foram realocados para a classe `AuthViewModel`.
* **Implementação do ChangeNotifier:** O `AuthViewModel` agora estende `ChangeNotifier`. Sempre que uma preferência (como o tema escuro) é alterada pelo usuário e salva no `shared_preferences`, o ViewModel chama a função `notifyListeners()`.
* **Reatividade com ListenableBuilder:** Nas Views (como no `main.dart` para o tema e no `cadastro_view.dart` para os seletores), adicionamos o widget `ListenableBuilder`. Ele "escuta" o `AuthViewModel` e reconstrói apenas os pedaços da interface que dependem daqueles dados, tornando a aplicação muito mais performática do que utilizando reconstruções globais de estado da árvore.