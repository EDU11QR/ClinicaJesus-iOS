//
//  RegisterPacienteViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//
/*
import UIKit

final class RegisterPacienteViewController: UIViewController {
    
    private let viewModel: RegisterPacienteViewModel
    
    //-------
    var onUserCreated: (() -> Void)?
    var isAdminMode: Bool = false
    
    private let nombreField = UITextField()
    private let apellidoField = UITextField()
    private let correoField = UITextField()
    private let telefonoField = UITextField()
    private let passwordField = UITextField()
    private let registerButton = UIButton(type: .system)
    
    init(viewModel: RegisterPacienteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        //---------------
        title = isAdminMode ? "Nuevo Usuario" : "Crear cuenta"
        
        configure(nombreField, placeholder: "Nombre")
        configure(apellidoField, placeholder: "Apellido")
        configure(correoField, placeholder: "Correo")
        configure(telefonoField, placeholder: "Teléfono")
        configure(passwordField, placeholder: "Contraseña")
        
        correoField.keyboardType = .emailAddress
        telefonoField.keyboardType = .phonePad
        passwordField.isSecureTextEntry = true
        //----------------
        registerButton.setTitle(isAdminMode ? "Registrar Usuario" : "Registrarme", for: .normal)
        registerButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            nombreField,
            apellidoField,
            correoField,
            telefonoField,
            passwordField,
            registerButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            nombreField.heightAnchor.constraint(equalToConstant: 44),
            apellidoField.heightAnchor.constraint(equalToConstant: 44),
            correoField.heightAnchor.constraint(equalToConstant: 44),
            telefonoField.heightAnchor.constraint(equalToConstant: 44),
            passwordField.heightAnchor.constraint(equalToConstant: 44),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configure(_ field: UITextField, placeholder: String) {
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
    }
    
    private func setupBindings() {
        viewModel.onSuccess = { [weak self] in
            guard let self else { return }
            
            if self.isAdminMode {
                self.onUserCreated?()
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            let alert = UIAlertController(
                title: "Cuenta creada",
                message: "Tu cuenta fue registrada correctamente. Ahora puedes iniciar sesión.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            
            self.present(alert, animated: true)
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            self?.registerButton.isEnabled = !isLoading
            self?.registerButton.setTitle(
                isLoading ? "Registrando..." : (self?.isAdminMode == true ? "Registrar Usuario" : "Registrarme"),
                for: .normal
            )
        }
    }
    
    @objc private func didTapRegister() {
        viewModel.registrar(
            nombre: nombreField.text ?? "",
            apellido: apellidoField.text ?? "",
            correo: correoField.text ?? "",
            telefono: telefonoField.text ?? "",
            password: passwordField.text ?? ""
        )
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Aviso",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}
*/


import UIKit

final class RegisterPacienteViewController: UIViewController {
    
    private let viewModel: RegisterPacienteViewModel
    
    var onUserCreated: (() -> Void)?
    var isAdminMode: Bool = false
    
    // UI BASE
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let cardView = UIView()
    
    // HEADER
    private let logoView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    // SECTION
    private let sectionTitleLabel = UILabel()
    private let sectionSubtitleLabel = UILabel()
    
    // FIELDS
    private let nombreField = UITextField()
    private let apellidoField = UITextField()
    private let correoField = UITextField()
    private let telefonoField = UITextField()
    private let passwordField = UITextField()
    private let confirmPasswordField = UITextField()
    
    // BUTTON
    private let registerButton = UIButton(type: .system)
    
    // FOOTER
    private let loginLabel = UILabel()
    private let loginButton = UIButton(type: .system)
    
