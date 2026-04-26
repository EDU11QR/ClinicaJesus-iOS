//
//  CancelAppointmentUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

final class CancelAppointmentUseCase {
    
    private let repository: AppointmentRepositoryProtocol
    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(citaId: Int) async throws -> Int {
        try await repository.cancelAppointment(citaId: citaId)
    }
}
