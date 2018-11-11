//
//  WebViewController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 11.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {

    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        webView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
