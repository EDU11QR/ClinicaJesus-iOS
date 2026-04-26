//
//  AdminEditarEspecialidadUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import Foundation

final class AdminEditarEspecialidadUseCase {
    private let repository: CatalogRepositoryProtocol
    
    init(repository: CatalogRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(
        id: Int,
        nombre: String,
        descripcion: String,
        precio: Double,
        activo: Bool
    ) async throws -> String {
        try await repository.adminEditarEspecialidad(
            id: id,
            nombre: nombre,
            descripcion: descripcion,
            precio: precio,
            activo: activo
        )
    }
}
