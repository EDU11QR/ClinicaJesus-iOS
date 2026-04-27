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
    
    func fetchAvailableSchedules(doctorId: Int, fecha: String) async throws -> [HorarioDisponible] {
        let dtos = try await service.fetchAvailableSchedules(
            doctorId: doctorId,
            fecha: fecha
        )
        
        return dtos.map {
            HorarioDisponibleMapper.toDomain(from: $0)
        }
    }
    
    //---------
    func adminObtenerEspecialidades() async throws -> [Especialidad] {
        let dtos = try await service.adminObtenerEspecialidades()
        return dtos.map { EspecialidadMapper.toDomain(from: $0) }
    }

    func adminCrearEspecialidad(nombre: String, descripcion: String, precio: Double) async throws -> String {
        try await service.adminCrearEspecialidad(
            nombre: nombre,
            descripcion: descripcion,
            precio: precio)
    }

    func adminEditarEspecialidad(
        id: Int,
        nombre: String,
        descripcion: String,
        precio: Double,
        activo: Bool
    ) async throws -> String {
        try await service.adminEditarEspecialidad(
            id: id,
            nombre: nombre,
            descripcion: descripcion,
            precio: precio,
            activo: activo
        )
    }
    
    //-------------DOCTOR
    
    func adminObtenerDoctores() async throws -> [AdminDoctor] {
        let dtos = try await service.adminObtenerDoctores()
        return dtos.map { AdminDoctorMapper.toDomain(from: $0) }
    }

    func adminEditarDoctor(
        doctorId: Int,
        cmp: String,
        especialidadId: Int,
        activo: Bool
    ) async throws -> String {
        try await service.adminEditarDoctor(
            doctorId: doctorId,
            cmp: cmp,
            especialidadId: especialidadId,
            activo: activo
        )
    }
    
    
}
