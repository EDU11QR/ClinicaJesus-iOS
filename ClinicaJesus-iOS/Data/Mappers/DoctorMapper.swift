//
//  DoctorMapper.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

enum DoctorMapper {
    
    static func toDomain(from dto: DoctorDTO) -> Doctor {
        Doctor(
            id: dto.id,
            usuarioId: dto.usuario_id,
            especialidadId: dto.especialidad_id,
            nombreCompleto: "\(dto.usuarios.nombre) \(dto.usuarios.apellido)",
            correo: dto.usuarios.correo,
            telefono: dto.usuarios.telefono
        )
    }
}
