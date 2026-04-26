//
//  CitaDoctorMapper.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

enum CitaDoctorMapper {
    
    static func toDomain(from dto: CitaDoctorDTO) -> CitaDoctor {
        let nombre = dto.paciente_nombre ?? "Paciente"
        let apellido = dto.paciente_apellido ?? ""
        
        return CitaDoctor(
            id: dto.cita_id,
            pacienteId: dto.paciente_id,
            pacienteNombreCompleto: "\(nombre) \(apellido)"
                .trimmingCharacters(in: .whitespacesAndNewlines),
            pacienteCorreo: dto.paciente_correo ?? "Correo no registrado",
            horarioId: dto.horario_id,
            fecha: dto.fecha,
            horaInicio: dto.hora_inicio,
            horaFin: dto.hora_fin,
            motivo: dto.motivo ?? "Sin motivo registrado",
            estado: dto.estado
        )
    }
}
