//
//  AuthRepositoryProtocol.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

protocol AuthRepositoryProtocol {
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func signOut() async throws
}
