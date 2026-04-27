//
//  AdminCambiarEstadoUsuarioUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 26/04/26.
//

import Foundation

final class AdminCambiarEstadoUsuarioUseCase {
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(
        usuarioId: Int,
        activo: Bool
    ) async throws -> String {
        try await repository.adminCambiarEstadoUsuario(
            usuarioId: usuarioId,
            activo: activo
        )
    }
}
