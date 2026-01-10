//
//  AudioManager.swift
//  SamoTetris
//
//  Created on 2026-01-07
//

import AVFoundation
import Combine

/// Manages all audio playback (sound effects and music)
class AudioManager: ObservableObject {
    static let shared = AudioManager()

    private var soundPlayers: [String: AVAudioPlayer] = [:]
    // Pool of players for frequently used sounds to avoid delays
    private var lockSoundPool: [AVAudioPlayer] = []
    private var moveSoundPool: [AVAudioPlayer] = []
    private var rotateSoundPool: [AVAudioPlayer] = []
    private var clickSoundPool: [AVAudioPlayer] = []
    private var currentLockIndex = 0
    private var currentMoveIndex = 0
    private var currentRotateIndex = 0
    private var currentClickIndex = 0
    private var musicPlayer: AVAudioPlayer?
    private var cancellables = Set<AnyCancellable>()

    @Published var soundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        }
    }

    @Published var musicEnabled: Bool {
        didSet {
            UserDefaults.standard.set(musicEnabled, forKey: "musicEnabled")
            if musicEnabled {
                playMusic()
            } else {
                stopMusic()
            }
        }
    }

    private init() {
        // Load settings - default to true if not set
        let hasLaunchedBefore = UserDefaults.standard.object(forKey: "soundEnabled") != nil
        self.soundEnabled = hasLaunchedBefore ? UserDefaults.standard.bool(forKey: "soundEnabled") : true
        self.musicEnabled = hasLaunchedBefore ? UserDefaults.standard.bool(forKey: "musicEnabled") : true

        setupAudioSession()
        preloadSounds()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    // MARK: - Sound Effects

    /// Preload all sound effects into memory for instant playback
    private func preloadSounds() {
        let soundNames = [
            "move",
            "rotate",
            "lock",
            "line_clear",
            "tetris",
            "game_over",
            "hold",
            "button_click"
        ]

        for soundName in soundNames {
            // Try different paths and extensions
            let possiblePaths = [
                "Sounds/\(soundName)",
                "Resources/Sounds/\(soundName)",
                soundName
            ]
            let extensions = ["m4a", "mp3"]

            var loaded = false
            for baseName in possiblePaths {
                for ext in extensions {
                    if let url = Bundle.main.url(forResource: baseName, withExtension: ext) {
                        do {
                            let player = try AVAudioPlayer(contentsOf: url)
                            player.volume = 0.3  // 30% volume for sound effects
                            player.prepareToPlay()
                            soundPlayers[soundName] = player
                            loaded = true
                            print("Loaded sound: \(soundName) from \(baseName).\(ext)")

                            // Create pools for frequently used sounds (3 instances each)
                            if soundName == "lock" {
                                for _ in 0..<3 {
                                    if let poolPlayer = try? AVAudioPlayer(contentsOf: url) {
                                        poolPlayer.volume = 0.3
                                        poolPlayer.prepareToPlay()
                                        lockSoundPool.append(poolPlayer)
                                    }
                                }
                            } else if soundName == "move" {
                                for _ in 0..<3 {
                                    if let poolPlayer = try? AVAudioPlayer(contentsOf: url) {
                                        poolPlayer.volume = 0.3
                                        poolPlayer.prepareToPlay()
                                        moveSoundPool.append(poolPlayer)
                                    }
                                }
                            } else if soundName == "rotate" {
                                for _ in 0..<3 {
                                    if let poolPlayer = try? AVAudioPlayer(contentsOf: url) {
                                        poolPlayer.volume = 0.3
                                        poolPlayer.prepareToPlay()
                                        rotateSoundPool.append(poolPlayer)
                                    }
                                }
                            } else if soundName == "button_click" {
                                for _ in 0..<3 {
                                    if let poolPlayer = try? AVAudioPlayer(contentsOf: url) {
                                        poolPlayer.volume = 0.3
                                        poolPlayer.prepareToPlay()
                                        clickSoundPool.append(poolPlayer)
                                    }
                                }
                            }

                            break
                        } catch {
                            print("Failed to load sound \(soundName) from \(baseName).\(ext): \(error)")
                        }
                    }
                }
                if loaded { break }
            }

            if !loaded {
                print("Sound \(soundName) not found in any location")
            }
        }
    }

    func playSound(_ soundName: String) {
        guard soundEnabled else { return }

        guard let player = soundPlayers[soundName] else {
            print("Sound \(soundName) not found")
            return
        }

        player.currentTime = 0
        player.play()
    }

    // MARK: - Music

    private func playMusic() {
        guard musicEnabled else { return }

        // Try different paths and extensions for music
        let possiblePaths = [
            "Music/background_music",
            "Resources/Music/background_music",
            "background_music"
        ]
        let extensions = ["m4a", "mp3"]

        var url: URL?
        for baseName in possiblePaths {
            for ext in extensions {
                if let foundUrl = Bundle.main.url(forResource: baseName, withExtension: ext) {
                    url = foundUrl
                    print("Found music at: \(baseName).\(ext)")
                    break
                }
            }
            if url != nil { break }
        }

        guard let musicUrl = url else {
            print("Background music file not found in any location")
            return
        }

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: musicUrl)
            musicPlayer?.numberOfLoops = -1 // Loop forever
            musicPlayer?.volume = 0.3
            musicPlayer?.prepareToPlay()
            musicPlayer?.play()
        } catch {
            print("Failed to play music: \(error)")
        }
    }

    private func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }

    // MARK: - Public Methods

    func pieceMoved() {
        guard soundEnabled else { return }
        guard !moveSoundPool.isEmpty else {
            playSound("move")
            return
        }

        let player = moveSoundPool[currentMoveIndex]
        player.stop()
        player.currentTime = 0
        player.play()
        currentMoveIndex = (currentMoveIndex + 1) % moveSoundPool.count
    }

    func pieceRotated() {
        guard soundEnabled else { return }
        guard !rotateSoundPool.isEmpty else {
            playSound("rotate")
            return
        }

        let player = rotateSoundPool[currentRotateIndex]
        player.stop()
        player.currentTime = 0
        player.play()
        currentRotateIndex = (currentRotateIndex + 1) % rotateSoundPool.count
    }

    func pieceLocked() {
        guard soundEnabled else { return }
        guard !lockSoundPool.isEmpty else {
            playSound("lock")
            return
        }

        let player = lockSoundPool[currentLockIndex]
        player.stop()
        player.currentTime = 0
        player.play()
        currentLockIndex = (currentLockIndex + 1) % lockSoundPool.count
    }

    func lineCleared() {
        playSound("line_clear")
    }

    func tetris() {
        playSound("tetris")
    }

    func gameOver() {
        playSound("game_over")
    }

    func pieceHeld() {
        playSound("hold")
    }

    func buttonClick() {
        guard soundEnabled else { return }
        guard !clickSoundPool.isEmpty else {
            playSound("button_click")
            return
        }

        let player = clickSoundPool[currentClickIndex]
        player.stop()
        player.currentTime = 0
        player.play()
        currentClickIndex = (currentClickIndex + 1) % clickSoundPool.count
    }

    /// Start background music (called when app launches)
    func startBackgroundMusic() {
        if musicEnabled {
            playMusic()
        }
    }
}
