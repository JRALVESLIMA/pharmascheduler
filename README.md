📅 PharmaScheduler
Aplicativo de agendamentos para representantes farmacêuticos.

🧠 Sobre o Projeto
O PharmaScheduler é um aplicativo mobile desenvolvido em Flutter para auxiliar representantes farmacêuticos na organização de seus compromissos.
Ele permite cadastrar, editar, excluir e visualizar agendamentos de forma prática, com suporte a notificações e categorização por tipo de evento.

💡 Tecnologias Utilizadas
- Frontend Mobile: Flutter (Dart)
- Banco de Dados Local: SQLite
- Gerenciamento de Estado: Stateful Widgets
- Notificações: Flutter Local Notifications
- Arquitetura: MVC simplificado (Model, Services, Screens)

📌 Funcionalidades
✅ Cadastro de agendamentos com título, descrição, local, data, hora e tipo
✅ Edição e exclusão de agendamentos existentes
✅ Tipos de agendamento: Reunião, Visita, Apresentação, Outro
✅ Atualização em tempo real da lista de agendamentos
✅ Notificações para lembrar compromissos
✅ Interface simples e intuitiva

📁 Estrutura do Projeto
pharmascheduler/
│
├── lib/
│   ├── model/              # Modelos de dados (Agendamento)
│   ├── services/           # Serviços (DatabaseService, NotificationService)
│   ├── screens/            # Telas (Lista, Detalhes, Edição, Novo Agendamento)
│   └── main.dart           # Ponto de entrada da aplicação
│
├── assets/                 # Ícones e recursos visuais
├── pubspec.yaml            # Dependências do projeto
└── README.md



🚀 Como Rodar o Projeto
Pré-requisitos
- Flutter SDK 3.0+
- Android Studio ou VS Code com extensão Flutter
- Emulador Android ou dispositivo físico conectado
  Passo a passo
- Clone o repositório:
  git clone git@github.com:JRALVESLIMA/pharmascheduler.git
  cd pharmascheduler
- Instale as dependências:
  flutter pub get
- Execute o projeto:
  flutter run



🧪 Testes
- Testes unitários em desenvolvimento para validação de serviços e modelos.
- Testes manuais de interface e fluxo de usuário.

👨‍💼 Autor
JRALVESLIMA – Desenvolvedor em transição de carreira, apaixonado por tecnologia e aprendizado contínuo.
🔗 LinkedIn  GitHub

⚠️ Importante
Este projeto foi criado com fins educacionais e para portfólio.
Não deve ser utilizado em produção sem ajustes de segurança e escalabilidade.
