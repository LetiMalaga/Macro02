# Macro02

Este é um repositório do projeto para o Macro 02 do Apple Developer Academy UCB 2023/24. O projeto consiste em um aplicativo iOS desenvolvido em Swift e é o Macro #02 de 2024 do grupo 02 com os desenvolvedores:
- Arthur Liberal,
- Felipe Porto,
- Luca Beraldi,
- Letícia Malagutti,
- Luis Felipe Zica

O objetivo do projeto é desenvolver um aplicativo de "pomodoro" multi-plataforma que auxilia o usuário a ser mais produtivo, evitando a síndrome do burnout ao sugerir atividades rápidas e relaxantes que podem ser feitas nos momentos de intervalo do usuário.

## Estrutura do Projeto

A estrutura de pastas e arquivos do projeto é organizada da seguinte forma:

```
MAcro02-Grupo02/
├── Localizable.xcstrings
│
├── MAcro02-Grupo02/
│   ├── LaunchScreen.storyboard
│   ├── Main.storyboard
│   ├── SceneDelegate.swift
│   ├── ViewController.swift
<!-- │   ├── Model/
│   │   └── Model.swift
│   ├── NavigationController/
│   │   ├── Navigator.swift
│   │   ├── PageManager.swift
│   │   └── GameScene.swift
│   ├── Views/
│   │   ├── Inventory/
│   │   │   ├── InventoryView.swift
│   │   │   └── InventoryViewModel.swift
│   │   ├── Menu/
│   │   │   ├── MenuView.swift
│   │   │   ├── PauseMenuView.swift
│   │   │   ├── GamePlayFeedbackView.swift
│   │   │   └── SettingsView.swift
│   │   ├── HowToPlay/
│   │   │   └── HowToPlayView.swift
│   ├── GameSystem/
│   │   ├── Components/
│   │   │   ├── MotionComponent.swift
│   │   │   ├── DamageComponent.swift
│   │   │   ├── AttackComponent.swift
│   │   │   ├── VisualComponent.swift
│   │   │   └── gameCollisionComponent.swift
│   │   ├── Entities/
│   │   │   ├── BulletEntity.swift
│   │   │   ├── EnemyEntity.swift
│   │   │   ├── PlayerEntity.swift
│   │   │   └── FrogEntity.swift
│   │   ├── System/
│   │   │   ├── MotionSystem.swift
│   │   │   └── CollisionSystem.swift
│   │   └── MainScene.swift
│   └── Utils/
│   │   ├── frogDrone.usdz
│   │   └── ComponentePauseMenu.swift -->
│   │
│   ├── AppDelegate.swift
│   ├── ContentView.swift
│   ├── GameController.swift
│   │
│   ├── Assets.xcassets/
│   │
│   └── Info.plist
│   
├── MAcro02-Grupo02Tests/
│   └── MAcro02_Grupo02Tests.swift
│
├── MAcro02-Grupo02UITests/
│   ├── MAcro02_Grupo02UITests.swift
│   └── MAcro02_Grupo02UITestsLaunchTests.swift
│
├── Podfile
├── README.md
└── .gitignore
```

## Estrutura de Commits

Para manter o histórico de commits organizado e fácil de entender, siga esta estrutura para suas mensagens de commit:

1. **Tipo de Commit:** O tipo de mudança que você está fazendo. Use um dos seguintes prefixos:
    - `feat`: Uma nova funcionalidade
    - `fix`: Correção de bug
    - `refactor`: Mudança de código que não corrige um bug nem adiciona uma funcionalidade, somente reescreve/reestrutura um código
    - `perf`: Mudanças de código referentes à performance do código
    - `style`: Mudanças que não afetam o significado do código (espaços em branco, formatação, ponto e vírgula, etc)
    - `test`: Adicionando testes ausentes ou corrigindo testes existentes
    - `docs`: Mudanças na documentação
    - `build`: Mudanças de código que afetam os componentes de build, ci pipeline, dependências, versão de projeto
    - `ops`: Mudanças que afetam os componentes operacionais tipo infraestrtura, deployment, backup
    - `chore`: Mudanças em ferramentas auxiliares e bibliotecas

2. **Descrição do Commit:** Uma breve descrição do que foi feito.

### Exemplos de Mensagens de Commit

- `US01 feat: adiciona funcionalidade de login`
- `US01 fix: corrige bug no carregamento de dados`
- `US02 refactor: reorganiza estrutura das pastas`
- `US01 perf: otimização de funcionalidade de login`
- `US02 style: formata código no arquivo MainViewController.swift`
- `US01 test: adiciona testes para o serviço de autenticação`
- `US02 docs: atualiza README com instruções de instalação`
- `US02 build: ajuste CI pipeline`
- `US02 ops: ajuste backup de dados`
- `US02 chore: atualiza dependências do Podfile`

## Instalação

1. Clone o repositório:
    ```bash
    git clone https://github.com/LetiMalaga/Macro02.git
    ```

2. Navegue até o diretório do projeto:
    ```bash
    cd MAcro02-Grupo02
    ```

3. Instale as dependências do projeto:
    ```bash
    pod install
    ```

4. Abra o projeto no Xcode:
    ```bash
    open MAcro02-Grupo02.xcodeproj
    ```

## Contribuição

1. Faça um fork do projeto.
2. Crie uma nova branch com a sua funcionalidade ou correção de bug:
    ```bash
    git checkout -b minha-nova-feature
    ```
3. Commit suas mudanças:
    ```bash
    git commit -m 'US## [tipo]: [comentário descrevendo o que foi feito]'
    ```
4. Envie para o repositório remoto:
    ```bash
    git push origin minha-nova-feature
    ```
5. Abra um Pull Request.
