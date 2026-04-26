//
//  HorariosViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//

import UIKit

final class HorariosViewController: UIViewController {
    
    private let viewModel: HorariosViewModel
    
    private let doctorLabel = UILabel()
    private let instructionLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    
    init(viewModel: HorariosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        loadHorariosForSelectedDate()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.title
        
        doctorLabel.translatesAutoresizingMaskIntoConstraints = false
        doctorLabel.text = viewModel.doctorName
        doctorLabel.font = .boldSystemFont(ofSize: 22)
        doctorLabel.numberOfLines = 0
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.text = "Selecciona una fecha disponible"
        instructionLabel.font = .systemFont(ofSize: 16)
        instructionLabel.textColor = .secondaryLabel
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HorarioCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 64
        tableView.tableFooterView = UIView()
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No hay horarios disponibles para esta fecha."
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true
        
        view.addSubview(doctorLabel)
        view.addSubview(instructionLabel)
        view.addSubview(datePicker)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            doctorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            doctorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doctorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            instructionLabel.topAnchor.constraint(equalTo: doctorLabel.bottomAnchor, constant: 8),
            instructionLabel.leadingAnchor.constraint(equalTo: doctorLabel.leadingAnchor),
            instructionLabel.trailingAnchor.constraint(equalTo: doctorLabel.trailingAnchor),
            
            datePicker.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            tableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 40),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupBindings() {
        viewModel.onHorariosChanged = { [weak self] in
            guard let self = self else { return }
            self.emptyLabel.isHidden = !self.viewModel.horarios.isEmpty
            self.tableView.reloadData()
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }
        
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    @objc private func dateChanged() {
        loadHorariosForSelectedDate()
    }
    
    private func loadHorariosForSelectedDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fecha = formatter.string(from: datePicker.date)
        viewModel.loadHorarios(fecha: fecha)
    }
}

extension HorariosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
        let horario = viewModel.horario(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "HorarioCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(horario.horaInicio) - \(horario.horaFin)"
        content.secondaryText = "Disponible"
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let horario = viewModel.horario(at: indexPath.row)
        
        let confirmarVC = DependencyContainer.shared.makeConfirmarCitaViewController(
            doctor: viewModel.doctor,
            horario: horario
        )
        
        navigationController?.pushViewController(confirmarVC, animated: true)
    }
}
