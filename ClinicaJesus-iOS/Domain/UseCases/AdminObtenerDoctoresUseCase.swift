//
//  AdminObtenerDoctoresUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 26/04/26.
//

import Foundation

final class AdminObtenerDoctoresUseCase {
    
    private let repository: CatalogRepositoryProtocol
    
    init(repository: CatalogRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [AdminDoctor] {
        try await repository.adminObtenerDoctores()
    }
}
