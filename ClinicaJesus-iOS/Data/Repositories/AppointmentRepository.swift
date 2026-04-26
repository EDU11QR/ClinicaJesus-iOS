//
//  AppointmentRepository.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

final class AppointmentRepository: AppointmentRepositoryProtocol {
    
    private let service: AppointmentServiceProtocol
    
    init(service: AppointmentServiceProtocol) {
        self.service = service
    }
    
    func reserveAppointment(
        doctorId: Int,
        horarioId: Int,
        motivo: String
    ) async throws -> Int {
        try await service.reserveAppointment(
            doctorId: doctorId,
            horarioId: horarioId,
            motivo: motivo
        )
    }
    
    func crearHorarioDoctor(
        fecha: String,
        horaInicio: String,
        horaFin: String
    ) async throws -> Int {
        try await service.crearHorarioDoctor(
            fecha: fecha,
            horaInicio: horaInicio,
            horaFin: horaFin
        )
    }
    
    
    func fetchMyAppointments() async throws -> [Appointment] {
        let dtos = try await service.fetchMyAppointments()
        return dtos.map { AppointmentMapper.toDomain(from: $0) }
    }
    
    func cancelAppointment(citaId: Int) async throws -> Int {
        try await service.cancelAppointment(citaId: citaId)
    }
    
    func obtenerCitasDoctor() async throws -> [CitaDoctor] {
        let dtos = try await service.obtenerCitasDoctor()
        return dtos.map { CitaDoctorMapper.toDomain(from: $0) }
    }
    
    func cambiarEstadoCitaDoctor(citaId: Int, nuevoEstado: String) async throws -> Int {
        try await service.cambiarEstadoCitaDoctor(
            citaId: citaId,
            nuevoEstado: nuevoEstado
        )
    }
    
    func obtenerHorariosDoctor() async throws -> [HorarioDoctor] {
        let dtos = try await service.obtenerHorariosDoctor()
        return dtos.map { HorarioDoctorMapper.toDomain(from: $0) }
    }

    func desactivarHorarioDoctor(horarioId: Int) async throws -> Int {
        try await service.desactivarHorarioDoctor(horarioId: horarioId)
    }
}
