//
//  HomeViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//
/*
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
*/


import UIKit

final class HomeViewController: UIViewController {
    
    private let usuario: Usuario
    private let container = DependencyContainer.shared
    
    // HEADER
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // BUTTONS (cards)
    private let reservarButton = AdminMenuButton(
        title: "Reservar Cita",
        subtitle: "Agenda una nueva cita médica",
        icon: "calendar.badge.plus"
    )
    
    private let misCitasButton = AdminMenuButton(
        title: "Mis citas",
        subtitle: "Ver y gestionar tus citas",
        icon: "calendar"
    )
    
    private let verCitasDoctorButton = AdminMenuButton(
        title: "Mis citas",
        subtitle: "Ver citas asignadas",
        icon: "calendar"
    )
    
    private let crearHorarioButton = AdminMenuButton(
        title: "Crear horario",
        subtitle: "Agregar disponibilidad",
        icon: "clock.badge.plus"
    )
    
    private let misHorariosButton = AdminMenuButton(
        title: "Mis horarios",
        subtitle: "Ver horarios creados",
        icon: "clock"
    )
    
    private let logoutButton = AdminMenuButton(
        title: "Cerrar sesión",
        subtitle: "Salir de la cuenta",
        icon: "rectangle.portrait.and.arrow.right",
        isDestructive: true
    )
    
    // contacto
    private let contactoButton = AdminMenuButton(
        title: "Contacto",
        subtitle: "WhatsApp y ubicación de la clínica",
        icon: "message.fill"
    )
    
    init(usuario: Usuario) {
        self.usuario = usuario
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationItem.hidesBackButton = true
        
        let nombreCompleto = [usuario.nombre, usuario.apellido]
            .compactMap { $0 }
            .joined(separator: " ")
        
        titleLabel.text = nombreCompleto.isEmpty
            ? "Bienvenido"
            : "Bienvenido, \(nombreCompleto)"
        
        //subtitleLabel.text = "Rol: \(usuario.rol)"
        if usuario.rol.uppercased() == "PACIENTE" {
            subtitleLabel.text = "Agenda y gestiona tus citas"
        } else if usuario.rol.uppercased() == "DOCTOR" {
            subtitleLabel.text = "Gestiona tus horarios y citas"
        } else {
            subtitleLabel.text = "Bienvenido al sistema"
        }
        
        
        var arrangedViews: [UIView] = [
            titleLabel,
            subtitleLabel
        ]
        
        if usuario.rol.uppercased() == "PACIENTE" {
            arrangedViews.append(contentsOf: [
                reservarButton,
                misCitasButton,
                contactoButton
            ])
        } else if usuario.rol.uppercased() == "DOCTOR" {
            arrangedViews.append(contentsOf: [
                verCitasDoctorButton,
                crearHorarioButton,
                misHorariosButton
            ])
        }
        
        arrangedViews.append(logoutButton)
        
        let stack = UIStackView(arrangedSubviews: arrangedViews)
        stack.axis = .vertical
        stack.spacing = 18
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        
        reservarButton.addTarget(self, action: #selector(didTapReservar), for: .touchUpInside)
        misCitasButton.addTarget(self, action: #selector(didTapMisCitas), for: .touchUpInside)
        
        verCitasDoctorButton.addTarget(self, action: #selector(didTapDoctorCitas), for: .touchUpInside)
        crearHorarioButton.addTarget(self, action: #selector(didTapCrearHorario), for: .touchUpInside)
        misHorariosButton.addTarget(self, action: #selector(didTapMisHorarios), for: .touchUpInside)
        
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        
        contactoButton.addTarget(self, action: #selector(didTapContacto), for: .touchUpInside)
    }
    
    // MARK: ACTIONS
    
    @objc private func didTapReservar() {
        let vc = container.makeEspecialidadesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapMisCitas() {
        let vc = container.makeMisCitasViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapContacto() {
        let vc = container.makePacienteContactoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapDoctorCitas() {
        let vc = container.makeCitasDoctorViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapCrearHorario() {
        let vc = container.makeCrearHorarioViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapMisHorarios() {
        let vc = container.makeHorariosDoctorViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLogout() {
        Task {
            do {
                try await DependencyContainer.shared.signOutUseCase.execute()
                
                let loginVC = DependencyContainer.shared.makeLoginViewController()
                navigationController?.setViewControllers([loginVC], animated: true)
                
            } catch {
                showAlert("No se pudo cerrar sesión")
            }
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}
