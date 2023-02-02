//
//  CatsViewController.swift
//  Cats
//
//  Created by Wallace Silva on 02/02/23.
//

import UIKit

class CatsViewController: UICollectionViewController {
    
    // MARK: - Constants
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        view.startAnimating()
        return view
    }()
    
    private let emptyStateView: UIView = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .largeTitle)
        view.text = "No cats found! :("
        return view
    }()
    
    // MARK: - Variables
    
    private var viewModel: CatsViewModel?
    
    private var cats = [CatModel]() {
        didSet {
            loadingView.stopAnimating()
            emptyStateView.isHidden = !cats.isEmpty
            collectionView.refreshControl?.endRefreshing()
            collectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cats"
                
        viewModel = CatsViewModel(view: self)
                
        addLoadingView()
        addEmptyStateView()
        
        collectionView.register(CollectionViewItemImageCell.self)
        
        loadCats()
    }
    
    private func loadCats() {
        emptyStateView.isHidden = true
        viewModel?.fetchImages()
    }
    
    // MARK: Layout
    
    private func addRefreshControl() {
        collectionView.refreshControl = UIRefreshControl(frame: .zero,
                                                         primaryAction: UIAction { [weak self] _ in
            self?.loadCats()
        })
    }
    
    private func addLoadingView() {
        view.addSubview(loadingView)
        loadingView
            .centerXAnchor
            .constraint(equalTo: view.centerXAnchor)
            .isActive = true
        loadingView
            .centerYAnchor
            .constraint(equalTo: view.centerYAnchor)
            .isActive = true
    }
    
    private func addEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView
            .centerXAnchor
            .constraint(equalTo: view.centerXAnchor)
            .isActive = true
        emptyStateView
            .centerYAnchor
            .constraint(equalTo: view.centerYAnchor)
            .isActive = true
        emptyStateView.isHidden = true
    }
}

// MARK: - UICollectionViewDelegate
extension CatsViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cat = cats[indexPath.row]
        if ImageDownloadManager.shared.hasCachedImage(for: cat.url) {
            Coordinator.presentFullScreenImage(for: cat, sender: self)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CollectionViewItemImageCell else { return }
        cell.url = nil
    }
}

// MARK: - UICollectionViewDataSource
extension CatsViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cats.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let url = cats[indexPath.row].url
        guard let cell = collectionView.dequeueReusableCell(ofType: CollectionViewItemImageCell.self, for: indexPath) else { return UICollectionViewCell() }
        cell.url = url
        return cell
    }
}

// MARK: - CatsGalleryView
extension CatsViewController: CatsGalleryView {
    func present(cats: [CatModel]) {
        self.cats = cats
        addRefreshControl()
    }
    
    func present(errorMessage message: String) {
        let message = message + "\nWill try again."
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { [weak self] _ in
            self?.loadCats()
        }))
        present(alert, animated: true)
    }
}
