//
//  ChatViewController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 11.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation

import UIKit

class MessageView: UIView {
    let userNameAndTimeLabel = UILabel()
    let textLabel = UILabel()

    let contentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = UIColor.ray_background

        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(textLabel)

        userNameAndTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameAndTimeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        contentView.addSubview(userNameAndTimeLabel)

        contentView.snp.makeConstraints { maker in
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
            maker.leading.equalTo(self.snp.leadingMargin)
            maker.trailing.equalTo(self.snp.trailingMargin)
        }

        textLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(contentView.snp.leading).offset(8)
            maker.trailing.equalTo(contentView.snp.trailing).offset(-8)
            maker.bottom.equalTo(self).offset(-8)
        }

        userNameAndTimeLabel.snp.makeConstraints { maker in
            maker.top.equalTo(contentView).offset(8)
            maker.leading.equalTo(textLabel)
            maker.bottom.equalTo(textLabel.snp.top)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatViewController: UIViewController
{
    private let scrollView = UIScrollView()
    private let contentScrollView = UIView()

    private var chat: Sh_Generated_Chat

    init(chat: Sh_Generated_Chat) {
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = "Чат"

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentScrollView)

        scrollView.snp.makeConstraints { maker in
            maker.edges.equalTo(view)
        }

        contentScrollView.snp.makeConstraints { maker in
            maker.edges.width.equalTo(scrollView)
        }

        var prevName: String? = nil
        var left: Bool = true

        let views = chat.messages.map { message -> MessageView in
            if message.authorNickname != prevName {
                prevName = message.authorNickname
                left = !left
            }

            let messageView = MessageView(frame: .zero)
            messageView.translatesAutoresizingMaskIntoConstraints = false
            if left {
                messageView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 100)
            } else {
                messageView.layoutMargins = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 12)
            }

            messageView.userNameAndTimeLabel.text = message.authorNickname + ":"
            messageView.textLabel.text = message.text

            return messageView

        }

        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = 8

        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentScrollView.addSubview(stackView)

        stackView.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(contentScrollView)
            maker.top.equalTo(contentScrollView).offset(8)
            maker.bottom.equalTo(contentScrollView).offset(-8)
        }
    }
}
