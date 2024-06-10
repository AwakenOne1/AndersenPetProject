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

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        self.imageView.image = nil
    }
}
