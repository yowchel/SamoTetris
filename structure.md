# 📁 Project Structure - Modern Tetris iOS

## Визуальная структура проекта

```
ModernTetris/
│
├── 📱 App/                                    # Application entry point
│   ├── ModernTetrisApp.swift                 # @main entry, app configuration
│   ├── AppDelegate.swift                     # App lifecycle, background tasks
│   └── Info.plist                            # App configuration, permissions
│
├── 🎮 Core/                                   # Core game logic (framework agnostic)
│   │
│   ├── Game/                                 # Main game engine
│   │   ├── GameEngine.swift                  # Central game controller
│   │   ├── TetrisBoard.swift                 # Game board (10×20 grid)
│   │   ├── Tetromino.swift                   # Tetromino pieces (I,O,T,S,Z,J,L)
│   │   ├── Position.swift                    # Position/Point structures
│   │   ├── ScoreManager.swift                # Score calculation logic
│   │   ├── PieceGenerator.swift              # 7-bag randomizer
│   │   └── GameState.swift                   # Game state enum
│   │
│   ├── Audio/                                # Sound system
│   │   ├── SoundManager.swift                # Sound effects player
│   │   └── MusicPlayer.swift                 # Background music player
│   │
│   └── Haptics/                              # Tactile feedback
│       └── HapticManager.swift               # Haptic feedback controller
│
├── 🎯 Features/                               # Feature modules (UI + Logic)
│   │
│   ├── Auth/                                 # Authentication module
│   │   ├── Views/
│   │   │   ├── LoginView.swift               # Email/password login
│   │   │   ├── SignUpView.swift              # Registration form
│   │   │   ├── AppleSignInButton.swift       # Apple Sign In button
│   │   │   └── AuthContainerView.swift       # Auth flow container
│   │   │
│   │   ├── ViewModels/
│   │   │   └── AuthViewModel.swift           # Auth state management
│   │   │
│   │   └── Services/
│   │       └── AuthService.swift             # Auth business logic
│   │
│   ├── Game/                                 # Main game module
│   │   ├── Views/
│   │   │   ├── GameView.swift                # Main game screen
│   │   │   ├── GameOverView.swift            # Game over overlay
│   │   │   ├── PauseView.swift               # Pause menu
│   │   │   └── GameHUDView.swift             # Score, lines, level display
│   │   │
│   │   ├── ViewModels/
│   │   │   └── GameViewModel.swift           # Game UI state
│   │   │
│   │   └── Components/
│   │       ├── BoardView.swift               # Game board visualization
│   │       ├── BlockView.swift               # Individual block rendering
│   │       ├── NextPieceView.swift           # Next pieces preview
│   │       ├── HoldPieceView.swift           # Hold piece display
│   │       └── ControlsOverlay.swift         # Touch controls
│   │
│   ├── Leaderboard/                          # Leaderboard module
│   │   ├── Views/
│   │   │   ├── LeaderboardView.swift         # Main leaderboard screen
│   │   │   ├── LeaderboardRowView.swift      # Single entry row
│   │   │   └── PlayerRankCard.swift          # Current player card
│   │   │
│   │   ├── ViewModels/
│   │   │   └── LeaderboardViewModel.swift    # Leaderboard state
│   │   │
│   │   └── Models/
│   │       └── LeaderboardEntry.swift        # Entry model
│   │
│   ├── Profile/                              # User profile module
│   │   ├── Views/
│   │   │   ├── ProfileView.swift             # Profile screen
│   │   │   ├── ProfileHeaderView.swift       # User info header
│   │   │   ├── StatsGridView.swift           # Statistics grid
│   │   │   └── SettingsView.swift            # User settings
│   │   │
│   │   ├── ViewModels/
│   │   │   └── ProfileViewModel.swift        # Profile state
│   │   │
│   │   └── Services/
│   │       └── ProfileService.swift          # Profile operations
│   │
│   ├── Achievements/                         # Achievements module
│   │   ├── Views/
│   │   │   ├── AchievementsView.swift        # Achievements grid
│   │   │   ├── AchievementCardView.swift     # Single achievement card
│   │   │   ├── AchievementDetailView.swift   # Detail modal
│   │   │   └── AchievementUnlockedView.swift # Unlock notification
│   │   │
│   │   ├── ViewModels/
│   │   │   └── AchievementViewModel.swift    # Achievement state
│   │   │
│   │   └── Models/
│   │       ├── Achievement.swift             # Achievement model
│   │       └── UserAchievement.swift         # User achievement model
│   │
│   └── MainMenu/                             # Main menu module
│       ├── Views/
│       │   ├── MainMenuView.swift            # Home screen
│       │   └── MenuButtonView.swift          # Menu button component
│       │
│       └── ViewModels/
│           └── MainMenuViewModel.swift       # Menu state
│
├── 🔌 Services/                               # Backend & external services
│   │
│   ├── Supabase/                             # Supabase integration
│   │   ├── SupabaseClient.swift              # Supabase client setup
│   │   ├── SupabaseAuthService.swift         # Auth implementation
│   │   ├── SupabaseDatabaseService.swift     # Database CRUD
│   │   ├── SupabaseRealtimeService.swift     # Realtime subscriptions
│   │   └── SupabaseError.swift               # Error types
│   │
│   ├── Storage/                              # Local storage
│   │   ├── LocalStorage.swift                # UserDefaults wrapper
│   │   ├── KeychainManager.swift             # Secure storage
│   │   └── CacheManager.swift                # In-memory cache
│   │
│   ├── Game/                                 # Game services
│   │   ├── GameService.swift                 # Game session CRUD
│   │   └── GameSyncService.swift             # Offline/Online sync
│   │
│   ├── Leaderboard/                          # Leaderboard services
│   │   └── LeaderboardService.swift          # Leaderboard operations
│   │
│   └── Achievement/                          # Achievement services
│       └── AchievementService.swift          # Achievement operations
│
├── 🗂 Models/                                 # Data models
│   ├── User.swift                            # User profile model
│   ├── UserSettings.swift                    # User preferences
│   ├── GameSession.swift                     # Game session model
│   ├── LeaderboardEntry.swift                # Leaderboard entry
│   ├── Achievement.swift                     # Achievement definition
│   └── UserAchievement.swift                 # User's achievement
│
├── 🎨 UI/                                     # UI components & styling
│   │
│   ├── Theme/                                # Theming system
│   │   ├── ThemeManager.swift                # Theme controller
│   │   ├── ColorPalette.swift                # Color definitions
│   │   ├── LightTheme.swift                  # Light mode colors
│   │   ├── DarkTheme.swift                   # Dark mode colors
│   │   ├── Typography.swift                  # Font styles
│   │   └── Gradients.swift                   # Gradient definitions
│   │
│   ├── Components/                           # Reusable UI components
│   │   ├── Buttons/
│   │   │   ├── PrimaryButton.swift           # Main action button
│   │   │   ├── SecondaryButton.swift         # Secondary button
│   │   │   └── IconButton.swift              # Icon-only button
│   │   │
│   │   ├── Cards/
│   │   │   ├── StatCard.swift                # Statistic card
│   │   │   └── InfoCard.swift                # Information card
│   │   │
│   │   ├── Loading/
│   │   │   ├── LoadingView.swift             # Loading spinner
│   │   │   └── SkeletonView.swift            # Skeleton loader
│   │   │
│   │   └── Common/
│   │       ├── HeaderView.swift              # Section header
│   │       ├── DividerView.swift             # Custom divider
│   │       └── BadgeView.swift               # Notification badge
│   │
│   └── Animations/                           # Animation system
│       ├── ParticleSystem.swift              # Particle emitter
│       ├── LineBreakAnimation.swift          # Line clear effect
│       ├── TetrisAnimation.swift             # Tetris clear effect
│       ├── GameOverAnimation.swift           # Game over sequence
│       └── AnimationHelpers.swift            # Animation utilities
│
├── 🔧 Utilities/                              # Helper classes & extensions
│   │
│   ├── Extensions/                           # Swift extensions
│   │   ├── Color+Extensions.swift            # Color helpers
│   │   ├── View+Extensions.swift             # SwiftUI view helpers
│   │   ├── String+Extensions.swift           # String utilities
│   │   ├── Date+Extensions.swift             # Date formatting
│   │   └── Array+Extensions.swift            # Array utilities
│   │
│   ├── Helpers/                              # Helper classes
│   │   ├── NetworkMonitor.swift              # Network status
│   │   ├── DeviceInfo.swift                  # Device capabilities
│   │   └── Validator.swift                   # Input validation
│   │
│   └── Constants/                            # App constants
│       ├── AppConstants.swift                # General constants
│       ├── GameConstants.swift               # Game-specific values
│       └── APIConstants.swift                # API endpoints
│
├── 📦 Resources/                              # App resources
│   │
│   ├── Assets.xcassets/                      # Asset catalog
│   │   ├── AppIcon.appiconset/               # App icons
│   │   ├── Colors/                           # Color assets
│   │   ├── Images/                           # Image assets
│   │   └── Achievements/                     # Achievement icons
│   │
│   ├── Sounds/                               # Sound effects
│   │   ├── move.wav                          # Move sound
│   │   ├── rotate.wav                        # Rotate sound
│   │   ├── drop.wav                          # Drop sound
│   │   ├── line_clear.wav                    # Line clear sound
│   │   ├── tetris.wav                        # Tetris sound
│   │   ├── achievement.wav                   # Achievement unlock
│   │   └── game_over.wav                     # Game over sound
│   │
│   ├── Music/                                # Background music
│   │   └── background_theme.mp3              # Main theme
│   │
│   └── Fonts/                                # Custom fonts (if any)
│       └── CustomFont.ttf
│
├── 🧪 Tests/                                  # Test suite
│   │
│   ├── UnitTests/                            # Unit tests
│   │   ├── GameEngineTests.swift             # Game logic tests
│   │   ├── TetrominoTests.swift              # Piece tests
│   │   ├── BoardTests.swift                  # Board tests
│   │   ├── ScoreManagerTests.swift           # Score calculation tests
│   │   └── PieceGeneratorTests.swift         # Randomizer tests
│   │
│   ├── IntegrationTests/                     # Integration tests
│   │   ├── SupabaseAuthTests.swift           # Auth flow tests
│   │   ├── DatabaseTests.swift               # Database operations
│   │   └── RealtimeTests.swift               # Realtime subscriptions
│   │
│   └── UITests/                              # UI tests
│       ├── GameFlowTests.swift               # Main game flow
│       ├── AuthFlowTests.swift               # Login/signup flow
│       └── NavigationTests.swift             # Screen transitions
│
├── 🗄 Database/                               # Database-related files
│   ├── Migrations/                           # SQL migration files
│   │   ├── 001_create_users.sql              # Users table
│   │   ├── 002_create_game_sessions.sql      # Game sessions
│   │   ├── 003_create_leaderboard.sql        # Leaderboard
│   │   ├── 004_create_achievements.sql       # Achievements
│   │   ├── 005_setup_rls.sql                 # Row level security
│   │   ├── 006_create_views.sql              # Database views
│   │   ├── 007_setup_realtime.sql            # Realtime config
│   │   └── 008_cleanup_functions.sql         # Maintenance functions
│   │
│   └── Seeds/                                # Seed data
│       └── achievements_seed.sql             # Achievement data
│
├── 📝 Documentation/                          # Project documentation
│   ├── README.md                             # Project overview
│   ├── ROADMAP.md                            # Development roadmap
│   ├── ARCHITECTURE.md                       # Technical architecture
│   ├── DATABASE_SETUP.md                     # Database guide
│   ├── STRUCTURE.md                          # This file
│   ├── CHECKLIST.md                          # Development checklist
│   └── API_GUIDE.md                          # API documentation
│
├── ⚙️ Configuration/                          # Configuration files
│   ├── .gitignore                            # Git ignore rules
│   ├── .env.example                          # Environment template
│   ├── .swiftlint.yml                        # SwiftLint config
│   └── Package.swift                         # Swift Package Manager
│
└── 📄 Project Files/                          # Xcode project files
    ├── ModernTetris.xcodeproj/               # Xcode project
    ├── ModernTetris.xcworkspace/             # Workspace (if using CocoaPods)
    └── Podfile                               # CocoaPods dependencies (optional)
```

