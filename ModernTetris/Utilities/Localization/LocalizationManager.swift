//
//  LocalizationManager.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import SwiftUI

/// Supported languages
enum AppLanguage: String, CaseIterable, Hashable {
    case english = "English"
    case russian = "Русский"
    case french = "Français"

    var code: String {
        switch self {
        case .english: return "en"
        case .russian: return "ru"
        case .french: return "fr"
        }
    }
}

/// Localized strings
struct LocalizedStrings {
    static var current: LocalizedStrings {
        let langCode = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        let language = AppLanguage.allCases.first { $0.code == langCode } ?? .english
        return LocalizedStrings(language: language)
    }

    private let language: AppLanguage

    private init(language: AppLanguage) {
        self.language = language
    }

    // MARK: - Main Menu

    var appTitle: String {
        return "SAMOTETRIS"
    }

    var play: String {
        switch language {
        case .english: return "PLAY"
        case .russian: return "ИГРАТЬ"
        case .french: return "JOUER"
        }
    }

    var leaderboard: String {
        switch language {
        case .english: return "LEADERBOARD"
        case .russian: return "ТАБЛИЦА ЛИДЕРОВ"
        case .french: return "CLASSEMENT"
        }
    }

    var settings: String {
        switch language {
        case .english: return "SETTINGS"
        case .russian: return "НАСТРОЙКИ"
        case .french: return "PARAMÈTRES"
        }
    }

    var version: String {
        switch language {
        case .english: return "v1.0.0"
        case .russian: return "версия 1.0.0"
        case .french: return "v1.0.0"
        }
    }

    // MARK: - Settings

    var theme: String {
        switch language {
        case .english: return "THEME"
        case .russian: return "ТЕМА"
        case .french: return "THÈME"
        }
    }

    var languageLabel: String {
        switch language {
        case .english: return "LANGUAGE"
        case .russian: return "ЯЗЫК"
        case .french: return "LANGUE"
        }
    }

    var audio: String {
        switch language {
        case .english: return "AUDIO"
        case .russian: return "ЗВУК"
        case .french: return "AUDIO"
        }
    }

    var soundEffects: String {
        switch language {
        case .english: return "Sound Effects"
        case .russian: return "Звуковые эффекты"
        case .french: return "Effets sonores"
        }
    }

    var music: String {
        switch language {
        case .english: return "Music"
        case .russian: return "Музыка"
        case .french: return "Musique"
        }
    }

    var gameplay: String {
        switch language {
        case .english: return "GAMEPLAY"
        case .russian: return "ИГРА"
        case .french: return "JEU"
        }
    }

    var hapticFeedback: String {
        switch language {
        case .english: return "Haptic Feedback"
        case .russian: return "Вибрация"
        case .french: return "Retour haptique"
        }
    }

    var ghostPiece: String {
        switch language {
        case .english: return "Ghost Piece"
        case .russian: return "Тень фигуры"
        case .french: return "Pièce fantôme"
        }
    }

    var about: String {
        switch language {
        case .english: return "ABOUT"
        case .russian: return "О ПРИЛОЖЕНИИ"
        case .french: return "À PROPOS"
        }
    }

    var versionLabel: String {
        switch language {
        case .english: return "Version"
        case .russian: return "Версия"
        case .french: return "Version"
        }
    }

    var developer: String {
        switch language {
        case .english: return "Developer"
        case .russian: return "Разработчик"
        case .french: return "Développeur"
        }
    }

    var done: String {
        switch language {
        case .english: return "Done"
        case .russian: return "Готово"
        case .french: return "Terminé"
        }
    }

    // MARK: - Game

    var score: String {
        switch language {
        case .english: return "SCORE"
        case .russian: return "СЧЁТ"
        case .french: return "SCORE"
        }
    }

    var lines: String {
        switch language {
        case .english: return "LINES"
        case .russian: return "ЛИНИИ"
        case .french: return "LIGNES"
        }
    }

    var tetris: String {
        switch language {
        case .english: return "TETRIS"
        case .russian: return "ТЕТРИС"
        case .french: return "TETRIS"
        }
    }

    var hold: String {
        switch language {
        case .english: return "HOLD"
        case .russian: return "ЗАПАС"
        case .french: return "RÉSERVE"
        }
    }

    var next: String {
        switch language {
        case .english: return "NEXT"
        case .russian: return "ДАЛЕЕ"
        case .french: return "SUIVANT"
        }
    }

    var controls: String {
        switch language {
        case .english: return "CONTROLS"
        case .russian: return "УПРАВЛЕНИЕ"
        case .french: return "CONTRÔLES"
        }
    }

    var swipeLeftRight: String {
        switch language {
        case .english: return "Swipe Left/Right - Move"
        case .russian: return "Свайп влево/вправо - Движение"
        case .french: return "Glisser gauche/droite - Déplacer"
        }
    }

