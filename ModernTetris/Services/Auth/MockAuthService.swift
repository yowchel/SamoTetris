//
//  MockAuthService.swift
//  SamoTetris
//
//  Created on 2026-01-12
//

import Foundation

/// Mock authentication service for local development (without Supabase)
/// This stores users in UserDefaults and simulates authentication
class MockAuthService: AuthService {
    private let defaults = UserDefaults.standard
    private let usersKey = "mock_users"
    private let currentSessionKey = "current_session"

    func signUp(email: String, password: String, nickname: String) async throws -> AuthSession {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second

        // Validate input
        guard email.contains("@") && email.contains(".") else {
            throw AuthError.invalidEmail
        }

        guard password.count >= 6 else {
            throw AuthError.weakPassword
        }

        // Check if email already exists
        let users = getAllUsers()
        if users.contains(where: { $0.email == email }) {
            throw AuthError.emailAlreadyInUse
        }

        // Create new user
        let userId = UUID().uuidString
        let user = User(
            id: userId,
            email: email,
            nickname: nickname,
            isAnonymous: false
        )

        // Save user and password
        saveUser(user, password: password)

        // Create session
        let session = createSession(for: user)
        saveCurrentSession(session)

        return session
    }

    func signIn(email: String, password: String) async throws -> AuthSession {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)

        let users = getAllUsers()

        guard let user = users.first(where: { $0.email == email }) else {
            throw AuthError.userNotFound
        }

        // Verify password
        guard verifyPassword(password, for: user.id) else {
            throw AuthError.invalidCredentials
        }

        let session = createSession(for: user)
        saveCurrentSession(session)

        return session
    }

    func signInWithApple() async throws -> AuthSession {
        // For now, create a mock Apple user
        try await Task.sleep(nanoseconds: 500_000_000)

        let userId = "apple_\(UUID().uuidString)"
        let user = User(
            id: userId,
            nickname: "Apple User",
            isAnonymous: false
        )

        saveUser(user, password: "")

        let session = createSession(for: user)
        saveCurrentSession(session)

        return session
    }

    func signInAnonymously() async throws -> AuthSession {
        try await Task.sleep(nanoseconds: 500_000_000)

        let userId = "anon_\(UUID().uuidString)"
        let user = User(
            id: userId,
            nickname: "Guest \(Int.random(in: 1000...9999))",
            isAnonymous: true
        )

        saveUser(user, password: "")

        let session = createSession(for: user)
        saveCurrentSession(session)

        return session
    }

    func signOut() async throws {
        defaults.removeObject(forKey: currentSessionKey)
    }

    func getCurrentSession() async throws -> AuthSession? {
        guard let data = defaults.data(forKey: currentSessionKey) else {
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let sessionData = try? decoder.decode(SessionData.self, from: data) else {
            return nil
        }

        // Check if session expired
        if sessionData.expiresAt < Date() {
            throw AuthError.sessionExpired
        }

        return AuthSession(
            user: sessionData.user,
            accessToken: sessionData.accessToken,
            refreshToken: sessionData.refreshToken,
            expiresAt: sessionData.expiresAt
        )
    }

    func refreshSession() async throws -> AuthSession {
        guard let currentSession = try await getCurrentSession() else {
            throw AuthError.sessionExpired
        }

        // Create new session with extended expiry
        let newSession = createSession(for: currentSession.user)
        saveCurrentSession(newSession)

        return newSession
    }

    func linkEmailToAnonymous(email: String, password: String) async throws -> AuthSession {
        guard let currentSession = try await getCurrentSession() else {
            throw AuthError.sessionExpired
        }

        guard currentSession.user.isAnonymous else {
            throw AuthError.unknownError("User is not anonymous")
        }

        // Validate input
        guard email.contains("@") && email.contains(".") else {
            throw AuthError.invalidEmail
        }

        guard password.count >= 6 else {
            throw AuthError.weakPassword
        }

        // Check if email already exists
        let users = getAllUsers()
        if users.contains(where: { $0.email == email && $0.id != currentSession.user.id }) {
            throw AuthError.emailAlreadyInUse
        }

        // Update user
        var updatedUser = currentSession.user
        updatedUser.email = email
        updatedUser.isAnonymous = false

        // Remove old user and save updated
        removeUser(id: currentSession.user.id)
        saveUser(updatedUser, password: password)

        let newSession = createSession(for: updatedUser)
        saveCurrentSession(newSession)

        return newSession
    }

    func resetPassword(email: String) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)

        let users = getAllUsers()
        guard users.contains(where: { $0.email == email }) else {
            throw AuthError.userNotFound
        }

        // In real app, send password reset email
        print("Password reset email sent to \(email)")
    }

    func updateProfile(nickname: String?, avatarUrl: String?) async throws -> User {
        guard let currentSession = try await getCurrentSession() else {
            throw AuthError.sessionExpired
        }

        var updatedUser = currentSession.user

        if let nickname = nickname {
            updatedUser.nickname = nickname
        }

        if let avatarUrl = avatarUrl {
            updatedUser.avatarUrl = avatarUrl
        }

        updatedUser.updatedAt = Date()

        // Update saved user
        let password = getPassword(for: updatedUser.id)
        saveUser(updatedUser, password: password)

        // Update session
        let newSession = AuthSession(
            user: updatedUser,
            accessToken: currentSession.accessToken,
            refreshToken: currentSession.refreshToken,
            expiresAt: currentSession.expiresAt
        )
        saveCurrentSession(newSession)

        return updatedUser
    }

    // MARK: - Private Helpers

    private func getAllUsers() -> [User] {
        guard let data = defaults.data(forKey: usersKey) else {
            return []
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return (try? decoder.decode([User].self, from: data)) ?? []
    }

    private func saveUser(_ user: User, password: String) {
        var users = getAllUsers()

        // Remove existing user with same ID
        users.removeAll { $0.id == user.id }
        users.append(user)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        if let data = try? encoder.encode(users) {
            defaults.set(data, forKey: usersKey)
        }

        // Save password separately
        defaults.set(password, forKey: "password_\(user.id)")
    }

    private func removeUser(id: String) {
        var users = getAllUsers()
        users.removeAll { $0.id == id }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        if let data = try? encoder.encode(users) {
            defaults.set(data, forKey: usersKey)
        }

        defaults.removeObject(forKey: "password_\(id)")
    }

    private func getPassword(for userId: String) -> String {
        return defaults.string(forKey: "password_\(userId)") ?? ""
    }

    private func verifyPassword(_ password: String, for userId: String) -> Bool {
        let storedPassword = getPassword(for: userId)
        return password == storedPassword
    }

    private func createSession(for user: User) -> AuthSession {
        let accessToken = "mock_token_\(UUID().uuidString)"
        let refreshToken = "mock_refresh_\(UUID().uuidString)"
        let expiresAt = Date().addingTimeInterval(3600 * 24 * 30) // 30 days

        return AuthSession(
            user: user,
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: expiresAt
        )
    }

    private func saveCurrentSession(_ session: AuthSession) {
        let sessionData = SessionData(
            user: session.user,
            accessToken: session.accessToken,
            refreshToken: session.refreshToken,
            expiresAt: session.expiresAt
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        if let data = try? encoder.encode(sessionData) {
            defaults.set(data, forKey: currentSessionKey)
        }
    }
}

// Helper struct for encoding/decoding session
private struct SessionData: Codable {
    let user: User
    let accessToken: String
    let refreshToken: String?
    let expiresAt: Date
}
