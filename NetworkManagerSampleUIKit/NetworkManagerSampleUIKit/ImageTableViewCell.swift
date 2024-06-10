//
//  ImageTableViewCell.swift
//  NetworkManagerSampleUIKit
//
//  Created by Irsyad Ashari on 07/05/24.
//

import UIKit

protocol ImageTableViewCellDelegate: NSObjectProtocol {
    func didTapImage(index: Int)
}

final class ImageTableViewCell: UITableViewCell {
    weak var delegate: ImageTableViewCellDelegate?
    var index: Int?
    private lazy var myImageView = UIImageView()
    private lazy var labelView = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(labelView)
        contentView.addSubview(myImageView)
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        myImageView.addGestureRecognizer(tapImage)
        myImageView.isUserInteractionEnabled = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        if let index {
            delegate?.didTapImage(index: index)
        }
    }
    
    private func setupConstraints() {
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        labelView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.leadingAnchor.constraint(equalTo: labelView.leadingAnchor).isActive = true
        myImageView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 8).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        myImageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        myImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configure(imageURL: String, text: String) {
        myImageView.loadImageFromURL(urlString: imageURL)
        labelView.text = text
    }
}
