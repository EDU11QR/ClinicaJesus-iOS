//
//  AppointmentMapper.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

enum AppointmentMapper {
    
    static func toDomain(from dto: AppointmentDTO) -> Appointment {
        let nombre = dto.doctor_nombre ?? "Doctor"
        let apellido = dto.doctor_apellido ?? ""
        
        return Appointment(
            id: dto.cita_id,
            doctorId: dto.doctor_id,
            doctorNombreCompleto: "Dr. \(nombre) \(apellido)".trimmingCharacters(in: .whitespacesAndNewlines),
            especialidadNombre: dto.especialidad_nombre ?? "Especialidad no registrada",
            horarioId: dto.horario_id,
            fecha: dto.fecha,
            horaInicio: dto.hora_inicio,
            horaFin: dto.hora_fin,
            motivo: dto.motivo ?? "Sin motivo registrado",
            estado: dto.estado
        )
    }
}
