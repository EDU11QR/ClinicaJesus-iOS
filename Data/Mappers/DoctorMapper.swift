//
//  DoctorMapper.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

enum DoctorMapper {
    static func toDomain(from dto: DoctorDTO) -> Doctor {
        Doctor(
            id: dto.id,
            usuarioId: dto.usuario_id,
            especialidadId: dto.especialidad_id,
            cmp: dto.cmp,
            biografia: dto.biografia,
            activo: dto.activo
        )
    }
}
