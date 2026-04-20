//
//  AuthRepository.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    private let service: AuthServiceProtocol

    init(service: AuthServiceProtocol) {
        self.service = service
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
}