    var swipeDown: String {
        switch language {
        case .english: return "Swipe Down - Soft Drop"
        case .russian: return "Свайп вниз - Быстрое падение"
        case .french: return "Glisser bas - Chute douce"
        }
    }

    var tap: String {
        switch language {
        case .english: return "Tap - Rotate"
        case .russian: return "Тап - Поворот"
        case .french: return "Toucher - Rotation"
        }
    }

    var longPress: String {
        switch language {
        case .english: return "Long Press - Hard Drop"
        case .russian: return "Долгое нажатие - Сброс"
        case .french: return "Appui long - Chute rapide"
        }
    }

    var doubleTap: String {
        switch language {
        case .english: return "Double Tap - Hold Piece"
        case .russian: return "Двойной тап - Отложить фигуру"
        case .french: return "Double toucher - Retenir pièce"
        }
    }

    var startBattle: String {
        switch language {
        case .english: return "START GAME"
        case .russian: return "НАЧАТЬ ИГРУ"
        case .french: return "COMMENCER LE JEU"
        }
    }

    var defeated: String {
        switch language {
        case .english: return "DEFEATED"
        case .russian: return "ПОРАЖЕНИЕ"
        case .french: return "DÉFAITE"
        }
    }

    var finalScore: String {
        switch language {
        case .english: return "Final Score:"
        case .russian: return "Финальный счёт:"
        case .french: return "Score final:"
        }
    }

    var playAgain: String {
        switch language {
        case .english: return "PLAY AGAIN"
        case .russian: return "ИГРАТЬ СНОВА"
        case .french: return "REJOUER"
        }
    }

    var mainMenu: String {
        switch language {
        case .english: return "MAIN MENU"
        case .russian: return "ГЛАВНОЕ МЕНЮ"
        case .french: return "MENU PRINCIPAL"
        }
    }

    var paused: String {
        switch language {
        case .english: return "PAUSED"
        case .russian: return "ПАУЗА"
        case .french: return "PAUSE"
        }
    }

    var resume: String {
        switch language {
        case .english: return "RESUME"
        case .russian: return "ПРОДОЛЖИТЬ"
        case .french: return "REPRENDRE"
        }
    }

    // MARK: - Leaderboard

    var personal: String {
        switch language {
        case .english: return "Personal"
        case .russian: return "Личные"
        case .french: return "Personnel"
        }
    }

    var global: String {
        switch language {
        case .english: return "Global"
        case .russian: return "Глобальные"
        case .french: return "Global"
        }
    }

    var highScore: String {
        switch language {
        case .english: return "High Score"
        case .russian: return "Лучший счёт"
        case .french: return "Meilleur score"
        }
    }

    var games: String {
        switch language {
        case .english: return "Games"
        case .russian: return "Игры"
        case .french: return "Parties"
        }
    }

    var achievements: String {
        switch language {
        case .english: return "ACHIEVEMENTS"
        case .russian: return "ДОСТИЖЕНИЯ"
        case .french: return "SUCCÈS"
        }
    }

    var comingSoon: String {
        switch language {
        case .english: return "Coming Soon"
        case .russian: return "Скоро"
        case .french: return "Bientôt"
        }
    }

    var globalLeaderboardMessage: String {
        switch language {
        case .english: return "Global leaderboard will be available\nwhen connected to Supabase"
        case .russian: return "Глобальная таблица лидеров будет доступна\nпри подключении к Supabase"
        case .french: return "Le classement global sera disponible\nune fois connecté à Supabase"
        }
    }

    // MARK: - Achievements

    var firstVictory: String {
        switch language {
        case .english: return "First Victory"
        case .russian: return "Первая победа"
        case .french: return "Première victoire"
        }
    }

    var firstVictoryDesc: String {
        switch language {
        case .english: return "Complete your first game"
        case .russian: return "Завершите первую игру"
        case .french: return "Terminez votre premier jeu"
        }
    }

    var lineMaster: String {
        switch language {
        case .english: return "Line Master"
        case .russian: return "Мастер линий"
        case .french: return "Maître des lignes"
        }
    }

    var lineMasterDesc: String {
        switch language {
        case .english: return "Clear 100 lines"
        case .russian: return "Очистите 100 линий"
        case .french: return "Effacez 100 lignes"
        }
    }

    var speedDemon: String {
        switch language {
        case .english: return "Speed Demon"
        case .russian: return "Скоростной демон"
        case .french: return "Démon de vitesse"
        }
    }

    var speedDemonDesc: String {
        switch language {
        case .english: return "Score 1000 points"
        case .russian: return "Наберите 1000 очков"
        case .french: return "Marquez 1000 points"
        }
    }

    // MARK: - Shop

    var shop: String {
        switch language {
        case .english: return "SHOP"
        case .russian: return "МАГАЗИН"
        case .french: return "BOUTIQUE"
        }
    }

    var coins: String {
        switch language {
        case .english: return "Coins"
        case .russian: return "Монет"
        case .french: return "Pièces"
        }
    }

