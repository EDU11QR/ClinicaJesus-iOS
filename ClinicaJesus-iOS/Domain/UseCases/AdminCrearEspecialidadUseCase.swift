//
//  AdminCrearEspecialidadUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import Foundation

final class AdminCrearEspecialidadUseCase {
    private let repository: CatalogRepositoryProtocol
    
    init(repository: CatalogRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(nombre: String, descripcion: String, precio: Double) async throws -> String {
        try await repository.adminCrearEspecialidad(
            nombre: nombre,
            descripcion: descripcion,
            precio: precio
        )
    }
}
