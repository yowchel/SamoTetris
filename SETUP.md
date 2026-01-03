# SamoTetris - Setup Instructions

## Создание Xcode проекта

Так как мы создали структуру кода без Xcode проекта, вам нужно создать проект вручную:

### Шаг 1: Создание проекта в Xcode

1. Откройте Xcode
2. File → New → Project
3. Выберите **iOS** → **App**
4. Настройки:
   - **Product Name**: SamoTetris
   - **Team**: Ваш Apple Developer team
   - **Organization Identifier**: com.yourname (или ваш)
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Storage**: None
   - **Include Tests**: Yes
5. Сохраните в папку `/Users/yanashevchuk/Documents/SamoTetris` (выберите эту существующую папку)
6. Xcode предупредит что папка не пуста - это нормально, продолжайте

### Шаг 2: Добавление файлов в проект

После создания проекта:

1. Удалите автоматически созданный файл `ContentView.swift` (он не нужен)
2. В Xcode, в Navigator (левая панель), щелкните правой кнопкой на папке `SamoTetris`
3. Выберите "Add Files to SamoTetris..."
4. Выберите папку `ModernTetris` и все её содержимое
5. Убедитесь что включена опция "Create groups" (не "Create folder references")
6. Нажмите "Add"

### Шаг 3: Настройка проекта

1. Выберите проект в Navigator
2. В Target Settings:
   - **Deployment Target**: iOS 15.0
   - **Supported Destinations**: iPhone
   - **Device Orientation**: Portrait (отключите Landscape)

### Шаг 4: Структура файлов

После добавления файлы должны быть организованы так:

```
SamoTetris (Xcode Project)
├── App
│   └── SamoTetrisApp.swift
├── Core
│   └── Game
│       ├── GameEngine.swift
│       ├── GameState.swift
│       ├── PieceGenerator.swift
│       ├── Position.swift
│       ├── ScoreManager.swift
│       ├── TetrisBoard.swift
│       ├── Tetromino.swift
│       └── TetrominoType.swift
├── Features
│   └── Game
│       ├── Components
│       │   ├── BoardView.swift
│       │   ├── HoldPieceView.swift
│       │   └── NextPieceView.swift
│       ├── ViewModels
│       │   └── GameViewModel.swift
│       └── Views
│           └── GameView.swift
├── UI
│   ├── Components
│   │   └── BlockView.swift
│   └── Theme
│       └── AppColor.swift
└── Utilities
    └── Constants
        └── GameConstants.swift
```

### Шаг 5: Запуск

1. Выберите симулятор iPhone (например, iPhone 15)
2. Нажмите ⌘R (Command + R) или кнопку Play
3. Игра должна запуститься!

## Управление

- **Свайп влево/вправо** - перемещение фигуры
- **Свайп вниз** - мягкое падение (soft drop)
- **Тап** - поворот фигуры
- **Долгое нажатие** - мгновенное падение (hard drop)
- **Двойной тап** - отложить фигуру (hold)

## Что уже реализовано

✅ Полная игровая механика Тетриса
✅ 10×20 игровое поле
✅ 7 стандартных фигур с поворотами
✅ 7-bag рандомайзер (честная генерация)
✅ Система подсчета очков
✅ Hold функция
✅ Превью следующих 3 фигур
✅ Управление жестами
✅ Пауза/возобновление
✅ Game Over
✅ Подсчет линий и Тетрисов

## Следующие шаги

Смотрите [checklist.md](checklist.md) для полного плана разработки.

Следующие фазы:
- Phase 2: Аутентификация (Supabase)
- Phase 3: Дизайн и анимации
- Phase 4: Глобальный лидерборд
- Phase 5: Система достижений
- Phase 6: Полировка и релиз

## Troubleshooting

**Ошибка компиляции**: Убедитесь что все файлы добавлены в Target Membership (в Inspector справа)

**Файлы не видны**: Проверьте что выбрали "Create groups", а не "Create folder references"

**Проект не запускается**: Убедитесь что выбран правильный Target (SamoTetris) и симулятор iPhone
