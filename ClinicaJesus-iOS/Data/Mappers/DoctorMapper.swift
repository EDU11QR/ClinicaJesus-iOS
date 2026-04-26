//
//  DoctorMapper.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

enum DoctorMapper {
    
    static func toDomain(from dto: DoctorDTO) -> Doctor {
        let nombre = dto.usuarios?.nombre ?? "Doctor"
        let apellido = dto.usuarios?.apellido ?? ""
        
        let nombreCompleto = "Dr. \(nombre) \(apellido)"
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return Doctor(
            id: dto.id,
            usuarioId: dto.usuario_id,
            especialidadId: dto.especialidad_id,
            nombreCompleto: nombreCompleto,
            especialidadNombre: dto.especialidades?.nombre ?? "Especialidad no registrada",
            cmp: dto.cmp,
            biografia: dto.biografia,
            telefono: dto.usuarios?.telefono
        )
    }
}
