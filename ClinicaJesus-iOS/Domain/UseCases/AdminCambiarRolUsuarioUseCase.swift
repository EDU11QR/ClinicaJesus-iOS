//
//  AdminCambiarRolUsuarioUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import Foundation

final class AdminCambiarRolUsuarioUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        usuarioId: Int,
        nuevoRol: String,
        especialidadId: Int?
    ) async throws -> String {
        try await repository.adminCambiarRolUsuario(
            usuarioId: usuarioId,
            nuevoRol: nuevoRol,
            especialidadId: especialidadId
        )
    }
}
