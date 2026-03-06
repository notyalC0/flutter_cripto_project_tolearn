# Documentação - Flutter App

## 📋 Descrição do Projeto

**flutter_app** é uma aplicação Flutter multiplataforma para gerenciamento de investimentos em criptomoedas. O app permite aos usuários acompanhar moedas, gerenciar carteiras, registrar transações e manter favoritas.

**Versão:** 1.0.0
**SDK Flutter:** >=2.19.6 <3.0.0
**Tipo:** Aplicação Privada (não publicada no pub.dev)

---

## 🎯 Funcionalidades Principais

- ✅ **Autenticação de Usuário** - Login seguro com serviço de autenticação
- ✅ **Gerenciamento de Moedas** - Visualizar lista de criptomoedas e detalhes
- ✅ **Carteira Digital** - Gerenciar múltiplas contas/carteiras
- ✅ **Transações** - Registrar compras, vendas e histórico
- ✅ **Favoritas** - Marcar moedas como favoritas
- ✅ **Carrinho de Compras** - Sistema de compras com carrinho
- ✅ **Configurações** - Preferências do app com tema escuro/claro
- ✅ **Persistência de Dados** - Sincronização local com banco de dados
- ✅ **Formatação Monetária** - Suporte a múltiplas moedas com formatação

---

## 📁 Estrutura de Pastas

```
flutter_app/
├── lib/
│   ├── main.dart                  # Ponto de entrada da aplicação
│   ├── meu_app.dart              # Widget raiz com configuração de tema
│   │
│   ├── api/
│   │   └── api_data.dart         # Requisições e dados de API
│   │
│   ├── config/
│   │   └── app.settings.dart     # Configurações globais (tema, preferências)
│   │
│   ├── database/
│   │   └── db.dart               # Inicialização e gerenciamento do banco SQLite/Hive
│   │
│   ├── helpers/
│   │   └── formatters.dart       # Funções utilitárias de formatação
│   │
│   ├── models/                   # Modelos de dados
│   │   ├── cart_item.dart        # Itens do carrinho
│   │   ├── carteira.dart         # Carteira/Portfolio
│   │   ├── conta.dart            # Conta do usuário
│   │   ├── favoritas.dart        # Moedas favoritas
│   │   ├── historico.dart        # Histórico de transações
│   │   ├── login.dart            # Dados de login
│   │   ├── moeda.dart            # Dados da criptomoeda
│   │   ├── posicao.dart          # Posição de investimento
│   │   └── transacao.dart        # Registro de transação
│   │
│   ├── pages/                    # Telas/Pages da aplicação
│   │   ├── login_page.dart       # Tela de login
│   │   ├── home_page.dart        # Tela inicial/dashboard
│   │   ├── moedas_page.dart      # Lista de moedas
│   │   ├── moedas_detalhes_page.dart      # Detalhes de moeda específica
│   │   ├── compradas_page.dart   # Histórico de compras
│   │   ├── vendas_detalhes_page.dart      # Detalhes de vendas
│   │   ├── favoritas_page.dart   # Moedas favoritas
│   │   └── configuracoes_page.dart        # Configurações do app
│   │
│   ├── repositories/             # Gerenciamento de estado e dados
│   │   ├── moeda_repository.dart # Repositório de moedas
│   │   ├── conta_repository.dart # Repositório de contas
│   │   ├── favoritas_repository.dart     # Repositório de favoritas
│   │   ├── cart_repository.dart  # Repositório do carrinho
│   │   └── archive/              # Arquivos arquivados/antigos
│   │
│   ├── service/                  # Serviços de negócio
│   │   ├── auth_service.dart     # Serviço de autenticação
│   │   └── conta_service.dart    # Serviço de gerenciamento de contas
│   │
│   └── widgets/                  # Componentes reutilizáveis (UI)
│
├── android/                       # Código nativo Android (Kotlin/Java)
├── ios/                          # Código nativo iOS (Swift)
├── web/                          # Código para web
├── windows/                      # Código para Windows
├── linux/                        # Código para Linux
├── macos/                        # Código para macOS
├── test/                         # Testes (widget_test.dart)
│
├── build/                        # Artefatos compilados (gerado automaticamente)
├── images/                       # Assets de imagens
│
├── pubspec.yaml                  # Definição de dependências e configurações
├── analysis_options.yaml         # Configurações de lint e análise
├── README.md                     # Documentação original
└── DOCUMENTACAO.md              # Este arquivo

```

