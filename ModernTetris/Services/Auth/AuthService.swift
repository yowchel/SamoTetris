//
//  AuthService.swift
//  SamoTetris
//
//  Created on 2026-01-12
//

import Foundation

/// Authentication service protocol
protocol AuthService {
    /// Sign up with email and password
    func signUp(email: String, password: String, nickname: String) async throws -> AuthSession

    /// Sign in with email and password
    func signIn(email: String, password: String) async throws -> AuthSession

    /// Sign in with Apple ID
    func signInWithApple() async throws -> AuthSession

    /// Sign in anonymously
    func signInAnonymously() async throws -> AuthSession

    /// Sign out current user
    func signOut() async throws

    /// Get current session
    func getCurrentSession() async throws -> AuthSession?

    /// Refresh session
    func refreshSession() async throws -> AuthSession

    /// Convert anonymous account to permanent account
    func linkEmailToAnonymous(email: String, password: String) async throws -> AuthSession

    /// Reset password
    func resetPassword(email: String) async throws

    /// Update user profile
    func updateProfile(nickname: String?, avatarUrl: String?) async throws -> User
}

/// Authentication errors
enum AuthError: LocalizedError {
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case userNotFound
    case networkError
    case invalidEmail
    case sessionExpired
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return LocalizedStrings.current.invalidCredentials
        case .emailAlreadyInUse:
            return LocalizedStrings.current.emailAlreadyInUse
        case .weakPassword:
            return LocalizedStrings.current.weakPassword
        case .userNotFound:
            return LocalizedStrings.current.userNotFound
        case .networkError:
            return LocalizedStrings.current.networkError
        case .invalidEmail:
            return LocalizedStrings.current.invalidEmail
        case .sessionExpired:
            return LocalizedStrings.current.sessionExpired
        case .unknownError(let message):
            return message
        }
    }
}
