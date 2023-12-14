//
//  TableViewCell.swift
//  TestApp
//
//  Created by ульяна on 13.12.23.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {

    private var id = UILabel()
    private var name = UILabel()
    private var image = UIImageView()

    func configure(photoTypeDtoOut: PhotoTypeDtoOut) {
        setUpUi()
        self.id.text = "Id - " + (photoTypeDtoOut.id?.description ?? "0")
        self.name.text = photoTypeDtoOut.name
        guard let urlString = photoTypeDtoOut.image,
              let url = URL(string: urlString) else { return }
        self.image.kf.setImage(with: url)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpUi() {
        
        self.image.translatesAutoresizingMaskIntoConstraints = false
        self.image.contentMode = .scaleToFill
        self.contentView.addSubview(image)
        
        NSLayoutConstraint.activate([
            self.image.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.image.widthAnchor.constraint(equalToConstant: 90),
            self.image.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        self.name.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        self.name.textAlignment = .left
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(name)
        
        NSLayoutConstraint.activate([
            self.name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            self.name.leadingAnchor.constraint(equalTo: self.image.trailingAnchor, constant: 14),
            self.name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            self.name.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        self.id.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.id.textColor = .green
        self.id.textAlignment = .left
        self.id.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(id)
        
        NSLayoutConstraint.activate([
            self.id.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            self.id.leadingAnchor.constraint(equalTo: self.image.trailingAnchor, constant: 14 ),
            self.id.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            self.id.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
