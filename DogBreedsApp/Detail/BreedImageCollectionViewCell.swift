//
//  BreedImageCollectionViewCell.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//

import UIKit

final class BreedImageCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "BreedImageCollectionViewCellId"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: contentView.bounds)
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let btn = UIButton(type: .system)
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let favImage = UIImage(systemName: "heart", withConfiguration: boldConfig)
        btn.setImage(favImage, for: .normal)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.tintColor = .systemRed
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(imageView)
        imageView.addSubview(likeButton)
        
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 46),
            likeButton.widthAnchor.constraint(equalToConstant: 46),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            likeButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8)
        ])
    }
    
    func setContent(imagePath: String) {
        imageView.downloadImage(from: imagePath)
        imageView.contentMode = .scaleAspectFill
    }
}
