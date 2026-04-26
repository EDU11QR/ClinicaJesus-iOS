//
//  SplashViewModel.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import Foundation
final class SplashViewModel {

    var onFinish: (() -> Void)?

    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.onFinish?()
        }
    }
}

