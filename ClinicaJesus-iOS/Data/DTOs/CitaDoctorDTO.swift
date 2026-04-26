//
//  CitaDoctorDTO.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import Foundation

struct CitaDoctorDTO: Decodable {
    let cita_id: Int
    let paciente_id: Int
    let paciente_nombre: String?
    let paciente_apellido: String?
    let paciente_correo: String?
    let horario_id: Int
    let fecha: String
    let hora_inicio: String
    let hora_fin: String
    let motivo: String?
    let estado: String
}
