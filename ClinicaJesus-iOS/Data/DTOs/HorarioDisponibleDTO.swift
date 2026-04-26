//
//  HorarioDisponibleDTO.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

struct HorarioDisponibleDTO: Decodable {
    let horario_id: Int
    let doctor_id: Int
    let fecha: String
    let hora_inicio: String
    let hora_fin: String
}
