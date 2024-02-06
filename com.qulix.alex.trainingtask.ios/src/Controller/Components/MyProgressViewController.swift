//
//  ProgressViewController.swift
//  trainingtask
//
//  Created by Alex on 23.01.24.
//

import UIKit

class MyProgressViewController: UIViewController {

    enum Progress {
        case loading
        case ok
        case error
    }
    
    private var status = Progress.loading
    private var message = "Loading..."
    private var overlayWindow: UIWindow?
    
    private func showOverlay() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        overlayWindow = UIWindow(windowScene: windowScene)
        overlayWindow?.windowLevel = .alert
        overlayWindow?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlayWindow?.windowScene = windowScene
        overlayWindow?.rootViewController = self
        overlayWindow?.backgroundColor = .clear
        
        overlayWindow?.makeKeyAndVisible()
    }
    
    private func hideOverlay() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }
    
    private func updateView() {
        let progressView = self.view as! MyProgressView
        switch status {
        case .loading:
            progressView.statusImage.isHidden = true
            progressView.spinner.startAnimating()
        case .ok:
            progressView.spinner.stopAnimating()
            progressView.statusImage.isHidden = false
            progressView.statusImage.image = UIImage(systemName: Strings.okImage)
        case .error:
            progressView.spinner.stopAnimating()
            progressView.statusImage.isHidden = false
            progressView.statusImage.image = UIImage(systemName: Strings.errorImage)
        }
        progressView.message.text = message
    }
    
    func startLoad(with message: String) {
        showOverlay()
        self.status = .loading
        self.message = message
        updateView()
    }
    
    func stopLoad(successfully: Bool, with message: String) {
        if successfully {
            status = .ok
        } else {
            status = .error
        }
        self.message = message
        updateView()
        Task {
            try? await Task.sleep(nanoseconds:1_000_000_000)
            hideOverlay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = MyProgressView()
    }
}
