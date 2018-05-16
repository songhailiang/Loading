//
//  Loading.swift
//  Loading
//
//  Created by songhailiang on 2018/5/9.
//  Copyright © 2018 songhailiang. All rights reserved.
//

import UIKit

/**
 configuration options for Loading
 */
public struct LoadingConfig {

    /// both width & height, default is 40.0
    public var width: CGFloat = 40.0

    /// corner radius, default is 5.0
    public var radius: CGFloat = 5.0

    /// if value > 0, Loading will force to hide if more than this interval, default is 30
    public var maxUnlockTime: TimeInterval = 30

    /// indicator view style, default is .white
    public var style: UIActivityIndicatorViewStyle = .white

    /// indicator color, default is UIColor.white
    public var color: UIColor = UIColor.white

    /// background color for indicator container view
    public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5)
}

/**
 A top most indicator view.
 */
public class Loading {
    private static let shared = Loading()
    private var config = LoadingConfig()
    private let loadingController: LoadingController
    private let loadingWindow: UIWindow
    private var timer: Timer?

    init() {
        loadingController = LoadingController()
        loadingWindow = UIWindow(frame: UIScreen.main.bounds)
        loadingWindow.windowLevel = UIWindowLevelAlert + 1
        loadingWindow.rootViewController = loadingController
    }

    /// update configuration
    ///
    /// - Parameter config: new configuration data
    public static func config(_ config: LoadingConfig) {
        shared.config = config
        shared.loadingController.config = config
    }

    /// show Loading
    public static func show() {
        shared.loadingWindow.makeKeyAndVisible()
        shared.startUnlockTimer()
    }

    /// hide Loading
    public static func hide() {
        shared.loadingWindow.isHidden = true
        shared.stopUnlockTimer()
    }

    private func startUnlockTimer() {
        if config.maxUnlockTime <= 0 {
            return
        }
        if timer != nil {
            stopUnlockTimer()
        }
        timer = Timer.after(config.maxUnlockTime, mode: .commonModes, {
            Loading.hide()
        })
    }

    private func stopUnlockTimer() {
        timer?.invalidate()
        timer = nil
    }
}

fileprivate class LoadingController: UIViewController {

    private var loadingView: LoadingView!
    fileprivate var config = LoadingConfig() {
        didSet {
            if isViewLoaded && view != nil {
                updateLoadingView()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.addSubview(loadingView)
        updateLoadingView()
    }

    override func viewDidLayoutSubviews() {
        loadingView.center = self.view.center
    }

    private func updateLoadingView() {
        loadingView.bounds.size = CGSize(width: config.width, height: config.width)
        loadingView.layer.cornerRadius = config.radius
        loadingView.backgroundColor = config.backgroundColor
        loadingView.indicator.activityIndicatorViewStyle = config.style
        loadingView.indicator.color = config.color
    }
}

fileprivate class LoadingView: UIView {

    fileprivate var indicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: .white)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(indicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        indicator.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
}
