//
//  HorarioDoctorDTO.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

struct HorarioDoctorDTO: Decodable {
    let horario_id: Int
    let fecha: String
    let hora_inicio: String
    let hora_fin: String
    let activo: Bool
    let reservado: Bool
}