---

## 🗂 Детальное описание директорий

### 📱 App/
**Назначение**: Точка входа в приложение  
**Ключевые файлы**:
- `ModernTetrisApp.swift` - @main структура, настройка Environment Objects
- `AppDelegate.swift` - Делегат для background tasks, push notifications (будущее)
- `Info.plist` - Permissions, URL schemes, Supabase config

**Зависимости**: Импортирует все модули

---

### 🎮 Core/
**Назначение**: Независимая от UI игровая логика  
**Принцип**: Может быть перенесен в другой UI framework

#### Core/Game/
- `GameEngine.swift` - ObservableObject, управляет игровым циклом
- `TetrisBoard.swift` - Struct, представляет сетку 10×20
- `Tetromino.swift` - Enum + Struct, 7 типов фигур + позиции
- `ScoreManager.swift` - Class, расчет очков
- `PieceGenerator.swift` - Class, 7-bag алгоритм

#### Core/Audio/
- `SoundManager.swift` - Singleton, управление звуками
- `MusicPlayer.swift` - Singleton, фоновая музыка

#### Core/Haptics/
- `HapticManager.swift` - Singleton, тактильная отдача

---

### 🎯 Features/
**Назначение**: Модули с UI + бизнес-логикой  
**Паттерн**: MVVM (View → ViewModel → Service)