---

## 📦 Dependências Principais

### Dependências de Produção

| Pacote                          | Versão   | Propósito                                |
| ------------------------------- | -------- | ---------------------------------------- |
| `flutter`                       | SDK      | Framework Flutter base                   |
| `intl`                          | Latest   | Internacionalização e formatação         |
| `currency_text_input_formatter` | ^2.1.10  | Formatação de entrada monetária          |
| `provider`                      | ^5.0.0   | Gerenciamento de estado                  |
| `shared_preferences`            | ^2.0.6   | Armazenamento local de preferências      |
| `hive`                          | ^2.0.4   | Banco de dados NoSQL local               |
| `hive_flutter`                  | ^1.1.0   | Integração Hive com Flutter              |
| `path_provider`                 | ^2.0.2   | Acesso a caminhos do sistema de arquivos |
| `sqflite`                       | ^2.0.0+3 | Banco de dados SQLite                    |
| `sqflite_common`                | ^2.4.5   | Utilitários comuns SQLite                |
| `sqflite_common_ffi`            | ^2.2.5   | FFI para SQLite multiplataforma          |
| `http`                          | ^0.13.6  | Requisições HTTP para APIs               |
| `cupertino_icons`               | ^1.0.2   | Ícones iOS (CupertinoIcons)              |

### Dependências de Desenvolvimento

| Pacote          | Versão | Propósito                   |
| --------------- | ------ | --------------------------- |
| `flutter_test`  | SDK    | Framework de testes Flutter |
| `flutter_lints` | ^2.0.0 | Regras de lint recomendadas |

---

## 🏗️ Arquitetura

### Padrão MVC Modificado

O projeto utiliza uma arquitetura baseada em **padrão de camadas**:

```
┌─────────────────────────────────┐
│   Pages (Telas/UI)              │
│   login_page, home_page, etc    │
└────────┬────────────────────────┘
         │ consume
┌────────▼────────────────────────┐
│   Repositories                  │
│   (State Management - Provider)  │
└────────┬────────────────────────┘
         │ consomem
┌────────▼────────────────────────┐
│   Services & Models             │
│   (Lógica de Negócio)           │
└────────┬────────────────────────┘
         │ acessam
┌────────▼────────────────────────┐
│   Database & API                │
│   (Persistência de Dados)        │
└─────────────────────────────────┘
```

### Componentes Principais

#### 1. **Models** (`lib/models/`)

Definem a estrutura de dados da aplicação:

- `Moeda` - Representação de criptomoeda
- `Conta` - Conta de usuário
- `Transacao` - Registro de transação
- `CartItem` - Item do carrinho
- `Favoritas` - Moedas marcadas como favoritas

#### 2. **Repositories** (`lib/repositories/`)

Gerenciam estado e comunicação entre UI e serviços:

- Herdam de `ChangeNotifier` (Provider)
- Notificam listeners sobre mudanças de estado
- Centralizam lógica de negócio
- Exemplo: `MoedaRepository`, `ContaRepository`

#### 3. **Services** (`lib/service/`)

Implementam funcionalidades específicas:

- `AuthService` - Autenticação de usuários
- `ContaService` - Operações de conta

#### 4. **Pages** (`lib/pages/`)

Telas da aplicação que consomem dados via Provider:

- Implementam `StatelessWidget` ou `StatefulWidget`
- Acessam repositórios via `context.watch()` ou `context.read()`

#### 5. **Config** (`lib/config/`)

