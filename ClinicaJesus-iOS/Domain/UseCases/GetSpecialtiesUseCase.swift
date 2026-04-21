//
//  GetSpecialtiesUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
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
