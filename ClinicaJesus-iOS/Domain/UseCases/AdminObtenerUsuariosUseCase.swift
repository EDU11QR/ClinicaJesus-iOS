//
//  AdminObtenerUsuariosUseCase.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import Foundation

final class AdminObtenerUsuariosUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Usuario] {
        try await repository.adminObtenerUsuarios()
    }
}
