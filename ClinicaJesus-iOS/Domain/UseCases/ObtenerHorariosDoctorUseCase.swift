//
//  ObtenerHorariosDoctorUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

final class ObtenerHorariosDoctorUseCase {
    
    private let repository: AppointmentRepositoryProtocol
    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [HorarioDoctor] {
        try await repository.obtenerHorariosDoctor()
    }
}
