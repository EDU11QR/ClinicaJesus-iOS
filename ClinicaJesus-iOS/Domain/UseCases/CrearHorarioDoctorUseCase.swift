//
//  CrearHorarioDoctorUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

final class CrearHorarioDoctorUseCase {
    
    private let repository: AppointmentRepositoryProtocol
    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(
        fecha: String,
        horaInicio: String,
        horaFin: String
    ) async throws -> Int {
        try await repository.crearHorarioDoctor(
            fecha: fecha,
            horaInicio: horaInicio,
            horaFin: horaFin
        )
    }
}
