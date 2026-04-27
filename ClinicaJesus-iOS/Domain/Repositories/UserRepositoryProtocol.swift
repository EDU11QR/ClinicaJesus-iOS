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
    
    //----------------Editar usuario desde admin
    func adminEditarUsuario(
            usuarioId: Int,
            nombre: String,
            apellido: String,
            correo: String,
            telefono: String
        ) async throws -> String
    
    //--------Func para cambiar estado de usuario en admin
    func adminCambiarEstadoUsuario(
        usuarioId: Int,
        activo: Bool
    ) async throws -> String
    
}
