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

    func adminObtenerUsuarios() async throws -> [Usuario] {
        let dtos = try await service.adminObtenerUsuarios()
        return dtos.map { UsuarioMapper.toDomain(from: $0) }
    }

    func adminCambiarRolUsuario(
        usuarioId: Int,
        nuevoRol: String,
        especialidadId: Int?
    ) async throws -> String {
        try await service.adminCambiarRolUsuario(
            usuarioId: usuarioId,
            nuevoRol: nuevoRol,
            especialidadId: especialidadId
        )
    }

    func adminDesactivarUsuario(usuarioId: Int) async throws -> String {
        try await service.adminDesactivarUsuario(usuarioId: usuarioId)
    }
}
