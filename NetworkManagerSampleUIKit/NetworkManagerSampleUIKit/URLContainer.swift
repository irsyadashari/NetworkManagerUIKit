//
//  URLContainer.swift
//  NetworkManagerSampleUIKit
//
//  Created by Irsyad Ashari on 28/05/24.
//
// https://dmytro-anokhin.medium.com/notification-in-swift-d47f641282fa

import Foundation

extension NSNotification.Name {
    public static let URLContainerDidAddURL
    = NSNotification.Name("URLContainerDidAddURL")
}

class URLContainer {
    static let urlKey = "URL"
    private (set) var urls: [URL] = []
    
    func add(_ url: URL) {
        urls.append(url)
        NotificationCenter.default.post(
            name: .URLContainerDidAddURL,
            object: self,
            userInfo: [URLContainer.urlKey: url])
    }
}

class NotificationsURLHandler {
    private var observer: AnyObject?
    
//    func subscribe(for container: URLContainer) { // another method for observing events emition
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(urlContainerDidChange(_:)),
//                                               name: .URLContainerDidAddURL,
//                                               object: container)
//    }
//    @objc
//    func urlContainerDidAddURL(_ notification: Notification) {
//        let url = notification.userInfo?[URLContainer.urlKey]
//        print(url)
//    }
    
    func subscribe(for container: URLContainer) {
        guard observer == nil else { return }
        observer = NotificationCenter.default.addObserver(
            forName: .URLContainerDidAddURL,
            object: container,
            queue: nil) { [weak self] notification in
                guard let weakSelf = self else { return }
                let url = notification.userInfo?[URLContainer.urlKey]
                print(weakSelf.observer ?? "")
            }
    }
    func unsubscribe() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
            self.observer = nil
        }
    }
    
    deinit {
        unsubscribe()
    }
}
