//
//  UserRepositoryProtocol.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

protocol UserRepositoryProtocol {
    func fetchMyProfile() async throws -> Usuario
}