#### Общая структура модуля:
```
Feature/
├── Views/          # SwiftUI Views
├── ViewModels/     # ObservableObjects
├── Services/       # Business logic (опционально)
└── Models/         # Локальные модели (опционально)
```

**Модули**:
- `Auth/` - Регистрация, вход, Apple ID
- `Game/` - Основной экран игры
- `Leaderboard/` - Глобальный рейтинг
- `Profile/` - Профиль и настройки
- `Achievements/` - Достижения
- `MainMenu/` - Главное меню

---

### 🔌 Services/
**Назначение**: Взаимодействие с внешними системами  
**Паттерн**: Protocol-oriented (интерфейсы)

#### Services/Supabase/
- `SupabaseClient.swift` - Singleton, конфигурация клиента
- `SupabaseAuthService.swift` - Реализация AuthService protocol
- `SupabaseDatabaseService.swift` - CRUD операции
- `SupabaseRealtimeService.swift` - Подписки на изменения

#### Services/Storage/
- `LocalStorage.swift` - Обертка над UserDefaults
- `KeychainManager.swift` - Безопасное хранение токенов
- `CacheManager.swift` - NSCache для временных данных

#### Services/Game/
- `GameService.swift` - Сохранение/загрузка игр
- `GameSyncService.swift` - Синхронизация оффлайн/онлайн

