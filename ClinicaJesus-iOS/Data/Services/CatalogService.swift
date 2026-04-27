//
//  CatalogService.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation
import Supabase

protocol CatalogServiceProtocol {
    func fetchSpecialties() async throws -> [EspecialidadDTO]
    func fetchDoctorsBySpecialty(specialtyId: Int) async throws -> [DoctorDTO]
    func fetchAvailableSchedules(doctorId: Int, fecha: String) async throws -> [HorarioDisponibleDTO]
    
    //----------ADMIN
    func adminObtenerEspecialidades() async throws -> [EspecialidadDTO]
    func adminCrearEspecialidad(nombre: String, descripcion: String, precio: Double) async throws -> String

    func adminEditarEspecialidad(
        id: Int,
        nombre: String,
        descripcion: String,
        precio: Double,
        activo: Bool
    ) async throws -> String
    
    //----------DOCTOR
    func adminObtenerDoctores() async throws -> [AdminDoctorDTO]

    func adminEditarDoctor(
        doctorId: Int,
        cmp: String,
        especialidadId: Int,
        activo: Bool
    ) async throws -> String
    
}

final class CatalogService: CatalogServiceProtocol {
    
    private let client = SupabaseClientProvider.shared
    
    func fetchSpecialties() async throws -> [EspecialidadDTO] {
        let response: [EspecialidadDTO] = try await client
            .from("especialidades")
            .select()
            .eq("activo", value: true)
            .order("nombre", ascending: true)
            .execute()
            .value
        
        return response
    }
    
    func fetchDoctorsBySpecialty(specialtyId: Int) async throws -> [DoctorDTO] {
        let response: [DoctorDTO] = try await client
            .from("doctores")
            .select("""
                id,
                usuario_id,
                especialidad_id,
                cmp,
                biografia,
                usuarios (
                    id,
                    nombre,
                    apellido,
                    telefono
                ),
                especialidades (
                    id,
                    nombre
                )
                """)
            .eq("especialidad_id", value: specialtyId)
            .eq("activo", value: true)
            .execute()
            .value
        
        return response
    }
    
    func adminObtenerDoctores() async throws -> [AdminDoctorDTO] {
        let response: [AdminDoctorDTO] = try await client
            .rpc("admin_obtener_doctores")
            .execute()
            .value
        
        return response
    }

    func adminEditarDoctor(
        doctorId: Int,
        cmp: String,
        especialidadId: Int,
        activo: Bool
    ) async throws -> String {
        
        let params = AdminEditarDoctorParams(
            p_doctor_id: doctorId,
            p_cmp: cmp,
            p_especialidad_id: especialidadId,
            p_activo: activo
        )
        
        let response: String = try await client
            .rpc("admin_editar_doctor", params: params)
            .execute()
            .value
        
        return response
    }
    
    func fetchAvailableSchedules(doctorId: Int, fecha: String) async throws -> [HorarioDisponibleDTO] {
        let response: [HorarioDisponibleDTO] = try await client
            .rpc("obtener_horarios_libres", params: [
                "p_doctor_id": "\(doctorId)",
                "p_fecha": fecha
            ])
            .execute()
            .value
        
        return response
    }
    
    
    //--------
    
    func adminObtenerEspecialidades() async throws -> [EspecialidadDTO] {
        let response: [EspecialidadDTO] = try await client
            .rpc("admin_obtener_especialidades")
            .execute()
            .value
        
        return response
    }

    func adminCrearEspecialidad(nombre: String, descripcion: String, precio: Double) async throws -> String {
        let params = AdminCrearEspecialidadParams(
            p_nombre: nombre,
            p_descripcion: descripcion,
            p_precio: precio
        )
        
        let response: String = try await client
            .rpc("admin_crear_especialidad", params: params)
            .execute()
            .value
        
        return response
    }

    func adminEditarEspecialidad(
        id: Int,
        nombre: String,
        descripcion: String,
        precio: Double,
        activo: Bool
    ) async throws -> String {
        let params = AdminEditarEspecialidadParams(
            p_id: id,
            p_nombre: nombre,
            p_descripcion: descripcion,
            p_precio: precio,
            p_activo: activo
        )
        
        let response: String = try await client
            .rpc("admin_editar_especialidad", params: params)
            .execute()
            .value
        
        return response
    }
}


//------

struct AdminCrearEspecialidadParams: Encodable {
    let p_nombre: String
    let p_descripcion: String
    let p_precio: Double
}

struct AdminEditarEspecialidadParams: Encodable {
    let p_id: Int
    let p_nombre: String
    let p_descripcion: String
    let p_precio: Double
    let p_activo: Bool
}

//--------DOCTOR

struct AdminEditarDoctorParams: Encodable {
    let p_doctor_id: Int
    let p_cmp: String
    let p_especialidad_id: Int
    let p_activo: Bool
}
