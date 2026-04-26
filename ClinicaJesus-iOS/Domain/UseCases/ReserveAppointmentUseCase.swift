//
//  ReserveAppointmentUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

final class ReserveAppointmentUseCase {
    
    private let repository: AppointmentRepositoryProtocol
    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(
        doctorId: Int,
        horarioId: Int,
        motivo: String
    ) async throws -> Int {
        try await repository.reserveAppointment(
            doctorId: doctorId,
            horarioId: horarioId,
            motivo: motivo
        )
    }
}
