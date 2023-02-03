//
//  FullscreenImageViewController.swift
//  Cats
//
//  Created by Wallace Silva on 02/02/23.
//

import UIKit

class FullscreenImageViewController: UIViewController {
    
    // MARK: - Enums
    
    private enum BarButtonState: String {
        case expand = "arrow.up.backward.and.arrow.down.forward"
        case contract = "arrow.down.forward.and.arrow.up.backward"
        
        var image: UIImage? {
            UIImage(systemName: rawValue)
        }
    }
    
    // MARK: - Constants
    
    private let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.bounces = true
        view.bouncesZoom = true
        view.maximumZoomScale = 10.0
        return view
    }()
    
    private let url: URL
    
    // MARK: - Variables
    
    private var barButtonState: BarButtonState = .expand {
        didSet {
            placeBarButtonItem()
        }
    }
    
    //MARK: - Initializers
    
    required init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        placeBarButtonItem()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ImageDownloadManager.shared.fetchImage(for: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.present(image: image)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func doubleTap(_ sender: UITapGestureRecognizer) {
        switch barButtonState {
        case .expand:
            zoomOut(animated: true)
        case .contract:
            zoomIn(animated: true)
        }
    }
    
    @objc
    private func barButtonItemTapped(_ sender: UIBarButtonItem) {
        switch barButtonState {
        case .expand:
            zoomIn(animated: true)
        case .contract:
            zoomOut(animated: true)
        }
    }
    
    // MARK: - Layout
    
    private func addScrollView() {
        view.addSubview(scrollView)
        scrollView
            .topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
        scrollView
            .bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
        scrollView
            .leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
            .isActive = true
        scrollView
            .trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
            .isActive = true
        scrollView.delegate = self
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                action: #selector(doubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
        
    func placeBarButtonItem() {
        let barButtonItem = UIBarButtonItem(image: barButtonState.image,
                                            style: .plain,
                                            target: self,
                                            action: #selector(barButtonItemTapped))
        navigationItem.setRightBarButton(barButtonItem, animated: true)
    }
    
    private func zoomIn(animated: Bool = false) {
        scrollView.setZoomScale(1.0, animated: animated)
    }
    
    private func zoomOut(animated: Bool = false) {
        scrollView.zoom(to: imageView.bounds, animated: animated)
    }
    
    private func present(image: UIImage?) {
        imageView.image = image
        imageView.sizeToFit()
        scrollView.addSubview(imageView)
        scrollView.minimumZoomScale = scrollView.safeAreaLayoutGuide.layoutFrame.width/imageView.bounds.width
        zoomOut()
    }
}

// MARK: - UIScrollViewDelegate
extension FullscreenImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            barButtonState = .contract
        } else {
            barButtonState = .expand
        }
    }
}
