//
//  CatalogRepositoryProtocol.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

protocol CatalogRepositoryProtocol {
    func fetchSpecialties() async throws -> [Especialidad]
    func fetchDoctors(by specialtyId: Int) async throws -> [Doctor]
}
