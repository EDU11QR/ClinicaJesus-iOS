//
//  CatalogRepositoryProtocol.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

protocol CatalogRepositoryProtocol {
    func fetchSpecialties() async throws -> [Especialidad]
    func fetchDoctorsBySpecialty(specialtyId: Int) async throws -> [Doctor]
}
