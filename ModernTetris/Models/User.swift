//
//  User.swift
//  SamoTetris
//
//  Created on 2026-01-12
//

import Foundation

/// User model representing authenticated user
struct User: Codable, Identifiable {
    let id: String
    var email: String?
    var nickname: String
    var avatarUrl: String?
    var isAnonymous: Bool
    var createdAt: Date
    var updatedAt: Date

    // Game statistics
    var totalGames: Int
    var totalScore: Int
    var totalLines: Int
    var highScore: Int
    var bestTetris: Int

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case nickname
        case avatarUrl = "avatar_url"
        case isAnonymous = "is_anonymous"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case totalGames = "total_games"
        case totalScore = "total_score"
        case totalLines = "total_lines"
        case highScore = "high_score"
        case bestTetris = "best_tetris"
    }

    init(
        id: String,
        email: String? = nil,
        nickname: String,
        avatarUrl: String? = nil,
        isAnonymous: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        totalGames: Int = 0,
        totalScore: Int = 0,
        totalLines: Int = 0,
        highScore: Int = 0,
        bestTetris: Int = 0
    ) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.avatarUrl = avatarUrl
        self.isAnonymous = isAnonymous
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.totalGames = totalGames
        self.totalScore = totalScore
        self.totalLines = totalLines
        self.highScore = highScore
        self.bestTetris = bestTetris
    }
}

/// Auth session representing current authentication state
struct AuthSession {
    let user: User
    let accessToken: String
    let refreshToken: String?
    let expiresAt: Date
}
