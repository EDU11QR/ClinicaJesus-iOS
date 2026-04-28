//
//  EspecialidadesViewController.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 20/04/26.
//
/*
import UIKit

final class EspecialidadesViewController: UIViewController {

    private let viewModel: EspecialidadesViewModel

    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    init(viewModel: EspecialidadesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Especialidades"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
        viewModel.loadSpecialties()
    }

    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onLoadingChange = { [weak self] isLoading in
            guard let self = self else { return }

            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }

        viewModel.onSuccess = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onError = { [weak self] message in
            guard let self = self else { return }

            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

extension EspecialidadesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = viewModel.specialty(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = item.nombre
        content.secondaryText = item.descripcion ?? "Sin descripción"
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let specialty = viewModel.specialty(at: indexPath.row)

        let doctorsVC = DependencyContainer.shared.makeDoctoresViewController(
            specialtyId: specialty.id,
            specialtyName: specialty.nombre
        )

        navigationController?.pushViewController(doctorsVC, animated: true)
    }
}
*/


import UIKit

final class EspecialidadesViewController: UIViewController {

    private let viewModel: EspecialidadesViewModel

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Especialidades"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Elige una especialidad para continuar"
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
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    init(viewModel: EspecialidadesViewModel) {
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
        bindViewModel()
        viewModel.loadSpecialties()
    }

    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = "Especialidades"
        
        [titleLabel, subtitleLabel, cardView, activityIndicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        cardView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTable() {
        tableView.register(PacienteEspecialidadCell.self, forCellReuseIdentifier: PacienteEspecialidadCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 90
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
    }

    private func bindViewModel() {
        viewModel.onLoadingChange = { [weak self] isLoading in
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }

        viewModel.onSuccess = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }
    }
    
    private func showAlert(_ msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension EspecialidadesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PacienteEspecialidadCell.identifier,
            for: indexPath
        ) as? PacienteEspecialidadCell else {
            return UITableViewCell()
        }

        let item = viewModel.specialty(at: indexPath.row)
        cell.configure(item)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let specialty = viewModel.specialty(at: indexPath.row)

        let vc = DependencyContainer.shared.makeDoctoresViewController(
            specialtyId: specialty.id,
            specialtyName: specialty.nombre
        )

        navigationController?.pushViewController(vc, animated: true)
    }
}
