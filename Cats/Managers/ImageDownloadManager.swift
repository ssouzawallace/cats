//
//  ImageDownloadManager.swift
//  Cats
//
//  Created by Wallace Silva on 02/02/23.
//

import UIKit
import CoreData

class ImageDownloadManager {
    
    static let shared = ImageDownloadManager() // Singleton
    
    private var localCache = [URL: UIImage?]()
    
    private let container: NSPersistentContainer
    
    private var isCoreDataReady = false
    
    private init() {
        container = NSPersistentContainer(name: "Cats")
        container.viewContext.automaticallyMergesChangesFromParent = true
        loadImagesFromDisk()
    }
    
    private func loadImagesFromDisk() {
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print(error)
            } else {
                do {
                    let request: NSFetchRequest<Image> = NSFetchRequest(entityName: "Image")
                    let result = try self.container.viewContext.fetch(request)
                    try result.forEach { image in
                        guard let url = image.url, let data = image.data, let response = image.response else { return }
                        let urlRequest = URLRequest(url: url)
                        if let urlResponse = try NSKeyedUnarchiver.unarchivedObject(ofClass: URLResponse.self,
                                                                                from: response) {
                            let cachedResponse = CachedURLResponse(response: urlResponse,
                                                                   data: data)
                            URLCache.shared.storeCachedResponse(cachedResponse,
                                                                for: urlRequest)
                        }
                        
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func fetchImage(for url: URL, with completion: @escaping (UIImage?) -> Void) {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        
        if let image = localCache[url] { // Cache L1
            completion(image)
        } else if let cachedResponseData = URLCache.shared.cachedResponse(for: request)?.data { // Cache L2
            let image = UIImage(data: cachedResponseData)
            completion(image)
        } else {
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let data = data, let response = response else { return completion(nil) }
                let cachedUrlResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedUrlResponse, for: request)
                DispatchQueue.global(qos: .background).async {
                    self?.saveImageOnDisk(data: data, response: response, for: url)
                }
                
                let image = UIImage(data: data)
                self?.localCache[url] = image
                completion(image)
            }
            .resume()
        }
    }
    
    private func saveImageOnDisk(data: Data, response: URLResponse, for url: URL) {
        do {
            let encodedResponse = try NSKeyedArchiver.archivedData(withRootObject: response,
                                                                   requiringSecureCoding: false)
            
            let viewContext = container.viewContext
            
            let image = Image(context: viewContext)
            image.response = encodedResponse
            image.data = data
            image.url = url
            
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func cancelFetchImage(for url: URL?) {
        URLSession.shared.getAllTasks { tasks in
            tasks.first { task in
                task.originalRequest?.url == url
            }?.cancel()
        }
    }
    
    func hasCachedImage(for url: URL) -> Bool {
        if localCache[url] != nil {
            return true
        } else {
            let request = URLRequest(url: url)
            return URLCache.shared.cachedResponse(for: request)?.data != nil
        }
    }
}
