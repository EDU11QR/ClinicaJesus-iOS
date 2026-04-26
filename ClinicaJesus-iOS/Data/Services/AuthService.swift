//
//  AuthService.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation
import Supabase

protocol AuthServiceProtocol {
    func signUpPaciente(request: RegisterPacienteRequest) async throws -> Int
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func signOut() async throws
    
}

final class AuthService: AuthServiceProtocol {
    private let client = SupabaseClientProvider.shared
    
    func signUpPaciente(request: RegisterPacienteRequest) async throws -> Int {
        _ = try await client.auth.signUp(
            email: request.correo,
            password: request.password
        )
        
        let response: Int = try await client
            .rpc("registrar_paciente", params: [
                "p_nombre": request.nombre,
                "p_apellido": request.apellido,
                "p_correo": request.correo,
                "p_telefono": request.telefono
            ])
            .execute()
            .value
        
        return response
    }

    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(
            email: email,
            password: password
        )
    }

    func signUp(email: String, password: String) async throws {
        try await client.auth.signUp(
            email: email,
            password: password
        )
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    
}
