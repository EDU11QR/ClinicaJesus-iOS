//
//  GetSpecialtiesUseCase.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

final class GetSpecialtiesUseCase {
    private let repository: CatalogRepositoryProtocol

    init(repository: CatalogRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Especialidad] {
        try await repository.fetchSpecialties()
    }
}
