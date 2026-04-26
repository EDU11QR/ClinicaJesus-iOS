//
//  AdminEspecialidadCell.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import UIKit

final class AdminEspecialidadCell: UITableViewCell {
    
    static let identifier = "AdminEspecialidadCell"
    
    var onEditTapped: (() -> Void)?
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "stethoscope")
        imageView.tintColor = .systemTeal
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let statusLabel = UILabel()
    private let editButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) no ha sido implementado")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        nameLabel.font = .boldSystemFont(ofSize: 15)
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 1
        
        priceLabel.font = .boldSystemFont(ofSize: 13)
        priceLabel.textColor = .systemTeal
        
        statusLabel.font = .boldSystemFont(ofSize: 12)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 10
        statusLabel.clipsToBounds = true
        
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.tintColor = .systemBlue
        editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        
        [iconView, nameLabel, descriptionLabel, priceLabel, statusLabel, editButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 34),
            iconView.heightAnchor.constraint(equalToConstant: 34),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -8),
            statusLabel.widthAnchor.constraint(equalToConstant: 72),
            statusLabel.heightAnchor.constraint(equalToConstant: 24),
            
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            editButton.widthAnchor.constraint(equalToConstant: 36),
            editButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func configure(especialidad: Especialidad) {
        nameLabel.text = especialidad.nombre
        descriptionLabel.text = especialidad.descripcion ?? "Sin descripción"
        
        let precio = especialidad.precio ?? 0
        priceLabel.text = "S/ \(String(format: "%.2f", precio))"
        
        if especialidad.activo {
            statusLabel.text = "Activa"
            statusLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            statusLabel.textColor = .systemGreen
        } else {
            statusLabel.text = "Inactiva"
            statusLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
            statusLabel.textColor = .systemRed
        }
    }
    
    @objc private func didTapEdit() {
        onEditTapped?()
    }
}
