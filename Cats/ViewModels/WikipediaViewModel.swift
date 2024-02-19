//
//  WikipediaViewModel.swift
//  Cats
//
//  Created by Wallace Souza Silva on 19/02/24.
//

import Foundation
import Combine

protocol WebViewLoader {
    func load(_ url: URL)
    func load(_ string: String)
}

struct WikipediaViewModel {
    let url: URL
    let subject: CurrentValueSubject<String, Never>
    let loader: WebViewLoader
    init(url: URL, subject: CurrentValueSubject<String, Never>) {
        self.url = url
        self.subject = subject
        struct DefaultWebViewLoader: WebViewLoader {
            func load(_ url: URL) { }
            func load(_ string: String) { }
        }
        self.loader = DefaultWebViewLoader()
    }
    
    func load() {
        loader.load(url)
    }
}

