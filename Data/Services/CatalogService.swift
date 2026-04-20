//
//  CatalogService.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation
import Supabase

protocol CatalogServiceProtocol {
    func fetchSpecialties() async throws -> [EspecialidadDTO]
    func fetchDoctors(by specialtyId: Int) async throws -> [DoctorDTO]
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

        print("Especialidades recibidas: \(response.count)")
        print(response)

        return response
    }

    func fetchDoctors(by specialtyId: Int) async throws -> [DoctorDTO] {
        let response: [DoctorDTO] = try await client
            .from("doctores")
            .select()
            .eq("especialidad_id", value: specialtyId)
            .eq("activo", value: true)
            .execute()
            .value

        print("Doctores recibidos: \(response.count)")
        print(response)

        return response
    }
}
