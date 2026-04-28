//
//  DoctoresViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//
/*
import UIKit

final class DoctoresViewController: UIViewController {
    
    private let viewModel: DoctoresViewModel
    
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    
    init(viewModel: DoctoresViewModel) {
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
        viewModel.loadDoctors()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.title
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DoctorCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 72
        tableView.tableFooterView = UIView()
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No hay doctores disponibles para esta especialidad."
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupBindings() {
        viewModel.onDoctorsChanged = { [weak self] in
            guard let self = self else { return }
            self.emptyLabel.isHidden = !self.viewModel.doctors.isEmpty
            self.tableView.reloadData()
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
        }
        
        viewModel.onError = { [weak self] message in
            guard let self = self else { return }
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alert, animated: true)
        }
    }
}

extension DoctoresViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let doctor = viewModel.doctor(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = doctor.nombreCompleto
        content.secondaryText = """
        \(doctor.especialidadNombre)
        CMP: \(doctor.cmp ?? "No registrado")
        \(doctor.biografia ?? "Sin biografía registrada")
        """
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let doctor = viewModel.doctor(at: indexPath.row)
        let horariosVC = DependencyContainer.shared.makeHorariosViewController(doctor: doctor)
        
        navigationController?.pushViewController(horariosVC, animated: true)
    }
}
*/


import UIKit

final class DoctoresViewController: UIViewController {
    
    private let viewModel: DoctoresViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Doctores"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Elige el médico de tu preferencia"
        label.font = .systemFont(ofSize: 16)
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
    
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No hay doctores disponibles para esta especialidad."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    init(viewModel: DoctoresViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
        setupBindings()
        viewModel.loadDoctors()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = viewModel.title
        
        [titleLabel, subtitleLabel, cardView, loadingIndicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        cardView.addSubview(tableView)
        cardView.addSubview(emptyLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            emptyLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTable() {
        tableView.register(PacienteDoctorCell.self, forCellReuseIdentifier: PacienteDoctorCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 110
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
    }
    
    private func setupBindings() {
        viewModel.onDoctorsChanged = { [weak self] in
            guard let self else { return }
            self.emptyLabel.isHidden = !self.viewModel.doctors.isEmpty
            self.tableView.reloadData()
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }
    }
    
    private func showAlert(_ msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}

extension DoctoresViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PacienteDoctorCell.identifier,
            for: indexPath
        ) as? PacienteDoctorCell else {
            return UITableViewCell()
        }

        let doctor = viewModel.doctor(at: indexPath.row)
        cell.configure(doctor)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let doctor = viewModel.doctor(at: indexPath.row)
        let vc = DependencyContainer.shared.makeHorariosViewController(doctor: doctor)
        navigationController?.pushViewController(vc, animated: true)
    }
}
