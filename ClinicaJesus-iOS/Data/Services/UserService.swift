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
}
