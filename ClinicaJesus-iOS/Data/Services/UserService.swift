//
//  UserService.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation
import Supabase

protocol UserServiceProtocol {
    func fetchMyProfile() async throws -> UsuarioDTO

    func adminObtenerUsuarios() async throws -> [UsuarioDTO]
    func adminCambiarRolUsuario(
        usuarioId: Int,
        nuevoRol: String,
        especialidadId: Int?
    ) async throws -> String
    func adminDesactivarUsuario(usuarioId: Int) async throws -> String
}

final class UserService: UserServiceProtocol {
    private let client = SupabaseClientProvider.shared

    func fetchMyProfile() async throws -> UsuarioDTO {
        let authUser = try await client.auth.user()

        let response: UsuarioDTO = try await client
            .from("usuarios")
            .select()
            .eq("auth_user_id", value: authUser.id)
            .single()
            .execute()
            .value

        return response
    }

    func adminObtenerUsuarios() async throws -> [UsuarioDTO] {
        let response: [UsuarioDTO] = try await client
            .rpc("admin_obtener_usuarios")
            .execute()
            .value

        return response
    }

    func adminCambiarRolUsuario(
        usuarioId: Int,
        nuevoRol: String,
        especialidadId: Int?
    ) async throws -> String {
        let params = AdminCambiarRolUsuarioParams(
            p_usuario_id: usuarioId,
            p_nuevo_rol: nuevoRol,
            p_especialidad_id: especialidadId
        )

        let response: String = try await client
            .rpc("admin_cambiar_rol_usuario", params: params)
            .execute()
            .value

        return response
    }

    func adminDesactivarUsuario(usuarioId: Int) async throws -> String {
        let params = AdminDesactivarUsuarioParams(
            p_usuario_id: usuarioId
        )

        let response: String = try await client
            .rpc("admin_desactivar_usuario", params: params)
            .execute()
            .value

        return response
    }
}

struct AdminCambiarRolUsuarioParams: Encodable {
    let p_usuario_id: Int
    let p_nuevo_rol: String
    let p_especialidad_id: Int?
}

struct AdminDesactivarUsuarioParams: Encodable {
    let p_usuario_id: Int
}
