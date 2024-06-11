//
//  DetailViewController.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 11.06.24.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let initialIndex: Int
    private var currentIndex: Int
    private let pageViewController: UIPageViewController
    private var isFavourite = false

    private weak var viewModel: ImageViewModelProtocol?
    private weak var delegate: DetailDelegate?

    private var heartIcon: UIImage? {
        if self.isFavourite {
            return UIImage(systemName: "heart.fill")
        } else {
            return UIImage(systemName: "heart")        }
    }

    init(initialIndex: Int, viewModel: ImageViewModel, delegate: DetailDelegate) {
        self.initialIndex = initialIndex
        self.currentIndex = initialIndex
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        let barItem = UIBarButtonItem(image: heartIcon, style: .plain, target: self, action: #selector(addToFavourite))

        self.navigationItem.rightBarButtonItem = barItem
        pageViewController.dataSource = self
        pageViewController.delegate = self

        let initialViewController = createDetailPageViewController(for: initialIndex)
        pageViewController.setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        configureButton()
    }

    func createDetailPageViewController(for index: Int) -> DetailPageViewController {
        guard let imageInfo = viewModel?.imagesInfo[index], let viewModel = self.viewModel as? ImageViewModel
        else { fatalError("Missing data")}
        configureButton()
        return DetailPageViewController(imageInfo: imageInfo, viewModel: viewModel)
    }

    func configureButton() {
        guard let viewModel = self.viewModel else { return }
        self.isFavourite = viewModel.checkIfSaved(id: viewModel.imagesInfo[currentIndex].id)
        navigationItem.rightBarButtonItem?.image = heartIcon
        delegate?.updateIndicators()
    }

    @objc private func addToFavourite() {
        guard let viewModel = self.viewModel else { return }
        let currentImageInfo = viewModel.imagesInfo[currentIndex]

        if viewModel.checkIfSaved(id: currentImageInfo.id) {
            viewModel.deleteImageFromFavourite(imageInfo: currentImageInfo)
        } else {
            viewModel.saveImageToFavourites(imageInfo: currentImageInfo)
        }
        configureButton()
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentViewController = viewController as? DetailPageViewController else { return nil }
        let currentIndex = viewModel?.imagesInfo.firstIndex(where: { $0.id == currentViewController.imageInfo.id })
        guard let index = currentIndex, index > 0 else { return nil }
        let previousIndex = index - 1
        return createDetailPageViewController(for: previousIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewModel = self.viewModel else { fatalError("no view model found") }
        guard let currentViewController = viewController as? DetailPageViewController else { return nil }
        let currentIndex = viewModel.imagesInfo.firstIndex(where: { $0.id == currentViewController.imageInfo.id })
        guard let index = currentIndex, index < viewModel.imagesInfo.count - 1 else { return nil }
        let nextIndex = index + 1
        return createDetailPageViewController(for: nextIndex)
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentViewController = pageViewController.viewControllers?.first as? DetailPageViewController,
           let currentIndex = viewModel?.imagesInfo.firstIndex(where: { $0.id == currentViewController.imageInfo.id }) {
            self.currentIndex = currentIndex
            configureButton()
        }
    }

}
