//
//  DoctorDTO.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

struct DoctorDTO: Decodable {
    let id: Int
    let usuario_id: Int
    let especialidad_id: Int
    let cmp: String?
    let biografia: String?
    let activo: Bool
}
