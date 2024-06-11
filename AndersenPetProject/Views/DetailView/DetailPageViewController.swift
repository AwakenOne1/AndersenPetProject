//
//  DetailPageViewController.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 11.06.24.
//

import UIKit
import SnapKit

final class DetailPageViewController: UIViewController {
    let imageInfo: ImageInfo
    weak var viewModel: ImageViewModelProtocol?

    private var isFavourite = false

    private let slugLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let imageView: UIImageView = UIImageView(frame: .zero)

    init(imageInfo: ImageInfo, viewModel: ImageViewModel) {
        self.imageInfo = imageInfo
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureSubviews()
        setupConstraints()
        configureImage()
    }

    private func configureImage() {
        DispatchQueue.global().async { [weak self] in
            if let url = self?.imageInfo.urls.smallURL {
                self?.viewModel?.fetchImageForInfo(url: url) { image in
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(slugLabel)
        view.addSubview(descriptionLabel)
    }
    private func configureSubviews() {
        view.backgroundColor = .black

        slugLabel.text = imageInfo.slug
        slugLabel.numberOfLines = Constants.numberOfLines.rawValue
        slugLabel.textAlignment = .center
        slugLabel.textColor = .white

        descriptionLabel.text = imageInfo.altDescription
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = Constants.numberOfLines.rawValue

    }
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.imageViewInset.rawValue)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.imageViewInset.rawValue)
        }
        slugLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.slugTopInset.rawValue)
            make.leading.trailing.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Constants.bottomInset.rawValue)
            make.leading.trailing.equalToSuperview().inset(Constants.sideInset.rawValue)
        }
    }

}
