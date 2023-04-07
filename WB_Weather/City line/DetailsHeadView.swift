//
//  DetailsHeadView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

protocol DetailsHeaderViewDelegate: AnyObject {
    func openMoreInfoView()
}

final class DetailsHeadView: UITableViewHeaderFooterView {

    private lazy var label = UILabel()
    weak var delegate: DetailsHeaderViewDelegate?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = .blue
        self.setupLabel()
        self.setupGestures()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupLabel() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.clipsToBounds = true
        self.label.isUserInteractionEnabled = true
        self.label.text = "More info for 24 hours"
        self.label.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        self.contentView.addSubview(self.label)

        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.label.addGestureRecognizer(tapGestureRecognizer)

    }

    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.openMoreInfoView()
    }

}
