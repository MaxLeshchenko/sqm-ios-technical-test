//
//  QuouteTableViewCell.swift
//  Technical-test
//
//  Created by Maksym Leshchenko on 19.04.2023.
//

import UIKit

class QuouteTableViewCell: UITableViewCell {
    
    static var identifier: String {
        "QuouteTableViewCell"
    }
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let changePercentLabel = UILabel()
    private let favoriteButton = UIButton()
    
    private var saveToFavoriteCompletion: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        favoriteButton.setImage(UIImage(named: "favorite"), for: .selected)
//        favoriteButton.setImage(UIImage(named: "no-favorite"), for: .normal)
        
        favoriteButton.addTarget(nil, action: #selector(saveToFavorites), for: .touchUpInside)
        
        [nameLabel, priceLabel, changePercentLabel, favoriteButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
                
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            priceLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 35),
            favoriteButton.heightAnchor.constraint(equalToConstant: 35),
            
            changePercentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            changePercentLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8)
        ])
    }
    
    func configure(with quote: Quote, saveToFavoriteCompletion: @escaping (() -> Void)) {
        self.saveToFavoriteCompletion = saveToFavoriteCompletion
        
        nameLabel.text = quote.name
        priceLabel.text = quote.last
        changePercentLabel.text = quote.readableLastChangePercent
        favoriteButton.setImage(quote.isFavorite ? UIImage(named: "favorite") : UIImage(named: "no-favorite"), for: .normal)
        
        if let textColor = quote.variationColor {
            changePercentLabel.textColor = UIColor(named: textColor)
        }
    }
    
    @objc private func saveToFavorites() {
        saveToFavoriteCompletion?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
