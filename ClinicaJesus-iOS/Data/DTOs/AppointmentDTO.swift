//
//  AppointmentDTO.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

struct AppointmentDTO: Decodable {
    let cita_id: Int
    let doctor_id: Int
    let doctor_nombre: String?
    let doctor_apellido: String?
    let especialidad_nombre: String?
    let horario_id: Int
    let fecha: String
    let hora_inicio: String
    let hora_fin: String
    let motivo: String?
    let estado: String
}