---

### 🗂 Models/
**Назначение**: Модели данных приложения  
**Требования**: Codable, Identifiable (где нужно)

**Ключевые модели**:
- `User.swift` - Пользователь
- `GameSession.swift` - Игровая сессия
- `LeaderboardEntry.swift` - Запись в лидерборде
- `Achievement.swift` - Определение достижения
- `UserAchievement.swift` - Достижение пользователя

---

### 🎨 UI/
**Назначение**: Визуальные компоненты и стилизация

#### UI/Theme/
**Система тем**:
- `ThemeManager.swift` - @Published currentTheme, переключение
- `ColorPalette.swift` - Именованные цвета
- `LightTheme.swift` - Светлая палитра
- `DarkTheme.swift` - Темная палитра
- `Gradients.swift` - Gradient для каждого тетромино

#### UI/Components/
**Переиспользуемые компоненты**:
- Buttons/ - Кнопки разных стилей
- Cards/ - Карточки для информации
- Loading/ - Индикаторы загрузки
- Common/ - Общие элементы

#### UI/Animations/
**Анимационная система**:
- `ParticleSystem.swift` - Система частиц
- `LineBreakAnimation.swift` - Эффект очистки линии
- `TetrisAnimation.swift` - Эффект тетриса
- Использует SwiftUI animations + CALayer где нужно