- `AppSettings` - Configurações globais (tema, preferências)

#### 6. **Database** (`lib/database/`)

- Gerencia persistência com SQLite/Hive
- Inicialização de bancos de dados

---

## 🎨 Tema e UI

### Cores Principais

```dart
const primaryBlue = Color(0xFF1E3A8A);      // Azul primário
const darkBackground = Color(0xFF0F172A);  // Fundo escuro
const darkSurface = Color(0xFF1E293B);     // Superfície escura
```

### Material Design 3

- Suporte a tema escuro/claro
- Design responsivo para múltiplas plataformas
- Ícones Material e Cupertino

---

## 🔄 Fluxo de Dados com Provider

### Inicialização no `main.dart`:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => AppSettings()),
    ChangeNotifierProvider(create: (context) => ContaRepository()),
    ChangeNotifierProvider(create: (context) => FavoritasRepository()),
    ChangeNotifierProvider(create: (context) => CartRepository()),
    Provider(create: (context) => AuthService()),
  ],
  child: const MeuApp(),
)
```

### Consumo nas Pages:

```dart
// Watch - reconstrói quando notificaçõese são emitidas
final settings = context.watch<AppSettings>();

// Read - acesso sem reconstrução
final repository = context.read<ContaRepository>();
```

---

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (>=2.19.6)
- Dart SDK
- Git
- IDE: VS Code, Android Studio ou Xcode

### Instalação

1. **Clonar ou acessar o projeto:**

```bash
cd c:\Dev\projetos\flutter\flutter_app
```

2. **Instalar dependências:**

```bash
flutter pub get
```

3. **Executar no Android:**

```bash
flutter run -d android
```

4. **Executar no iOS:**

```bash
flutter run -d ios
```

5. **Executar na Web:**

```bash
flutter run -d chrome
```

6. **Build de Release:**

```bash
flutter build apk      # Android APK
flutter build ipa      # iOS IPA
flutter build web      # Web version
```

---

## 💾 Persistência de Dados

### Hive

- Armazenamento de chave-valor rápido
- Dados sensíveis e preferências do usuário
- Box: `'settings'`

### SQLite

- Banco de dados relacional
- Armazenamento de transações, histórico e carteira
- Acesso via `sqflite`

### SharedPreferences

- Preferências simples do usuário
- Local: `lib/database/db.dart`

---

## 🔐 Autenticação

Gerenciada por `AuthService` (`lib/service/auth_service.dart`):

- Login de usuários
- Validação de credenciais
- Gerenciamento de sessão
- Modelo: `Login` (`lib/models/login.dart`)

---

## 📊 Modelos de Dados

### Moeda

```dart
class Moeda {
  String icone;      // URL do ícone
  String nome;       // Nome completo (ex: Bitcoin)
  String sigla;      // Sigla (ex: BTC)
  double valor;      // Valor atual
}
```

### Transacao

```dart
class Transacao {
  // Tipo, valor, data, moeda, quantidade
}
```

### CartItem

```dart
class CartItem {
  // Moeda, quantidade, preço unitário
}
```

### Conta

```dart
class Conta {
  // Dados do usuário/carteira
}
```

---

## 🛠️ Ferramentas de Desenvolvimento

### Linting

- `flutter_lints: ^2.0.0`
- Configuração: `analysis_options.yaml`

### Testing

- Framework: `flutter_test`
- Localização: `test/widget_test.dart`

### Comandos Úteis

```bash
# Analisar código
flutter analyze

# Formatar código
dart format lib/

# Executar testes
flutter test

# Limpar build
flutter clean

