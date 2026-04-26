//
//  AuthRepository.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    private let service: AuthServiceProtocol
    private let client = SupabaseClientProvider.shared

    init(service: AuthServiceProtocol) {
        self.service = service
    }
    func signUpPaciente(request: RegisterPacienteRequest) async throws -> Int {
        try await service.signUpPaciente(request: request)
    }

    func signIn(email: String, password: String) async throws {
        try await service.signIn(email: email, password: password)
    }

    func signUp(email: String, password: String) async throws {
        try await service.signUp(email: email, password: password)
    }

    func signOut() async throws {
        try await service.signOut()
    }
    
    //------
    func hasActiveSession() async -> Bool {
        do {
            _ = try await client.auth.session
            return true
        } catch {
            return false
        }
    }
}
