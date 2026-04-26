//
//  HorarioDoctorMapper.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

enum HorarioDoctorMapper {
    
    static func toDomain(from dto: HorarioDoctorDTO) -> HorarioDoctor {
        HorarioDoctor(
            id: dto.horario_id,
            fecha: dto.fecha,
            horaInicio: dto.hora_inicio,
            horaFin: dto.hora_fin,
            activo: dto.activo,
            reservado: dto.reservado
        )
    }
}