    var purchase: String {
        switch language {
        case .english: return "Purchase"
        case .russian: return "Купить"
        case .french: return "Acheter"
        }
    }

    var purchased: String {
        switch language {
        case .english: return "Purchased"
        case .russian: return "Куплено"
        case .french: return "Acheté"
        }
    }

    var equip: String {
        switch language {
        case .english: return "Equip"
        case .russian: return "Экипировать"
        case .french: return "Équiper"
        }
    }

    var equipped: String {
        switch language {
        case .english: return "Equipped"
        case .russian: return "Экипировано"
        case .french: return "Équipé"
        }
    }

    var remove: String {
        switch language {
        case .english: return "Remove"
        case .russian: return "Снять"
        case .french: return "Retirer"
        }
    }

    var notEnoughCoins: String {
        switch language {
        case .english: return "Not enough coins!"
        case .russian: return "Недостаточно монет!"
        case .french: return "Pas assez de pièces!"
        }
    }

    var particleEffects: String {
        switch language {
        case .english: return "Particle Effects"
        case .russian: return "Эффекты частиц"
        case .french: return "Effets de particules"
        }
    }

    var boardFrames: String {
        switch language {
        case .english: return "Board Frames"
        case .russian: return "Рамки поля"
        case .french: return "Cadres de plateau"
        }
    }

    func particleEffectDescription(_ effect: ParticleEffect) -> String {
        switch effect {
        case .stars:
            switch language {
            case .english: return "Shimmering stars burst when clearing lines"
            case .russian: return "Мерцающие звезды при очистке линий"
            case .french: return "Des étoiles scintillantes apparaissent"
            }
        case .confetti:
            switch language {
            case .english: return "Colorful confetti celebrates your success"
            case .russian: return "Цветное конфетти отмечает успех"
            case .french: return "Des confettis colorés célèbrent"
            }
        case .lightning:
            switch language {
            case .english: return "Electric lightning strikes lines"
            case .russian: return "Молнии бьют по линиям"
            case .french: return "Éclairs frappent les lignes"
            }
        case .fire:
            switch language {
            case .english: return "Blazing fire burns through lines"
            case .russian: return "Огонь сжигает линии"
            case .french: return "Feu brûle les lignes"
            }
        case .hearts:
            switch language {
            case .english: return "Hearts float up with love"
            case .russian: return "Сердечки взмывают вверх"
            case .french: return "Cœurs s'envolent"
            }
        case .sparkles:
            switch language {
            case .english: return "Magical sparkles light up board"
            case .russian: return "Искры освещают поле"
            case .french: return "Étincelles illuminent plateau"
            }
        }
    }

    func boardFrameDescription(_ frame: BoardFrame) -> String {
        switch frame {
        case .classic:
            switch language {
            case .english: return "Simple elegant frame"
            case .russian: return "Простая элегантная рамка"
            case .french: return "Cadre élégant simple"
            }
        case .golden:
            switch language {
            case .english: return "Luxurious golden frame for champions"
            case .russian: return "Золотая рамка для чемпионов"
            case .french: return "Cadre doré pour champions"
            }
        case .neon:
            switch language {
            case .english: return "Vibrant neon glow around board"
            case .russian: return "Неоновое свечение вокруг поля"
            case .french: return "Lueur néon autour du plateau"
            }
        case .wooden:
            switch language {
            case .english: return "Classic carved wooden frame"
            case .russian: return "Резная деревянная рамка"
            case .french: return "Cadre en bois sculpté"
            }
        case .crystal:
            switch language {
            case .english: return "Sparkling crystal border"
            case .russian: return "Кристаллическая граница"
            case .french: return "Bordure en cristal"
            }
        }
    }

    var coinsEarned: String {
        switch language {
        case .english: return "Coins Earned"
        case .russian: return "Монет заработано"
        case .french: return "Pièces gagnées"
        }
    }

    func themeDescription(_ theme: GameTheme) -> String {
        switch theme {
        case .viking:
            switch language {
            case .english: return "Norse saga with gold and ice blue"
            case .russian: return "Скандинавская сага с золотом"
            case .french: return "Saga nordique or et bleu glacé"
            }
        case .neon:
            switch language {
            case .english: return "Cyberpunk with vibrant neon colors"
            case .russian: return "Киберпанк с неоновыми цветами"
            case .french: return "Cyberpunk avec couleurs néon"
            }
        case .metal:
            switch language {
            case .english: return "Industrial chrome with metal shimmer"
            case .russian: return "Индустриальный хром с блеском"
            case .french: return "Chrome industriel métallique"
            }
        case .noir:
            switch language {
            case .english: return "Classic black and white aesthetic"
            case .russian: return "Черно-белая эстетика"
            case .french: return "Esthétique noir et blanc"
            }
        }
    }

    var themes: String {
        switch language {
        case .english: return "Themes"
        case .russian: return "Темы"
        case .french: return "Thèmes"
        }
    }
}
