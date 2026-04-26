//
//  SignUpPacienteUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

final class SignUpPacienteUseCase {
    
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(request: RegisterPacienteRequest) async throws -> Int {
        try await repository.signUpPaciente(request: request)
    }
}
