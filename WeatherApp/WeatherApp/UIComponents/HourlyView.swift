//
//  HourlyView.swift
//  WeatherApp
//

import UIKit

class HourlyView: UIView {

    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .systemGray
        timeLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
      }()

    lazy var weatherIconImage: UIImageView = {
        let weatherIconImage = UIImageView()
        weatherIconImage.contentMode = .scaleAspectFit
        weatherIconImage.translatesAutoresizingMaskIntoConstraints = false
        return weatherIconImage
      }()

    lazy var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.textColor = .label
        temperatureLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        temperatureLabel.textAlignment = .center
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        return temperatureLabel
      }()

    lazy var chanceOfRainContainer: UIView = {
        let chanceOfRainContainer = UIView()
        chanceOfRainContainer.backgroundColor = .clear
        chanceOfRainContainer.translatesAutoresizingMaskIntoConstraints = false
        return chanceOfRainContainer
    }()

    lazy var chanceOfRainImageView: UIImageView = {
        let chanceOfRainImageView = UIImageView()
        chanceOfRainImageView.contentMode = .scaleAspectFit
        chanceOfRainImageView.translatesAutoresizingMaskIntoConstraints = false
        return chanceOfRainImageView
      }()

    lazy var chanceOfRainLabel: UILabel = {
        let chanceOfRainLabel = UILabel()
        chanceOfRainLabel.textColor = .systemGray
        chanceOfRainLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        chanceOfRainLabel.textAlignment = .left
        chanceOfRainLabel.translatesAutoresizingMaskIntoConstraints = false
        return chanceOfRainLabel
      }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    /* Setup the main view, add the subviews and call the layout function */
    private func setupView() {
        backgroundColor = .clear
        addSubview(timeLabel)
        addSubview(weatherIconImage)
        addSubview(temperatureLabel)
        addSubview(chanceOfRainContainer)
        chanceOfRainContainer.addSubview(chanceOfRainImageView)
        chanceOfRainContainer.addSubview(chanceOfRainLabel)
        setupLayout()
    }

    /* Add layout constraints */
    private func setupLayout() {
        var constraints = [NSLayoutConstraint]()

        // Time label contraints
        constraints.append(contentsOf: [
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        // Image constrants
        constraints.append(contentsOf: [
            weatherIconImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            weatherIconImage.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            weatherIconImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        // temperature label contraints
        constraints.append(contentsOf: [
            temperatureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: weatherIconImage.bottomAnchor, constant: 4),
            temperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        // Chance of rain container
        constraints.append(contentsOf: [
            chanceOfRainContainer.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            chanceOfRainContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            chanceOfRainContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        // Chance of rain image
        constraints.append(contentsOf: [
            chanceOfRainImageView.leadingAnchor.constraint(equalTo: chanceOfRainContainer.leadingAnchor),
            chanceOfRainImageView.centerYAnchor.constraint(equalTo: chanceOfRainContainer.centerYAnchor),
            chanceOfRainImageView.heightAnchor.constraint(equalToConstant: 10),
            chanceOfRainImageView.widthAnchor.constraint(equalTo: chanceOfRainLabel.heightAnchor)
        ])

        // chance of rain label contraints
        constraints.append(contentsOf: [
            chanceOfRainLabel.leadingAnchor.constraint(equalTo: chanceOfRainImageView.trailingAnchor, constant: -8),
            chanceOfRainLabel.topAnchor.constraint(equalTo: chanceOfRainContainer.topAnchor),
            chanceOfRainLabel.trailingAnchor.constraint(equalTo: chanceOfRainContainer.trailingAnchor),
            chanceOfRainLabel.bottomAnchor.constraint(equalTo: chanceOfRainContainer.bottomAnchor)
        ])

        NSLayoutConstraint.activate(constraints)
    }

}
