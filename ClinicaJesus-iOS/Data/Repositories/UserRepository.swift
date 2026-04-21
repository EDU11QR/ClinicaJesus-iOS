//
//  UserRepository.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

final class UserRepository: UserRepositoryProtocol {
    private let service: UserServiceProtocol

    init(service: UserServiceProtocol) {
        self.service = service
    }

    func fetchMyProfile() async throws -> Usuario {
        let dto = try await service.fetchMyProfile()
        return UsuarioMapper.toDomain(from: dto)
    }
}
