//
//  DetailContactViewController.swift
//  FetchingUsers
//
//  Created by Alex Murphy on 24.10.2022.
//

import UIKit

public final class DetailContactViewController: UIViewController {

	private let primaryColor = UIColor(
		red: 76/255,
		green: 122/255,
		blue: 240/255,
		alpha: 1
	)

	private let secondaryColor = UIColor(
		red: 25/255,
		green: 42/255,
		blue: 90/255,
		alpha: 1
	)
	
    // MARK: - Interface
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var adressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var streetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public var result: Users!
	
    public override func viewDidLoad() {
        super.viewDidLoad()
		addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        view.addSubview(emailLabel)
        view.addSubview(phoneLabel)
        view.addSubview(userNameLabel)
        view.addSubview(adressLabel)
        view.addSubview(streetLabel)
        setValues(with: result)
        initializeConstraints()
    }
    private func setValues(with result: Users) {
        emailLabel.text = ("Email: \(result.email)")
        phoneLabel.text = ("Phone: \(result.phone)")
        userNameLabel.text = ("User name: \(result.username)")
        adressLabel.text = ("City: \(result.address.city)")
        streetLabel.text = ("Street: \(result.address.street), \(result.address.suite)")
    }

    // MARK: - Constraints
    private func initializeConstraints() {
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            emailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emailLabel.heightAnchor.constraint(equalToConstant: 50),
            
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.topAnchor,constant: 30),
            phoneLabel.heightAnchor.constraint(equalToConstant: 50),
            
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameLabel.topAnchor.constraint(equalTo: phoneLabel.topAnchor,constant: 30),
            userNameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            adressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            adressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            adressLabel.topAnchor.constraint(equalTo: userNameLabel.topAnchor,constant: 30),
            adressLabel.heightAnchor.constraint(equalToConstant: 50),
            
            streetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            streetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            streetLabel.topAnchor.constraint(equalTo: adressLabel.topAnchor,constant: 30),
            streetLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Background color
extension DetailContactViewController {
	func addVerticalGradientLayer(topColor: UIColor, bottomColor: UIColor) {
		let gradient = CAGradientLayer()
		gradient.frame = view.bounds
		gradient.colors = [topColor.cgColor, bottomColor.cgColor]
		gradient.locations = [0.0, 1.0]
		gradient.startPoint = CGPoint(x:0, y: 0)
		gradient.endPoint = CGPoint(x: 0, y: 1)
		view.layer.insertSublayer(gradient, at: 0)
	}
}
