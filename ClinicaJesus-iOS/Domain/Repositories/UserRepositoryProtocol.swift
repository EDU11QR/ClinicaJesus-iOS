//
//  UserRepositoryProtocol.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

protocol UserRepositoryProtocol {
    func fetchMyProfile() async throws -> Usuario

    func adminObtenerUsuarios() async throws -> [Usuario]
    func adminCambiarRolUsuario(
        usuarioId: Int,
        nuevoRol: String,
        especialidadId: Int?
    ) async throws -> String
    func adminDesactivarUsuario(usuarioId: Int) async throws -> String
}
