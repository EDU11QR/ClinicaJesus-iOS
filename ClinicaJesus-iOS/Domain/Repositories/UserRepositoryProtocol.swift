//
//  UserRepositoryProtocol.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

protocol UserRepositoryProtocol {
    func fetchMyProfile() async throws -> Usuario
}
