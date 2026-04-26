//
//  CrearHorarioViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import UIKit

final class CrearHorarioViewController: UIViewController {
    
    private let viewModel: CrearHorarioViewModel
    
    private let datePicker = UIDatePicker()
    private let startPicker = UIDatePicker()
    private let endPicker = UIDatePicker()
    private let button = UIButton(type: .system)
    
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
        view.backgroundColor = .systemBackground
        title = "Crear horario"
        
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        
        startPicker.datePickerMode = .time
        endPicker.datePickerMode = .time
        
        button.setTitle("Guardar horario", for: .normal)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            datePicker,
            startPicker,
            endPicker,
            button
        ])
        
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupBindings() {
        viewModel.onSuccess = { [weak self] _ in
            self?.show("Horario creado correctamente")
        }
        
        viewModel.onError = { [weak self] msg in
            self?.show(msg)
        }
    }
    
    @objc private func save() {
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
    
    private func show(_ msg: String) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
