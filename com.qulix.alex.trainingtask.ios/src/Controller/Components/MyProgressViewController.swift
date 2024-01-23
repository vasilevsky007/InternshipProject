//
//  ProgressViewController.swift
//  trainingtask
//
//  Created by Alex on 23.01.24.
//

import UIKit

class MyProgressViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var statusImage: UIImageView!
    
    enum Progress {
        case loading
        case ok
        case error
    }
    
    private var status = Progress.loading
    private var message = "Loading..."
    private var overlayWindow: UIWindow?
    static let shared = MyProgressViewController()
    
    private func showOverlay() {
        let overlayVC = MyProgressViewController.shared
        
        let overlayWidth: CGFloat = 200
        let overlayHeight: CGFloat = 150
        overlayVC.view.frame = CGRect(x: (UIScreen.main.bounds.width - overlayWidth) / 2,
                                      y: (UIScreen.main.bounds.height - overlayHeight) / 2,
                                      width: overlayWidth,
                                      height: overlayHeight)
        
        if let currentViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            currentViewController.view.addSubview(overlayVC.view)
            currentViewController.addChild(overlayVC)
            overlayVC.didMove(toParent: currentViewController)
        }
    }
    
    private func hideOverlay() {
        MyProgressViewController.shared.view.removeFromSuperview()
        MyProgressViewController.shared.removeFromParent()
    }
    
    private func updateView() {
        switch status {
        case .loading:
            statusImage.isHidden = true
            spinner.startAnimating()
        case .ok:
            spinner.hidesWhenStopped = true
            spinner.stopAnimating()
            statusImage.isHidden = false
            statusImage.image = UIImage(systemName: "checkmark")
        case .error:
            spinner.hidesWhenStopped = true
            spinner.stopAnimating()
            statusImage.isHidden = false
            statusImage.image = UIImage(systemName: "xmark")
        }
        statusLabel.text = message
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
        
        // Do any additional setup after loading the view.
        self.view.layer.cornerRadius = 8
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
