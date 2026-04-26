//
//  HomeViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//

import UIKit

final class HomeViewController: UIViewController {
    private let usuario: Usuario

    private let welcomeLabel = UILabel()
    private let roleLabel = UILabel()
    private let specialtiesButton = UIButton(type: .system)
    private let myAppointmentsButton = UIButton(type: .system)
    private let crearHorarioButton = UIButton(type: .system)
    private let misHorariosButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)
    
    init(usuario: Usuario) {
        self.usuario = usuario
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Inicio"
        setupUI()
    }

    private func setupUI() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        specialtiesButton.translatesAutoresizingMaskIntoConstraints = false
        myAppointmentsButton.translatesAutoresizingMaskIntoConstraints = false
        crearHorarioButton.translatesAutoresizingMaskIntoConstraints = false
        misHorariosButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("Cerrar sesión", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)

        welcomeLabel.textAlignment = .center
        roleLabel.textAlignment = .center

        welcomeLabel.font = .boldSystemFont(ofSize: 24)
        roleLabel.font = .systemFont(ofSize: 18)

        let nombreCompleto = [usuario.nombre, usuario.apellido]
            .compactMap { $0 }
            .joined(separator: " ")

        welcomeLabel.text = nombreCompleto.isEmpty
            ? "Bienvenido"
            : "Bienvenido, \(nombreCompleto)"

        roleLabel.text = "Rol: \(usuario.rol)"

        
        if usuario.rol.uppercased() == "PACIENTE" {
            specialtiesButton.setTitle("Reservar Cita", for: .normal)
            specialtiesButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
            specialtiesButton.addTarget(self, action: #selector(didTapSpecialties), for: .touchUpInside)
            myAppointmentsButton.setTitle("Mis citas", for: .normal)
            myAppointmentsButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
            myAppointmentsButton.addTarget(self, action: #selector(didTapMyAppointments), for: .touchUpInside)
        } else if usuario.rol.uppercased() == "DOCTOR" {
            specialtiesButton.addTarget(self, action: #selector(didTapDoctorAppointments), for: .touchUpInside)
            specialtiesButton.setTitle("Ver mis citas", for: .normal)
            specialtiesButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
            crearHorarioButton.setTitle("Crear horario", for: .normal)
            crearHorarioButton.addTarget(self, action: #selector(didTapCrearHorario), for: .touchUpInside)
            misHorariosButton.setTitle("Mis horarios", for: .normal)
            misHorariosButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
            misHorariosButton.addTarget(self, action: #selector(didTapMisHorarios), for: .touchUpInside)
            // Luego aquí conectaremos la pantalla de citas del doctor
        }
        
        

        
        myAppointmentsButton.isHidden = usuario.rol.uppercased() != "PACIENTE"
        crearHorarioButton.isHidden = usuario.rol.uppercased() != "DOCTOR"

        view.addSubview(logoutButton)
        view.addSubview(welcomeLabel)
        view.addSubview(roleLabel)
        view.addSubview(specialtiesButton)
        view.addSubview(myAppointmentsButton)
        view.addSubview(crearHorarioButton)
        view.addSubview(misHorariosButton)

        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            roleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            roleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            roleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            specialtiesButton.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 32),
            specialtiesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            myAppointmentsButton.topAnchor.constraint(equalTo: specialtiesButton.bottomAnchor, constant: 20),
            myAppointmentsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            crearHorarioButton.topAnchor.constraint(equalTo: specialtiesButton.bottomAnchor, constant: 20),
            crearHorarioButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            misHorariosButton.topAnchor.constraint(equalTo: crearHorarioButton.bottomAnchor, constant: 20),
            misHorariosButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func didTapLogout() {
        
        Task {
            do {
                try await DependencyContainer.shared.signOutUseCase.execute()
                
                let loginVC = DependencyContainer.shared.makeLoginViewController()
                let nav = UINavigationController(rootViewController: loginVC)
                
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = scene.windows.first {
                    window.rootViewController = nav
                    window.makeKeyAndVisible()
                }
                
            } catch {
                print("Error logout:", error)
            }
        }
    }

    @objc private func didTapSpecialties() {
        let vc = DependencyContainer.shared.makeEspecialidadesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapMyAppointments() {
        let vc = DependencyContainer.shared.makeMisCitasViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapDoctorAppointments() {
        let vc = DependencyContainer.shared.makeCitasDoctorViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapCrearHorario() {
        let vc = DependencyContainer.shared.makeCrearHorarioViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapMisHorarios() {
        let vc = DependencyContainer.shared.makeHorariosDoctorViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
