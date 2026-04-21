//
//  CatalogRepository.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

//
//  CatalogRepository.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

final class CatalogRepository: CatalogRepositoryProtocol {
    
    private let service: CatalogServiceProtocol
    
    init(service: CatalogServiceProtocol) {
        self.service = service
    }
    
    func fetchSpecialties() async throws -> [Especialidad] {
        let dtos = try await service.fetchSpecialties()
        return dtos.map { EspecialidadMapper.toDomain(from: $0) }
    }
    
    func fetchDoctorsBySpecialty(specialtyId: Int) async throws -> [Doctor] {
        let dtos = try await service.fetchDoctorsBySpecialty(specialtyId: specialtyId)
        return dtos.map { DoctorMapper.toDomain(from: $0) }
    }
}
