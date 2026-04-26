//
//  AppointmentRepositoryProtocol.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

protocol AppointmentRepositoryProtocol {
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
    
    func fetchMyAppointments() async throws -> [Appointment]
    func obtenerCitasDoctor() async throws -> [CitaDoctor]
    func cancelAppointment(citaId: Int) async throws -> Int
    func cambiarEstadoCitaDoctor(citaId: Int, nuevoEstado: String) async throws -> Int
    func obtenerHorariosDoctor() async throws -> [HorarioDoctor]
    func desactivarHorarioDoctor(horarioId: Int) async throws -> Int
}
