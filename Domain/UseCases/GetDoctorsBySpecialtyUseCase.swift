//
//  GetDoctorsBySpecialtyUseCase.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

final class GetDoctorsBySpecialtyUseCase {
    private let repository: CatalogRepositoryProtocol

    init(repository: CatalogRepositoryProtocol) {
        self.repository = repository
    }

    func execute(specialtyId: Int) async throws -> [Doctor] {
        try await repository.fetchDoctors(by: specialtyId)
    }
}
