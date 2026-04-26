//
//  AdminDesactivarUsuarioUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import Foundation

final class AdminDesactivarUsuarioUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute(usuarioId: Int) async throws -> String {
        try await repository.adminDesactivarUsuario(usuarioId: usuarioId)
    }
}
