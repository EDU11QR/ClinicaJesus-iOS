//
//  HorarioDisponibleMapper.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

enum HorarioDisponibleMapper {
    
    static func toDomain(from dto: HorarioDisponibleDTO) -> HorarioDisponible {
        return HorarioDisponible(
            id: dto.horario_id,
            doctorId: dto.doctor_id,
            fecha: dto.fecha,
            horaInicio: dto.hora_inicio,
            horaFin: dto.hora_fin
        )
    }
}
