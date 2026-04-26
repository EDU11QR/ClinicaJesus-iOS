//
//  AdminObtenerEspecialidadesUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import Foundation

final class AdminObtenerEspecialidadesUseCase {
    private let repository: CatalogRepositoryProtocol
    
    init(repository: CatalogRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Especialidad] {
        try await repository.adminObtenerEspecialidades()
    }
}
