//
//  DoctoresViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import Foundation

@MainActor
final class DoctoresViewModel {
    
    private let getDoctorsBySpecialtyUseCase: GetDoctorsBySpecialtyUseCase
    private let specialtyId: Int
    private let specialtyName: String
    
    private(set) var doctors: [Doctor] = []
    
    var onDoctorsChanged: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    init(
        specialtyId: Int,
        specialtyName: String,
        getDoctorsBySpecialtyUseCase: GetDoctorsBySpecialtyUseCase
    ) {
        self.specialtyId = specialtyId
        self.specialtyName = specialtyName
        self.getDoctorsBySpecialtyUseCase = getDoctorsBySpecialtyUseCase
    }
    
    var title: String {
        "Doctores - \(specialtyName)"
    }
    
    func loadDoctors() {
        Task {
            onLoadingChanged?(true)
            do {
                doctors = try await getDoctorsBySpecialtyUseCase.execute(specialtyId: specialtyId)
                onLoadingChanged?(false)
                onDoctorsChanged?()
            } catch {
                onLoadingChanged?(false)
                onError?(error.localizedDescription)
            }
        }
    }
    
    func numberOfRows() -> Int {
        doctors.count
    }
    
    func doctor(at index: Int) -> Doctor {
        doctors[index]
    }
}
