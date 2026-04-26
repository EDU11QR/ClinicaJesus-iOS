//
//  GetCurrentUserSessionUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import Foundation

final class GetCurrentUserSessionUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> Bool {
        return await repository.hasActiveSession()
    }
}
