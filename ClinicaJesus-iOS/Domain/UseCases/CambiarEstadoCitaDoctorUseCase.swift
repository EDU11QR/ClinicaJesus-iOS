//
//  CambiarEstadoCitaDoctorUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

final class CambiarEstadoCitaDoctorUseCase {
    
    private let repository: AppointmentRepositoryProtocol
    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(citaId: Int, nuevoEstado: String) async throws -> Int {
        try await repository.cambiarEstadoCitaDoctor(
            citaId: citaId,
            nuevoEstado: nuevoEstado
        )
    }
}
