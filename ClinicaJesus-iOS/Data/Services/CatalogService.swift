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
                usuarios (
                    id,
                    nombre,
                    apellido,
                    correo,
                    telefono
                )
                """)
            .eq("especialidad_id", value: specialtyId)
            .execute()
            .value
        
        return response
    }
}
