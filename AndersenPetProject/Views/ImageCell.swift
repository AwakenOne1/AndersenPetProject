//
//  ImageCell.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import UIKit
import SnapKit

final class ImageCell: UICollectionViewCell {
    var imageView: UIImageView = UIImageView()
    var favouriteImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        favouriteImage.image = UIImage(systemName: "heart.fill")
        addSubview(favouriteImage)
        favouriteImage.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(15)
        }
        favouriteImage.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        self.imageView.image = nil
    }
}
