//
//  CollectionViewItemImageCell.swift
//  Cats
//
//  Created by Wallace Silva on 02/02/23.
//

import UIKit

class CollectionViewItemImageCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()
    
    // MARK: - Variables
    
    var url: URL? {
        willSet {
            if newValue == nil {
                ImageDownloadManager.shared.cancelFetchImage(for: url)
            }
        }
        didSet {
            clean()
            load()
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImageView()
        addActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clean()
    }
    
    private func clean() {
        imageView.image = nil
        showActivityIndicator()
    }
    
    private func load() {
        guard let url = url else {
            imageView.image = nil
            return
        }
        showActivityIndicator()
        ImageDownloadManager.shared.fetchImage(for: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.hideActivityIndicator()
                if self?.url != nil {
                    self?.imageView.image = image
                }
            }
        }
    }
    
    // MARK: Layout
    
    private func addImageView() {
        contentView.addSubview(imageView)
        imageView
            .leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
            .isActive = true
        imageView
            .topAnchor
            .constraint(equalTo: contentView.topAnchor)
            .isActive = true
        imageView
            .trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
            .isActive = true
        imageView
            .bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)
            .isActive = true
        imageView
            .widthAnchor
            .constraint(equalTo: imageView.heightAnchor)
            .isActive = true
    }
    
    private func addActivityIndicator() {
        contentView.addSubview(activityIndicator)
        activityIndicator
            .centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor)
            .isActive = true
        activityIndicator
            .centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
            .isActive = true
        activityIndicator.startAnimating()
    }
    
    private func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}
