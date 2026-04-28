//
//  LoginViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//
/*
import UIKit

final class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel
    private let registerButton = UIButton(type: .system)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Iniciar sesión"
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Correo"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Contraseña"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ingresar", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
        bindViewModel()
    }

    private func setupUI() {
        [titleLabel, emailTextField, passwordTextField, loginButton, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            registerButton.setTitle("Crear nueva cuenta", for: .normal)
            registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
            
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            activityIndicator.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 24),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }

    private func bindViewModel() {
        viewModel.onLoadingChange = { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }

        viewModel.onSuccess = { [weak self] usuario in
            guard let self else { return }
            
            let nextVC: UIViewController
            
            switch usuario.rol.uppercased() {
            case "ADMIN":
                nextVC = DependencyContainer.shared.makeAdminHomeViewController()
                
            case "DOCTOR", "PACIENTE":
                nextVC = HomeViewController(usuario: usuario)
                
            default:
                nextVC = HomeViewController(usuario: usuario)
            }
            
            self.navigationController?.setViewControllers([nextVC], animated: true)
        }

        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }

    @objc private func didTapRegister() {
        let vc = DependencyContainer.shared.makeRegisterPacienteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLogin() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if email.isEmpty || password.isEmpty {
            showAlert("Completa todos los campos")
            return
        }
        
        viewModel.signIn(email: email, password: password)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Atención", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
*/

import UIKit

final class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel

    // MARK: UI

    private let logoView = UIView()
    private let iconView = UIImageView()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let cardView = UIView()

    private let emailField = UITextField()
    private let passwordField = UITextField()

    private let loginButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    // 🔥 NUEVO: texto de registro tipo link
    private let registerLabel = UILabel()
    private let registerButton = UIButton(type: .system)

    // MARK: INIT

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6

        setupUI()
        setupActions()
        bindViewModel()
    }

    // MARK: UI

    private func setupUI() {

        // LOGO
        logoView.backgroundColor = .systemTeal
        logoView.layer.cornerRadius = 22

        iconView.image = UIImage(systemName: "heart.fill")
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit

        // TITLES
        titleLabel.text = "Bienvenido de vuelta"
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textAlignment = .center

        subtitleLabel.text = "Inicia sesión para continuar"
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center

        // CARD
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 18
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 10

        // FIELDS
        styleField(emailField, placeholder: "Correo electrónico")
        styleField(passwordField, placeholder: "Contraseña")
        passwordField.isSecureTextEntry = true

        // LOGIN BUTTON
        loginButton.setTitle("Iniciar sesión", for: .normal)
        loginButton.backgroundColor = .systemTeal
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 16)

        // 🔥 TEXTO REGISTRO
        registerLabel.text = "¿No tienes una cuenta?"
        registerLabel.textAlignment = .center
        registerLabel.textColor = .secondaryLabel
        registerLabel.font = .systemFont(ofSize: 14)

        registerButton.setTitle("Regístrate aquí", for: .normal)
        registerButton.setTitleColor(.systemTeal, for: .normal)
        registerButton.titleLabel?.font = .boldSystemFont(ofSize: 14)

        // ADD VIEWS
        [logoView, titleLabel, subtitleLabel, cardView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        logoView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false

        [emailField, passwordField, loginButton, activityIndicator, registerLabel, registerButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }

        // CONSTRAINTS
        NSLayoutConstraint.activate([

            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 75),
            logoView.heightAnchor.constraint(equalToConstant: 75),

            iconView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            emailField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            emailField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            emailField.heightAnchor.constraint(equalToConstant: 45),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 12),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 45),

            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),

            // 🔥 REGISTRO UI
            registerLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),

            registerButton.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 4),
            registerButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            registerButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: ACTIONS

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    }

    // MARK: VIEWMODEL

    private func bindViewModel() {

        viewModel.onLoadingChange = { [weak self] isLoading in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.loginButton.isEnabled = !isLoading

                if isLoading {
                    self.activityIndicator.startAnimating()
                    self.loginButton.setTitle("", for: .normal)
                } else {
                    self.activityIndicator.stopAnimating()
                    self.loginButton.setTitle("Iniciar sesión", for: .normal)
                }
            }
        }

        viewModel.onSuccess = { [weak self] usuario in
            guard let self = self else { return }

            let nextVC: UIViewController

            switch usuario.rol.uppercased() {

            case "ADMIN":
                nextVC = DependencyContainer.shared.makeAdminHomeViewController()

            case "DOCTOR", "PACIENTE":
                nextVC = HomeViewController(usuario: usuario)

            default:
                nextVC = HomeViewController(usuario: usuario)
            }

            let nav = UINavigationController(rootViewController: nextVC)

            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = scene.windows.first {
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
        }

        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }

    // MARK: ACTIONS

    @objc private func didTapLogin() {
        viewModel.signIn(
            email: emailField.text ?? "",
            password: passwordField.text ?? ""
        )
    }

    // 🔥 IR A REGISTRO
    @objc private func didTapRegister() {
        let vc = DependencyContainer.shared.makeRegisterPacienteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: STYLE

    private func styleField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(10)
    }
}

// MARK: EXTENSION (FUERA DE LA CLASE)

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: 0))
        leftView = view
        leftViewMode = .always
    }
}
