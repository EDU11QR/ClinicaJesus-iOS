//
//  GetAvailableSchedulesUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

final class GetAvailableSchedulesUseCase {
    
    private let repository: CatalogRepositoryProtocol
    
    init(repository: CatalogRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(doctorId: Int, fecha: String) async throws -> [HorarioDisponible] {
        try await repository.fetchAvailableSchedules(
            doctorId: doctorId,
            fecha: fecha
        )
    }
}
