//
//  ProgressViewController.swift
//  trainingtask
//
//  Created by Alex on 23.01.24.
//

import UIKit

/// контроллер индикатора прогресса.
/// способен пказывать спиннер загрузки, иконку удачи или ошибки и кастомное сообщение
/// показывается в отдельном`UIWindow` поверх всего экрана
///
/// для использования необходимо создать экземпляр данного класса метод
class MyProgressViewController: UIViewController {
    // MARK: - Root View
    private let progressView = MyProgressView()

    // MARK: - Properties
    /// перечисление с возможными состояниями контроллера
    enum Progress {
        case loading
        case ok
        case error
    }
    
    private var status = Progress.loading
    private var message = ""
    private var overlayWindow: UIWindow?
    private var isShown = false
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        super.loadView()
        self.view = progressView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    /// метод, который показывает в отдельном`UIWindow` поверх всего экрана спиннер загрузки и кастомное сообщение
    /// - Important: чтобы скрыть окно, необхходимо вызвать ``stopLoad(successfully:with:)``
    /// - Parameter message: сообщение которое будет показано под спиннером загрузки
    func startLoad(with message: String) {
        showOverlay()
        self.status = .loading
        self.message = message
        updateView()
    }
    
    /// метод, который показывает  в отдельном`UIWindow` поверх всего экрана иконку удачи или ошибки и кастомное сообщение
    /// - Important: автоматически скрывает окно через некоторое время
    /// - Parameters:
    ///   - successfully: параметр, определяющий показывать иконку удачи или ошибки
    ///   - message: сообщение которое будет показано под иконкой
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
        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(1500))) {
            self.hideOverlay()
        }
    }
    
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
}
