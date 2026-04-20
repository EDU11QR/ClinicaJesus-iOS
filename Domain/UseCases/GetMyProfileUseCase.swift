//
//  GetMyProfileUseCase.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

final class GetMyProfileUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> Usuario {
        try await repository.fetchMyProfile()
    }
}
