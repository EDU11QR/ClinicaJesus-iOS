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
    func fetchAvailableSchedules(doctorId: Int, fecha: String) async throws -> [HorarioDisponible]
    
    //-------
    func adminObtenerEspecialidades() async throws -> [Especialidad]
    func adminCrearEspecialidad(nombre: String, descripcion: String, precio: Double) async throws -> String

    func adminEditarEspecialidad(
        id: Int,
        nombre: String,
        descripcion: String,
        precio: Double,
        activo: Bool
    ) async throws -> String
}
