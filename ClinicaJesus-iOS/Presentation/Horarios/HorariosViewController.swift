//
//  HorariosViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 24/04/26.
//
/*
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
*/


import UIKit

final class HorariosViewController: UIViewController {
    
    private let viewModel: HorariosViewModel
    
    // MARK: UI
    
    private let doctorLabel = UILabel()
    private let instructionLabel = UILabel()
    
    private let calendarCard = UIView()
    private let datePicker = UIDatePicker()
    
    private let horariosCard = UIView()
    private let tableView = UITableView()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    
    // MARK: INIT
    
    init(viewModel: HorariosViewModel) {
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
        setupBindings()
        loadHorariosForSelectedDate()
    }
    
    // MARK: UI SETUP
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = viewModel.title
        
        // HEADER
        doctorLabel.text = viewModel.doctorName
        doctorLabel.font = .boldSystemFont(ofSize: 26)
        doctorLabel.numberOfLines = 0
        
        instructionLabel.text = "Selecciona una fecha disponible"
        instructionLabel.font = .systemFont(ofSize: 16)
        instructionLabel.textColor = .secondaryLabel
        
        // DATE PICKER
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // TABLE
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HorarioCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        // EMPTY
        emptyLabel.text = "No hay horarios disponibles para esta fecha."
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true
        
        // CARDS
        styleCard(calendarCard)
        styleCard(horariosCard)
        
        // ADD SUBVIEWS
        [doctorLabel, instructionLabel, calendarCard, horariosCard, loadingIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        calendarCard.addSubview(datePicker)
        horariosCard.addSubview(tableView)
        horariosCard.addSubview(emptyLabel)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // CONSTRAINTS
        NSLayoutConstraint.activate([
            
            // HEADER
            doctorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            doctorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doctorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            instructionLabel.topAnchor.constraint(equalTo: doctorLabel.bottomAnchor, constant: 8),
            instructionLabel.leadingAnchor.constraint(equalTo: doctorLabel.leadingAnchor),
            instructionLabel.trailingAnchor.constraint(equalTo: doctorLabel.trailingAnchor),
            
            // CALENDAR CARD
            calendarCard.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16),
            calendarCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            calendarCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            datePicker.topAnchor.constraint(equalTo: calendarCard.topAnchor, constant: 12),
            datePicker.leadingAnchor.constraint(equalTo: calendarCard.leadingAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: calendarCard.trailingAnchor, constant: -12),
            datePicker.bottomAnchor.constraint(equalTo: calendarCard.bottomAnchor, constant: -12),
            
            // HORARIOS CARD
            horariosCard.topAnchor.constraint(equalTo: calendarCard.bottomAnchor, constant: 16),
            horariosCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            horariosCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            horariosCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: horariosCard.topAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: horariosCard.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: horariosCard.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: horariosCard.bottomAnchor, constant: -12),
            
            emptyLabel.centerYAnchor.constraint(equalTo: horariosCard.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: horariosCard.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: horariosCard.trailingAnchor, constant: -24),
            
            // LOADING
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func styleCard(_ view: UIView) {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    // MARK: BINDINGS
    
    private func setupBindings() {
        viewModel.onHorariosChanged = { [weak self] in
            guard let self else { return }
            self.emptyLabel.isHidden = !self.viewModel.horarios.isEmpty
            self.tableView.reloadData()
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self else { return }
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
    
    // MARK: ACTIONS
    
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

// MARK: TABLE

extension HorariosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let horario = viewModel.horario(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "HorarioCell", for: indexPath)
        
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(horario.horaInicio) - \(horario.horaFin)"
        content.secondaryText = "Disponible"
        content.secondaryTextProperties.color = .systemGreen
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        // Estilo moderno
        cell.selectionStyle = .none
        cell.backgroundColor = .systemGray6
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        
       /* let isDisponible = horario.disponible // 👈 esto depende de tu modelo

        var content = cell.defaultContentConfiguration()
        content.text = "\(horario.horaInicio) - \(horario.horaFin)"

        if isDisponible {
            content.secondaryText = "Disponible"
            content.secondaryTextProperties.color = .systemGreen
        } else {
            content.secondaryText = "Reservado"
            content.secondaryTextProperties.color = .systemRed
        }

        cell.contentConfiguration = content
        cell.accessoryType = isDisponible ? .disclosureIndicator : .none

        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 12
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.systemGray5.cgColor
        cell.clipsToBounds = true*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        // Animación tipo tap
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                cell?.transform = .identity
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let horario = viewModel.horario(at: indexPath.row)
        
        /*let horario = viewModel.horario(at: indexPath.row)

        // 🚫 Si está ocupado, no dejar continuar
        guard horario.disponible else {
            return
        }*/
        
        
        let confirmarVC = DependencyContainer.shared.makeConfirmarCitaViewController(
            doctor: viewModel.doctor,
            horario: horario
        )
        
        navigationController?.pushViewController(confirmarVC, animated: true)
    }
}
