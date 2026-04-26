//
//  ObtenerCitasDoctorUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

final class ObtenerCitasDoctorUseCase {
    
    private let repository: AppointmentRepositoryProtocol
    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [CitaDoctor] {
        try await repository.obtenerCitasDoctor()
    }
}
