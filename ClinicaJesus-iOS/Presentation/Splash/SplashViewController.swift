//
//  SplashViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import UIKit

final class SplashViewController: UIViewController {

    private let viewModel = SplashViewModel()

    var onFinish: (() -> Void)?

    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "splash_background") // 👈 tu imagen completa
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // 👇 SOLO el corazón (para animar)
    private let heartImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Logo") // solo el icono
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startHeartbeatAnimation()
    }

    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(heartImageView)

        NSLayoutConstraint.activate([
            // fondo ocupa toda la pantalla
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // corazón centrado (ajusta según tu diseño)
            heartImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heartImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            heartImageView.widthAnchor.constraint(equalToConstant: 100),
            heartImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        view.layoutIfNeeded()
    }

    private func startHeartbeatAnimation() {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 0.8
        pulse.fromValue = 1.0
        pulse.toValue = 1.15
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        heartImageView.layer.add(pulse, forKey: "pulse")
    }

    private func bind() {
        viewModel.onFinish = { [weak self] in
            self?.checkSession()
        }
        viewModel.start()
    }
    //---------
    private func checkSession() {
        Task {
            let container = DependencyContainer.shared
            let hasSession = await container.getCurrentUserSessionUseCase.execute()
            
            if hasSession {
                do {
                    let usuario = try await container.getMyProfileUseCase.execute()
                    
                    await MainActor.run {
                        let nextVC: UIViewController
                        
                        switch usuario.rol.uppercased() {
                        case "ADMIN":
                            nextVC = container.makeAdminHomeViewController()
                        case "DOCTOR", "PACIENTE":
                            nextVC = HomeViewController(usuario: usuario)
                        default:
                            nextVC = container.makeLoginViewController()
                        }
                        
                        self.navigationController?.setViewControllers([nextVC], animated: true)
                    }
                } catch {
                    await MainActor.run {
                        self.onFinish?()
                    }
                }
            } else {
                await MainActor.run {
                    self.onFinish?()
                }
            }
        }
    }
}

