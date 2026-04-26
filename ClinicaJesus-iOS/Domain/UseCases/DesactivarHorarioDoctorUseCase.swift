//
//  DesactivarHorarioDoctorUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

final class DesactivarHorarioDoctorUseCase {
    
    private let repository: AppointmentRepositoryProtocol
    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(horarioId: Int) async throws -> Int {
        try await repository.desactivarHorarioDoctor(horarioId: horarioId)
    }
}
