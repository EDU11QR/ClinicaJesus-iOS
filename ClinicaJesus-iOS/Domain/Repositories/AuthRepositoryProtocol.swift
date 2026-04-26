//
//  AuthRepositoryProtocol.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

protocol AuthRepositoryProtocol {
    func signUpPaciente(request: RegisterPacienteRequest) async throws -> Int
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func signOut() async throws
    
    //-----
    func hasActiveSession() async -> Bool
}
