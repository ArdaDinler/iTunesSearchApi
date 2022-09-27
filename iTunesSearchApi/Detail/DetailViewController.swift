//
//  DetailViewController.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import UIKit

class DetailViewController: UIViewController {

    var image: UIImage!

    override func loadView() {
        navigationController?.navigationBar.layoutIfNeeded()

        view = UIView()
        view.backgroundColor = .white
        view.largeContentTitle = "Detail"

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: (self.navigationController?.navigationBar.frame.maxY ?? 0) - 10),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(imageView)

    }
}