---

### 🔧 Utilities/
**Назначение**: Вспомогательные инструменты

#### Utilities/Extensions/
Swift расширения для удобства:
```swift
// Color+Extensions.swift
extension Color {
    static var customPrimary: Color { ... }
    init(hex: String) { ... }
}

// View+Extensions.swift
extension View {
    func shimmer() -> some View { ... }
}
```

#### Utilities/Helpers/
- `NetworkMonitor.swift` - Отслеживание подключения
- `DeviceInfo.swift` - Информация об устройстве
- `Validator.swift` - Валидация email, nickname

#### Utilities/Constants/
- `AppConstants.swift` - Версия, названия
- `GameConstants.swift` - Размеры поля, скорость
- `APIConstants.swift` - Endpoints (если нужно)

---

### 📦 Resources/
**Назначение**: Медиа и ресурсы приложения

#### Assets.xcassets/
Организация:
```
Assets.xcassets/
├── AppIcon.appiconset/      # Все размеры иконок
├── Colors/                  # Именованные цвета
│   ├── Primary.colorset
│   ├── Background.colorset
│   └── ...
├── Images/                  # Картинки
└── Achievements/            # Иконки достижений (16 файлов)
```

#### Sounds/
7 WAV файлов для звуковых эффектов

#### Music/
MP3 файл фоновой музыки

---

### 🧪 Tests/
**Назначение**: Автоматизированное тестирование  
**Target**: 70%+ coverage

#### UnitTests/
Тестируют изолированную логику:
- Движение фигур
- Коллизии
- Подсчет очков
- Генерация фигур

#### IntegrationTests/
Тестируют интеграции:
- Supabase Auth
- Database queries
- Realtime subscriptions

#### UITests/
End-to-end тесты:
- Полный игровой флоу
- Авторизация
- Навигация

---

### 🗄 Database/
**Назначение**: SQL миграции и seeds

#### Migrations/
8 файлов миграций в порядке выполнения

#### Seeds/
Начальные данные (16 достижений)

---

## 📊 Зависимости между модулями

```
┌──────────────────────────────────────┐
│              App Layer               │
│        (ModernTetrisApp)             │
└──────────────────────────────────────┘
                  ↓
┌──────────────────────────────────────┐
│           Feature Modules            │
│  (Auth, Game, Leaderboard, etc.)     │
└──────────────────────────────────────┘
         ↓              ↓
┌─────────────┐   ┌──────────────┐
│   Core      │   │   Services   │
│  (Engine)   │   │  (Supabase)  │
└─────────────┘   └──────────────┘
         ↓              ↓
┌──────────────────────────────────────┐
│         Models & Utilities           │
└──────────────────────────────────────┘
```

### Правила зависимостей:
1. **App** зависит от Features
2. **Features** зависят от Core, Services, Models, UI
3. **Core** НЕ зависит от Features (независимая логика)
4. **Services** зависят только от Models
5. **Models** не зависят ни от чего (pure data)
6. **UI** зависит только от Theme
7. **Utilities** используются везде

---

## 🔨 Создание нового файла - чеклист

