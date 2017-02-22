//
//  ImageCollectionViewCell.swift
//  iBooChallenge
//
//  Created by Jordi Serra i Font on 21/2/17.
//  Copyright © 2017 kudai. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    
    let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        contentView.addSubview(rootStackView)
        
        rootStackView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
            .isActive = true
        rootStackView.topAnchor
            .constraint(equalTo: contentView.topAnchor)
            .isActive = true
        rootStackView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
            .isActive = true
        rootStackView.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)
            .isActive = true
        
        rootStackView.addArrangedSubview(imageView)
        rootStackView.addArrangedSubview(titleLabel)
    }
    
    func configure(for image: ImagesList.Search.Presentable.ViewModel.Image) {
        
        titleLabel.text = image.title
        
        guard let url = URL(string: image.imageURL) else { return }
        imageView.sd_setImage(
            with: url,
            placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
    }
}
