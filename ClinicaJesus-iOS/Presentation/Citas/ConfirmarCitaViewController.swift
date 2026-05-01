//
//  ConfirmarCitaViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//
/*
import UIKit

final class ConfirmarCitaViewController: UIViewController {
    
    private let viewModel: ConfirmarCitaViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let doctorLabel = UILabel()
    private let specialtyLabel = UILabel()
    private let dateLabel = UILabel()
    private let hourLabel = UILabel()
    
    private let motivoLabel = UILabel()
    private let motivoTextView = UITextView()
    
    private let notasLabel = UILabel()
    private let notasTextView = UITextView()
    
    private let confirmButton = UIButton(type: .system)
    
    init(viewModel: ConfirmarCitaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Confirmar cita"
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = "Resumen de la cita"
        
        [doctorLabel, specialtyLabel, dateLabel, hourLabel].forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.numberOfLines = 0
        }
        
        motivoLabel.text = "Motivo de consulta *"
        motivoLabel.font = .boldSystemFont(ofSize: 16)
        
        motivoTextView.layer.borderWidth = 1
        motivoTextView.layer.borderColor = UIColor.systemGray4.cgColor
        motivoTextView.layer.cornerRadius = 8
        motivoTextView.font = .systemFont(ofSize: 16)
        
        notasLabel.text = "Notas adicionales"
        notasLabel.font = .boldSystemFont(ofSize: 16)
        
        notasTextView.layer.borderWidth = 1
        notasTextView.layer.borderColor = UIColor.systemGray4.cgColor
        notasTextView.layer.cornerRadius = 8
        notasTextView.font = .systemFont(ofSize: 16)
        
        confirmButton.setTitle("Confirmar cita", for: .normal)
        confirmButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        confirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            doctorLabel,
            specialtyLabel,
            dateLabel,
            hourLabel,
            motivoLabel,
            motivoTextView,
            notasLabel,
            notasTextView,
            confirmButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            motivoTextView.heightAnchor.constraint(equalToConstant: 100),
            notasTextView.heightAnchor.constraint(equalToConstant: 100),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupData() {
        doctorLabel.text = "Doctor: \(viewModel.doctorName)"
        specialtyLabel.text = "Especialidad: \(viewModel.specialtyName)"
        dateLabel.text = "Fecha: \(viewModel.fecha)"
        hourLabel.text = "Hora: \(viewModel.hora)"
    }
    
    private func setupBindings() {
        viewModel.onValidationError = { [weak self] message in
            self?.showAlert(title: "Validación", message: message)
        }
        
        viewModel.onSuccess = { [weak self] citaId in
            let alert = UIAlertController(
                title: "Cita reservada",
                message: "Tu cita fue registrada correctamente. Código: \(citaId)",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            
            self?.present(alert, animated: true)
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }

        viewModel.onLoadingChanged = { [weak self] isLoading in
            self?.confirmButton.isEnabled = !isLoading
            self?.confirmButton.setTitle(
                isLoading ? "Reservando..." : "Confirmar cita",
                for: .normal
            )
        }
    }
    
    @objc private func didTapConfirm() {
        viewModel.confirmarCita(
            motivo: motivoTextView.text ?? ""
        )
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}
*/

import UIKit

final class ConfirmarCitaViewController: UIViewController {
    
    private let viewModel: ConfirmarCitaViewModel
    
    // MARK: UI
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    
    private let resumenCard = UIView()
    private let doctorLabel = UILabel()
    private let specialtyLabel = UILabel()
    private let dateLabel = UILabel()
    private let hourLabel = UILabel()
    
    private let motivoLabel = UILabel()
    private let motivoTextView = UITextView()
    
    private let notasLabel = UILabel()
    private let notasTextView = UITextView()
    
    private let confirmButton = UIButton(type: .system)
    
    // MARK: INIT
    
    init(viewModel: ConfirmarCitaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LIFE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupBindings()
    }
    
    // MARK: UI
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = "Confirmar cita"
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // HEADER
        titleLabel.text = "Resumen de la cita"
        titleLabel.font = .boldSystemFont(ofSize: 26)
        
        [doctorLabel, specialtyLabel, dateLabel, hourLabel].forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.numberOfLines = 0
        }
        
        // TEXTS
        motivoLabel.text = "Motivo de consulta"
        motivoLabel.font = .boldSystemFont(ofSize: 16)
        
        notasLabel.text = "Notas adicionales"
        notasLabel.font = .boldSystemFont(ofSize: 16)
        
        styleTextView(motivoTextView)
        styleTextView(notasTextView)
        
       
        
        // BUTTON
        confirmButton.setTitle("Confirmar cita", for: .normal)
        confirmButton.backgroundColor = .systemTeal
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 14
        confirmButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        confirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        
        // CARDS
        styleCard(resumenCard)
        
        // ADD VIEWS
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // RESUMEN STACK
        let resumenStack = UIStackView(arrangedSubviews: [
            doctorLabel,
            specialtyLabel,
            dateLabel,
            hourLabel
        ])
        
        resumenStack.axis = .vertical
        resumenStack.spacing = 8
        resumenStack.translatesAutoresizingMaskIntoConstraints = false
        
        resumenCard.addSubview(resumenStack)
        
        // MAIN STACK
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            resumenCard,
            motivoLabel,
            motivoTextView,
            notasLabel,
            notasTextView,
            confirmButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        // CONSTRAINTS
        NSLayoutConstraint.activate([
            
            // SCROLL
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // STACK
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            // RESUMEN CARD
            resumenStack.topAnchor.constraint(equalTo: resumenCard.topAnchor, constant: 16),
            resumenStack.leadingAnchor.constraint(equalTo: resumenCard.leadingAnchor, constant: 16),
            resumenStack.trailingAnchor.constraint(equalTo: resumenCard.trailingAnchor, constant: -16),
            resumenStack.bottomAnchor.constraint(equalTo: resumenCard.bottomAnchor, constant: -16),
            
            // HEIGHTS
            motivoTextView.heightAnchor.constraint(equalToConstant: 110),
            notasTextView.heightAnchor.constraint(equalToConstant: 110),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: DATA
    
    private func setupData() {
        doctorLabel.text = "Doctor: \(viewModel.doctorName)"
        specialtyLabel.text = "Especialidad: \(viewModel.specialtyName)"
        dateLabel.text = "Fecha: \(viewModel.fecha)"
        hourLabel.text = "Hora: \(viewModel.hora)"
    }
    
    // MARK: BINDINGS
    
    private func setupBindings() {
        viewModel.onValidationError = { [weak self] message in
            self?.showAlert(title: "Validación", message: message)
        }
        
        viewModel.onSuccess = { [weak self] citaId in
            let alert = UIAlertController(
                title: "Cita reservada",
                message: "Tu cita fue registrada correctamente. Código: \(citaId)",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            
            self?.present(alert, animated: true)
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            self?.confirmButton.isEnabled = !isLoading
            self?.confirmButton.setTitle(
                isLoading ? "Reservando..." : "Confirmar cita",
                for: .normal
            )
        }
    }
    
    // MARK: ACTIONS
    
    @objc private func didTapConfirm() {
        viewModel.confirmarCita(
            motivo: motivoTextView.text ?? ""
        )
    }
    
    // MARK: HELPERS
    
    private func styleCard(_ view: UIView) {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    private func styleTextView(_ textView: UITextView) {
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}

