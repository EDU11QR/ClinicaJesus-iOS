//
//  HorarioDoctorCell.swift
//  ClinicaJesus-iOS
//
//  Created by Anthony on 30/04/26.
//

import UIKit

final class HorarioDoctorCell: UITableViewCell {
    
    static let identifier = "HorarioDoctorCell"
    
    private let rowView = UIView()
    
    private let fechaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .label
        label.numberOfLines = 3
        return label
    }()
    
    private let inicioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let finLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let estadoLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.textAlignment = .center
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
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
        
        contentView.addSubview(rowView)
        rowView.translatesAutoresizingMaskIntoConstraints = false
        
        [fechaLabel, inicioLabel, finLabel, estadoLabel, separator].forEach {
            rowView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            rowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            fechaLabel.topAnchor.constraint(equalTo: rowView.topAnchor, constant: 14),
            fechaLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            fechaLabel.widthAnchor.constraint(equalTo: rowView.widthAnchor, multiplier: 0.34),
            
            inicioLabel.centerYAnchor.constraint(equalTo: fechaLabel.centerYAnchor),
            inicioLabel.leadingAnchor.constraint(equalTo: fechaLabel.trailingAnchor, constant: 8),
            inicioLabel.widthAnchor.constraint(equalTo: rowView.widthAnchor, multiplier: 0.24),
            
            finLabel.centerYAnchor.constraint(equalTo: fechaLabel.centerYAnchor),
            finLabel.leadingAnchor.constraint(equalTo: inicioLabel.trailingAnchor, constant: 8),
            finLabel.widthAnchor.constraint(equalTo: rowView.widthAnchor, multiplier: 0.24),
            
            estadoLabel.topAnchor.constraint(equalTo: fechaLabel.bottomAnchor, constant: 8),
            estadoLabel.leadingAnchor.constraint(equalTo: fechaLabel.leadingAnchor),
            estadoLabel.widthAnchor.constraint(equalToConstant: 90),
            estadoLabel.heightAnchor.constraint(equalToConstant: 20),
            
            separator.topAnchor.constraint(equalTo: estadoLabel.bottomAnchor, constant: 14),
            separator.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: rowView.bottomAnchor)
        ])
    }
    
    func configure(with horario: HorarioDoctor) {
        fechaLabel.text = formatDate(horario.fecha)
        inicioLabel.text = cleanTime(horario.horaInicio)
        finLabel.text = cleanTime(horario.horaFin)
        
        if !horario.activo {
            estadoLabel.text = "Inactivo"
            estadoLabel.backgroundColor = UIColor.systemGray5
            estadoLabel.textColor = .secondaryLabel
        } else if horario.reservado {
            estadoLabel.text = "Reservado"
            estadoLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.12)
            estadoLabel.textColor = .systemRed
        } else {
            estadoLabel.text = "Disponible"
            estadoLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            estadoLabel.textColor = .systemGreen
        }
    }
    
    private func cleanTime(_ value: String) -> String {
        if value.count >= 5 {
            return String(value.prefix(5))
        }
        return value
    }
    
    private func formatDate(_ value: String) -> String {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd"
        input.locale = Locale(identifier: "es_PE")
        
        guard let date = input.date(from: value) else {
            return value
        }
        
        let output = DateFormatter()
        output.dateFormat = "EEEE, d 'de' MMMM"
        output.locale = Locale(identifier: "es_PE")
        
        return output.string(from: date).capitalized
    }
}
