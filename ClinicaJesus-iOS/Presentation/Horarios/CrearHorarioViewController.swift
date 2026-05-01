//
//  CrearHorarioViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import UIKit

final class CrearHorarioViewController: UIViewController {
    
    private let viewModel: CrearHorarioViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nuevo Horario"
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Registra un nuevo horario disponible"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let cardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Registrar Horario"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let datePicker = UIDatePicker()
    private let startPicker = UIDatePicker()
    private let endPicker = UIDatePicker()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Guardar Horario", for: .normal)
        button.backgroundColor = .systemTeal
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    init(viewModel: CrearHorarioViewModel) {
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
        title = "Nuevo Horario"
        
        configurePickers()
        
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        loadingIndicator.hidesWhenStopped = true
        saveButton.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, subtitleLabel, cardView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [cardTitleLabel].forEach {
            cardView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let stack = UIStackView(arrangedSubviews: [
            makeFieldBlock(title: "Fecha", picker: datePicker),
            makeFieldBlock(title: "Hora Inicio", picker: startPicker),
            makeFieldBlock(title: "Hora Fin", picker: endPicker),
            saveButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            cardTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            cardTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            cardTitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            
            stack.topAnchor.constraint(equalTo: cardTitleLabel.bottomAnchor, constant: 22),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            loadingIndicator.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: -16)
        ])
    }
    
    private func configurePickers() {
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.preferredDatePickerStyle = .compact
        
        startPicker.datePickerMode = .time
        startPicker.preferredDatePickerStyle = .compact
        startPicker.minuteInterval = 30
        
        endPicker.datePickerMode = .time
        endPicker.preferredDatePickerStyle = .compact
        endPicker.minuteInterval = 30
    }
    
    private func makeFieldBlock(title: String, picker: UIDatePicker) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 12
        
        let label = UILabel()
        label.text = title
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .label
        
        picker.tintColor = .systemTeal
        
        [label, picker].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 76),
            
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            picker.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            picker.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    private func setupBindings() {
        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self else { return }
            
            if isLoading {
                self.loadingIndicator.startAnimating()
                self.saveButton.isEnabled = false
                self.saveButton.alpha = 0.7
            } else {
                self.loadingIndicator.stopAnimating()
                self.saveButton.isEnabled = true
                self.saveButton.alpha = 1
            }
        }
        
        viewModel.onSuccess = { [weak self] _ in
            self?.showSuccess()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }
    
    @objc private func save() {
        if let error = validarHorario() {
            showError(error)
            return
        }
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let fecha = df.string(from: datePicker.date)
        
        df.dateFormat = "HH:mm:ss"
        let inicio = df.string(from: startPicker.date)
        let fin = df.string(from: endPicker.date)
        
        viewModel.crearHorario(
            fecha: fecha,
            horaInicio: inicio,
            horaFin: fin
        )
    }
    
    private func validarHorario() -> String? {
        guard endPicker.date > startPicker.date else {
            return "La hora fin debe ser mayor a la hora inicio."
        }
        
        let diff = endPicker.date.timeIntervalSince(startPicker.date)
        
        guard diff == 1800 else {
            return "El horario debe durar exactamente 30 minutos."
        }
        
        return nil
    }
    
    private func showSuccess() {
        let alert = UIAlertController(
            title: "Horario creado",
            message: "Tu disponibilidad fue registrada correctamente.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Aviso",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}
