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
    private var message = ""
    private var overlayWindow: UIWindow?
    private var isShown = false
    
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
        isShown = true
    }
    
    private func hideOverlay() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
        isShown = false
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
        if !isShown {
            showOverlay()
        }
        if successfully {
            status = .ok
        } else {
            status = .error
        }
        self.message = message
        updateView()
        Task {
            try? await Task.sleep(nanoseconds:1_500_000_000)
            hideOverlay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = MyProgressView()
    }
}
