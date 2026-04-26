//
//  AppointmentService.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation
import Supabase

protocol AppointmentServiceProtocol {
    func reserveAppointment(
        doctorId: Int,
        horarioId: Int,
        motivo: String
    ) async throws -> Int
    
    func crearHorarioDoctor(
        fecha: String,
        horaInicio: String,
        horaFin: String
    ) async throws -> Int
    
    func fetchMyAppointments() async throws -> [AppointmentDTO]
    func obtenerCitasDoctor() async throws -> [CitaDoctorDTO]
    func cancelAppointment(citaId: Int) async throws -> Int
    func cambiarEstadoCitaDoctor(citaId: Int, nuevoEstado: String) async throws -> Int
    
    func obtenerHorariosDoctor() async throws -> [HorarioDoctorDTO]

    func desactivarHorarioDoctor(horarioId: Int) async throws -> Int
}

final class AppointmentService: AppointmentServiceProtocol {
    
    private let client = SupabaseClientProvider.shared
    
    func reserveAppointment(
        doctorId: Int,
        horarioId: Int,
        motivo: String
    ) async throws -> Int {
        
        let response: Int = try await client
            .rpc("reservar_cita", params: [
                "p_doctor_id": "\(doctorId)",
                "p_horario_id": "\(horarioId)",
                "p_motivo": motivo
            ])
            .execute()
            .value
        
        return response
    }
    
    func fetchMyAppointments() async throws -> [AppointmentDTO] {
        let response: [AppointmentDTO] = try await client
            .rpc("obtener_mis_citas")
            .execute()
            .value
        
        return response
    }
    
    func obtenerCitasDoctor() async throws -> [CitaDoctorDTO] {
        let response: [CitaDoctorDTO] = try await client
            .rpc("obtener_citas_doctor")
            .execute()
            .value
        
        return response
    }
    
    func cancelAppointment(citaId: Int) async throws -> Int {
        let response: Int = try await client
            .rpc("cancelar_cita", params: [
                "p_cita_id": "\(citaId)"
            ])
            .execute()
            .value
        
        return response
    }
    
    func cambiarEstadoCitaDoctor(citaId: Int, nuevoEstado: String) async throws -> Int {
        let response: Int = try await client
            .rpc("cambiar_estado_cita", params: [
                "p_cita_id": "\(citaId)",
                "p_nuevo_estado": nuevoEstado
            ])
            .execute()
            .value
        
        return response
    }
    
    func crearHorarioDoctor(
        fecha: String,
        horaInicio: String,
        horaFin: String
    ) async throws -> Int {
        
        let response: Int = try await client
            .rpc("crear_horario_doctor", params: [
                "p_fecha": fecha,
                "p_hora_inicio": horaInicio,
                "p_hora_fin": horaFin
            ])
            .execute()
            .value
        
        return response
    }
    
    func obtenerHorariosDoctor() async throws -> [HorarioDoctorDTO] {
        let response: [HorarioDoctorDTO] = try await client
            .rpc("obtener_horarios_doctor")
            .execute()
            .value
        
        return response
    }

    func desactivarHorarioDoctor(horarioId: Int) async throws -> Int {
        let response: Int = try await client
            .rpc("desactivar_horario", params: [
                "p_horario_id": "\(horarioId)"
            ])
            .execute()
            .value
        
        return response
    }
}
