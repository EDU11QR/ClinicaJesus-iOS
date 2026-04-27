//
//  AdminEditarUsuarioUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 26/04/26.
//

import Foundation

final class AdminEditarUsuarioUseCase {
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(
        usuarioId: Int,
        nombre: String,
        apellido: String,
        correo: String,
        telefono: String
    ) async throws -> String {
        
        try await repository.adminEditarUsuario(
            usuarioId: usuarioId,
            nombre: nombre,
            apellido: apellido,
            correo: correo,
            telefono: telefono
        )
    }
}