    init(viewModel: RegisterPacienteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        
        // 🔥 NAV TITLE
        title = isAdminMode ? "Nuevo Usuario" : "Crear cuenta"
        
        // MARK: HEADER
        
        logoView.backgroundColor = .systemTeal
        logoView.layer.cornerRadius = 25
        
        iconView.image = UIImage(systemName: "heart.fill")
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        
        titleLabel.text = isAdminMode ? "Nuevo Usuario" : "Crea tu cuenta"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = isAdminMode
            ? "Crea un usuario manualmente"
            : "Únete a Clínica Jesus"
        
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .secondaryLabel
        
        // MARK: SECTION
        
        sectionTitleLabel.text = isAdminMode
            ? "Registro de Usuario"
            : "Registro de Paciente"
        
        sectionTitleLabel.font = .boldSystemFont(ofSize: 16)
        
        sectionSubtitleLabel.text = isAdminMode
            ? "Completa los datos del usuario"
            : "✔ Reserva citas médicas en línea"
        
        sectionSubtitleLabel.font = .systemFont(ofSize: 12)
        sectionSubtitleLabel.textColor = isAdminMode ? .secondaryLabel : .systemGreen
        
        // MARK: FIELDS
        
        configure(nombreField, "Nombre")
        configure(apellidoField, "Apellido")
        configure(correoField, "Correo")
        configure(telefonoField, "Teléfono")
        configure(passwordField, "Contraseña")
        configure(confirmPasswordField, "Confirmar contraseña")
        
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
        
        // MARK: BUTTON
        
        registerButton.setTitle(
            isAdminMode ? "Registrar Usuario" : "Crear Cuenta",
            for: .normal
        )
        registerButton.backgroundColor = .systemTeal
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 12
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        // MARK: FOOTER
        
        loginLabel.text = "¿Ya tienes una cuenta?"
        loginLabel.textAlignment = .center
        loginLabel.font = .systemFont(ofSize: 12)
        
        loginButton.setTitle("Inicia sesión", for: .normal)
        loginButton.setTitleColor(.systemTeal, for: .normal)
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        loginButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        
        // 🔥 OCULTAR EN ADMIN
        logoView.isHidden = isAdminMode
        titleLabel.isHidden = isAdminMode
        subtitleLabel.isHidden = isAdminMode
        loginLabel.isHidden = isAdminMode
        loginButton.isHidden = isAdminMode
        
        // MARK: ADD VIEWS
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [logoView, titleLabel, subtitleLabel, cardView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        logoView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        [sectionTitleLabel, sectionSubtitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }
        
        let stack = UIStackView(arrangedSubviews: [
            nombreField,
            apellidoField,
            correoField,
            telefonoField,
            passwordField,
            confirmPasswordField,
            registerButton,
            loginLabel,
            loginButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(stack)
        
        // MARK: STYLES
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 18
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowRadius = 10
        
        // MARK: CONSTRAINTS
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 70),
            logoView.heightAnchor.constraint(equalToConstant: 70),
            
            iconView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            sectionTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            sectionSubtitleLabel.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 4),
            sectionSubtitleLabel.leadingAnchor.constraint(equalTo: sectionTitleLabel.leadingAnchor),
            
            stack.topAnchor.constraint(equalTo: sectionSubtitleLabel.bottomAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            
            nombreField.heightAnchor.constraint(equalToConstant: 44),
            apellidoField.heightAnchor.constraint(equalToConstant: 44),
            correoField.heightAnchor.constraint(equalToConstant: 44),
            telefonoField.heightAnchor.constraint(equalToConstant: 44),
            passwordField.heightAnchor.constraint(equalToConstant: 44),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: 44),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        if isAdminMode {
            NSLayoutConstraint.activate([
                cardView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
                cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        }
    }
    
    
    
    private func configure(_ field: UITextField, _ placeholder: String) {
        field.placeholder = placeholder
        field.backgroundColor = .systemGray6
        field.layer.cornerRadius = 10
        field.autocapitalizationType = .none
        field.setLeftPaddingPoints(10)
    }
    
    private func setupBindings() {
        viewModel.onSuccess = { [weak self] in
            guard let self else { return }
            
            if self.isAdminMode {
                self.onUserCreated?()
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            let alert = UIAlertController(
                title: "Cuenta creada",
                message: "Tu cuenta fue registrada correctamente.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            
            self.present(alert, animated: true)
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            self?.registerButton.isEnabled = !isLoading
        }
    }
    
    @objc private func didTapRegister() {
        
        guard passwordField.text == confirmPasswordField.text else {
            showAlert("Las contraseñas no coinciden")
            return
        }
        
        viewModel.registrar(
            nombre: nombreField.text ?? "",
            apellido: apellidoField.text ?? "",
            correo: correoField.text ?? "",
            telefono: telefonoField.text ?? "",
            password: passwordField.text ?? ""
        )
    }
    
    @objc private func goToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}
