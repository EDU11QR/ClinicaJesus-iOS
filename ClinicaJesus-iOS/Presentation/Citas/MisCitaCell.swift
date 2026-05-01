//
//  MisCitaCell.swift
//  ClinicaJesus-iOS
//
//  Created by Anthony on 30/04/26.
//

import UIKit

final class MisCitaCell: UITableViewCell {
    
    static let identifier = "MisCitaCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let doctorLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private let statusBadge: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = .white
        return label
    }()
    
    private let specialtyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let motivoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        [doctorLabel, statusBadge, specialtyLabel, dateLabel, motivoLabel].forEach {
            cardView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            doctorLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            doctorLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            doctorLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadge.leadingAnchor, constant: -8),
            
            statusBadge.centerYAnchor.constraint(equalTo: doctorLabel.centerYAnchor),
            statusBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            statusBadge.heightAnchor.constraint(equalToConstant: 20),
            
            specialtyLabel.topAnchor.constraint(equalTo: doctorLabel.bottomAnchor, constant: 6),
            specialtyLabel.leadingAnchor.constraint(equalTo: doctorLabel.leadingAnchor),
            specialtyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            
            dateLabel.topAnchor.constraint(equalTo: specialtyLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: doctorLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            
            motivoLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            motivoLabel.leadingAnchor.constraint(equalTo: doctorLabel.leadingAnchor),
            motivoLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            motivoLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14)
        ])
    }
    
    func configure(with cita: Appointment) {
        doctorLabel.text = cita.doctorNombreCompleto
        specialtyLabel.text = cita.especialidadNombre
        dateLabel.text = "\(cita.fecha) | \(cita.horaInicio) - \(cita.horaFin)"
        motivoLabel.text = "Motivo: \(cita.motivo)"
        
        let estado = cita.estado.uppercased()
        statusBadge.text = " \(estado) "
        
        switch estado {
        case "PENDIENTE":
            statusBadge.backgroundColor = .systemOrange
        case "CONFIRMADA":
            statusBadge.backgroundColor = .systemGreen
        case "CANCELADA":
            statusBadge.backgroundColor = .systemRed
        case "ATENDIDA":
            statusBadge.backgroundColor = .systemBlue
        default:
            statusBadge.backgroundColor = .systemGray
        }
    }
}
