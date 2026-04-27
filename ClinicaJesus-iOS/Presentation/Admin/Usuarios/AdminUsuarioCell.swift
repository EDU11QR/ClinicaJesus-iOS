//
//  AdminUsuarioCell.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import UIKit

final class AdminUsuarioCell: UITableViewCell {
    
    static let identifier = "AdminUsuarioCell"
    
    var onRoleTapped: (() -> Void)?
    var onDeactivateTapped: (() -> Void)?
    
    private let initialsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.12)
        label.textColor = .systemTeal
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        return label
    }()
    
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let emailLabel = UILabel()
    private let phoneLabel = UILabel()
    private let roleButton = UIButton(type: .system)
    private let deactivateButton = UIButton(type: .system)
    
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
        
        nameLabel.font = .boldSystemFont(ofSize: 14)
        usernameLabel.font = .systemFont(ofSize: 12)
        usernameLabel.textColor = .secondaryLabel
        
        emailLabel.font = .systemFont(ofSize: 12)
        emailLabel.textColor = .secondaryLabel
        phoneLabel.font = .systemFont(ofSize: 12)
        phoneLabel.textColor = .secondaryLabel
        
        roleButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
        roleButton.layer.cornerRadius = 12
        roleButton.configuration = .plain()
        roleButton.configuration?.contentInsets = NSDirectionalEdgeInsets(
            top: 6,
            leading: 12,
            bottom: 6,
            trailing: 12
        )
        roleButton.addTarget(self, action: #selector(didTapRole), for: .touchUpInside)
        
        deactivateButton.setImage(UIImage(systemName: "person.crop.circle.badge.xmark"), for: .normal)
        deactivateButton.tintColor = .systemRed
        deactivateButton.addTarget(self, action: #selector(didTapDeactivate), for: .touchUpInside)
        
        deactivateButton.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        
        [initialsLabel, nameLabel, usernameLabel, emailLabel, phoneLabel, roleButton, deactivateButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            initialsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            initialsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            initialsLabel.widthAnchor.constraint(equalToConstant: 40),
            initialsLabel.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: initialsLabel.trailingAnchor, constant: 12),
            nameLabel.widthAnchor.constraint(equalToConstant: 105),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            usernameLabel.widthAnchor.constraint(equalToConstant: 105),
            
            emailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            emailLabel.widthAnchor.constraint(equalToConstant: 135),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 6),
            phoneLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            phoneLabel.widthAnchor.constraint(equalToConstant: 135),
            
            roleButton.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10),
            roleButton.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            
            deactivateButton.centerYAnchor.constraint(equalTo: roleButton.centerYAnchor),
            deactivateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            deactivateButton.widthAnchor.constraint(equalToConstant: 34),
            deactivateButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        contentView.bringSubviewToFront(deactivateButton)
        
    }
    
    func configure(usuario: Usuario) {
        let nombre = usuario.nombre ?? ""
        let apellido = usuario.apellido ?? ""
        
        nameLabel.text = "\(nombre) \(apellido)"
        usernameLabel.text = "@\(nombre.lowercased())"
        emailLabel.text = "✉️ \(usuario.correo)"
        phoneLabel.text = "📞 \(usuario.telefono ?? "-")"
        
        initialsLabel.text = "\(nombre.prefix(1))\(apellido.prefix(1))".uppercased()
        
        roleButton.setTitle(usuario.rol, for: .normal)
        
        //------BLOQUEA INTERACCION CUANDO NO CORRESPONDE
        roleButton.isEnabled = usuario.activo
        roleButton.alpha = usuario.activo ? 1.0 : 0.5
        
        switch usuario.rol {
        case "ADMIN":
            roleButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
            roleButton.setTitleColor(.systemRed, for: .normal)
        case "DOCTOR":
            roleButton.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.15)
            roleButton.setTitleColor(.systemTeal, for: .normal)
        default:
            roleButton.backgroundColor = UIColor.systemGray5
            roleButton.setTitleColor(.darkGray, for: .normal)
        }
        
        if usuario.rol == "DOCTOR" {
            roleButton.layer.borderWidth = 1
            roleButton.layer.borderColor = UIColor.systemTeal.cgColor
        } else if usuario.rol == "ADMIN" {
            roleButton.layer.borderWidth = 1
            roleButton.layer.borderColor = UIColor.systemRed.cgColor
        } else {
            roleButton.layer.borderWidth = 0
        }
        
        deactivateButton.isHidden = false
        deactivateButton.isEnabled = true
        deactivateButton.alpha = 1.0
        deactivateButton.tintColor = usuario.activo == true ? .systemRed : .systemGreen
        deactivateButton.setImage(
            UIImage(systemName: usuario.activo == true ? "person.crop.circle.badge.xmark" : "person.crop.circle.badge.checkmark"),
            for: .normal
        )
    }
    
    @objc private func didTapRole() {
        onRoleTapped?()
    }
    
    @objc private func didTapDeactivate() {
        onDeactivateTapped?()
    }
}