### Создаем новый View:
1. Определить в какой Feature он относится
2. Создать в `Features/{FeatureName}/Views/`
3. Именование: `{Purpose}View.swift`
4. Импорты: `import SwiftUI`
5. Использовать `@EnvironmentObject` для общих сервисов
6. Применить Theme через `@EnvironmentObject var theme: ThemeManager`

### Создаем новый ViewModel:
1. Создать в `Features/{FeatureName}/ViewModels/`
2. Именование: `{Purpose}ViewModel.swift`
3. Наследование: `class XViewModel: ObservableObject`
4. Использовать `@Published` для UI state
5. Инжектить Services через init()

### Создаем новый Service:
1. Создать protocol в `Services/`
2. Создать implementation в соответствующей папке
3. Именование: `{Purpose}Service.swift`
4. Protocol: методы async throws
5. Mock для тестов

### Создаем новую Model:
1. Создать в `Models/`
2. Struct (по возможности)
3. Conformance: `Identifiable, Codable`
4. CodingKeys если нужно переименование полей

---

## 🎯 Naming Conventions

### Files:
- Views: `{Purpose}View.swift` (GameView, LoginView)
- ViewModels: `{Purpose}ViewModel.swift`
- Services: `{Purpose}Service.swift`
- Models: `{Entity}.swift` (User.swift, Achievement.swift)
- Extensions: `{Type}+Extensions.swift`

### Classes/Structs:
- PascalCase: `GameEngine`, `ThemeManager`
- Views: суффикс `View`
- ViewModels: суффикс `ViewModel`

### Variables:
- camelCase: `currentUser`, `bestScore`
- Bool: префиксы `is`, `has`, `should`
- Collections: множественное число

### Functions:
- camelCase: `startGame()`, `updateLeaderboard()`
- Actions: глагол + существительное

---

## 📐 Размеры и стандарты

### Spacing:
- Extra Small: 4pt
- Small: 8pt
- Medium: 16pt
- Large: 24pt
- Extra Large: 32pt

### Corner Radius:
- Small: 8pt
- Medium: 12pt
- Large: 16pt

### Font Sizes:
- Caption: 12pt
- Body: 16pt
- Title: 20pt
- Large Title: 28pt

---

## 🔍 Quick Reference - Где что находится?

**Нужно добавить новый цвет?**  
→ `UI/Theme/ColorPalette.swift`

**Нужно изменить размер поля?**  
→ `Utilities/Constants/GameConstants.swift`

**Нужно добавить звук?**  
→ `Resources/Sounds/` + обновить `Core/Audio/SoundManager.swift`

**Нужно добавить достижение?**  
→ `Database/Seeds/achievements_seed.sql`

**Нужно изменить логику подсчета очков?**  
→ `Core/Game/ScoreManager.swift`

**Нужно добавить новый экран?**  
→ Создать в `Features/{NewFeature}/Views/`

**Нужно добавить API endpoint?**  
→ Обновить Service в `Services/`

**Нужно добавить тест?**  
→ `Tests/{UnitTests|IntegrationTests|UITests}/`

---

## ✅ Best Practices

### 1. Организация кода:
- 1 компонент = 1 файл
- Максимум 300 строк на файл
- Группировать по функциональности, не по типу

### 2. SwiftUI Views:
- Извлекать в subviews при >100 строках
- Использовать ViewBuilder для условной логики
- Preferenc`e` GeometryReader где нужно

### 3. State Management:
- @State для локального UI state
- @StateObject для owned objects
- @ObservedObject для passed objects
- @EnvironmentObject для глобального state

### 4. Асинхронность:
- Использовать async/await
- MainActor для UI updates
- Task для фоновых операций

### 5. Тестирование:
- Unit tests для чистой логики
- Integration tests для сервисов
- UI tests для критичных флоу

---

**Structure Version**: 1.0  
**Last Updated**: Январь 2026  
**Maintained by**: Development Team