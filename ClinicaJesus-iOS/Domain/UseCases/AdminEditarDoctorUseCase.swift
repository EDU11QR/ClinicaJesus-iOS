//
//  AdminEditarDoctorUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 26/04/26.
//

import Foundation

final class AdminEditarDoctorUseCase {
    
    private let repository: CatalogRepositoryProtocol
    
    init(repository: CatalogRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(
        doctorId: Int,
        cmp: String,
        especialidadId: Int,
        activo: Bool
    ) async throws -> String {
        try await repository.adminEditarDoctor(
            doctorId: doctorId,
            cmp: cmp,
            especialidadId: especialidadId,
            activo: activo
        )
    }
}