# Atualizar dependências
flutter pub upgrade
```

---

## 📱 Suporte Multiplataforma

| Platform   | Suporte | Status           |
| ---------- | ------- | ---------------- |
| ✅ Android | Nativo  | Implementado     |
| ✅ iOS     | Nativo  | Implementado     |
| ✅ Web     | Web     | Implementado     |
| ✅ Windows | Desktop | Build disponível |
| ✅ Linux   | Desktop | Build disponível |
| ✅ macOS   | Desktop | Build disponível |

---

## 📝 Estrutura de Páginas

### Login

- **Arquivo:** `lib/pages/login_page.dart`
- **Propósito:** Autenticação de usuários
- **Fluxo:** Login → Home

### Home

- **Arquivo:** `lib/pages/home_page.dart`
- **Propósito:** Dashboard/tela inicial
- **Exibe:** Resumo de carteira, moedas em alta

### Moedas

- **Arquivo:** `lib/pages/moedas_page.dart`
- **Propósito:** Lista de todas as criptomoedas
- **Ações:** Favoritar, visualizar detalhes

### Detalhes da Moeda

- **Arquivo:** `lib/pages/moedas_detalhes_page.dart`
- **Propósito:** Informações detalhadas de uma moeda
- **Ações:** Comprar, adicionar ao carrinho

### Compradas

- **Arquivo:** `lib/pages/compradas_page.dart`
- **Propósito:** Histórico de moedas compradas

### Vendas

- **Arquivo:** `lib/pages/vendas_detalhes_page.dart`
- **Propósito:** Detalhes das vendas realizadas

### Favoritas

- **Arquivo:** `lib/pages/favoritas_page.dart`
- **Propósito:** Moedas marcadas como favoritas
- **Gerenciado por:** `FavoritasRepository`

### Configurações

- **Arquivo:** `lib/pages/configuracoes_page.dart`
- **Propósito:** Preferências do app (tema, idioma)
- **Gerenciado por:** `AppSettings`

---

## 🔧 Helpers e Utilitários

### Formatters (`lib/helpers/formatters.dart`)

- Formatação de moeda
- Formatação de datas
- Conversão de valores

---

## 📤 API Integration

### Arquivo: `lib/api/api_data.dart`

- Configuração de endpoints
- Requisições HTTP
- Tratamento de respostas
- Cache de dados

---

## 🎯 Contribuindo

### Padrões de Código

1. **Nomenclatura:** `camelCase` para variáveis, `PascalCase` para classes
2. **Formatting:** Execute `dart format lib/` antes de fazer commit
3. **Imports:** Use imports relativos quando possível
4. **Comentários:** Documente funções públicas
5. **Estado:** Use `ChangeNotifier` nos repositórios

### Exemplo de novo Provider:

```dart
class MeuRepository extends ChangeNotifier {
  List<MeuModelo> _dados = [];

  List<MeuModelo> get dados => _dados;

  void atualizar(MeuModelo novo) {
    _dados.add(novo);
    notifyListeners();
  }
}
```

### Exemplo de consumo em Page:

```dart
class MinhaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<MeuRepository>();

    return ListView.builder(
      itemCount: repo.dados.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(repo.dados[index].toString()));
      },
    );
  }
}
```

---

## 🐛 Troubleshooting

### Erro: "Package not found"

```bash
flutter pub get
flutter clean
flutter pub get
```

### Erro: "Pod import conflict" (iOS)

```bash
cd ios
rm -rf Pods
rm Podfile.lock
cd ..
flutter clean
flutter pub get
```

### Erro: "Build cache is corrupted"

```bash
flutter clean
flutter pub get
flutter run
```

### Verificar versão Flutter

```bash
flutter --version
flutter doctor
```

---

## 📚 Recursos

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Hive Database](https://pub.dev/packages/hive)
- [SQLite Documentation](https://pub.dev/packages/sqflite)
- [Material Design 3](https://m3.material.io/)

---

## 📄 Licença

Aplicação privada - Todos os direitos reservados.

---

## 👨‍💼 Informações do Projeto

**Versão:** 1.0.0+1
**Data de Criação:** 2026
**Status:** Ativo
**Publicação:** Privada (não publicada em pub.dev)

---

## 📞 Contato

Para dúvidas ou sugestões sobre o projeto, consulte a documentação interna ou repositório do projeto.

---

**Última atualização:** 6 de março de 2026
