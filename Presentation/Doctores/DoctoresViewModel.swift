//
//  DoctoresViewModel.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//

import Foundation

@MainActor
final class DoctoresViewModel {
    private let getDoctorsBySpecialtyUseCase: GetDoctorsBySpecialtyUseCase

    var onLoadingChange: ((Bool) -> Void)?
    var onSuccess: (([Doctor]) -> Void)?
    var onError: ((String) -> Void)?

    init(getDoctorsBySpecialtyUseCase: GetDoctorsBySpecialtyUseCase) {
        self.getDoctorsBySpecialtyUseCase = getDoctorsBySpecialtyUseCase
    }

    func loadDoctors(specialtyId: Int) {
        Task {
            onLoadingChange?(true)
            do {
                let doctors = try await getDoctorsBySpecialtyUseCase.execute(specialtyId: specialtyId)
                print("Doctores en ViewModel: \(doctors.count)")
                onLoadingChange?(false)
                onSuccess?(doctors)
            } catch {
                print("Error cargando doctores: \(error)")
                onLoadingChange?(false)
                onError?(error.localizedDescription)
            }
        }
    }
}
