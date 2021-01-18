//
//  DailyView.swift
//  WeatherApp
//

import UIKit

class DailyView: UIView {

    lazy var dayContainer: UIView = {
        let dayContainer = UIView()
        dayContainer.backgroundColor = .clear
        dayContainer.translatesAutoresizingMaskIntoConstraints = false
        return dayContainer
    }()

    lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.textColor = .label
        dayLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        dayLabel.textAlignment = .left
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        return dayLabel
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

    lazy var minWeatherIconContainer: UIView = {
        let weatherIconContainer = UIView()
        weatherIconContainer.backgroundColor = .clear
        weatherIconContainer.translatesAutoresizingMaskIntoConstraints = false
        return weatherIconContainer
    }()

    lazy var minWeatherIconImage: UIImageView = {
        let weatherIconImage = UIImageView()
        weatherIconImage.contentMode = .scaleAspectFit
        weatherIconImage.translatesAutoresizingMaskIntoConstraints = false
        return weatherIconImage
      }()

    lazy var maxWeatherIconContainer: UIView = {
        let weatherIconContainer = UIView()
        weatherIconContainer.backgroundColor = .clear
        weatherIconContainer.translatesAutoresizingMaskIntoConstraints = false
        return weatherIconContainer
    }()

    lazy var maxWeatherIconImage: UIImageView = {
        let weatherIconImage = UIImageView()
        weatherIconImage.contentMode = .scaleAspectFit
        weatherIconImage.translatesAutoresizingMaskIntoConstraints = false
        return weatherIconImage
      }()

    lazy var temperatureContainer: UIView = {
        let temperatureContainer = UIView()
        temperatureContainer.backgroundColor = .clear
        temperatureContainer.translatesAutoresizingMaskIntoConstraints = false
        return temperatureContainer
    }()

    lazy var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.textColor = .label
        temperatureLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        temperatureLabel.textAlignment = .right
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        return temperatureLabel
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
        addSubview(dayContainer)
        dayContainer.addSubview(dayLabel)
        addSubview(chanceOfRainContainer)
        chanceOfRainContainer.addSubview(chanceOfRainImageView)
        chanceOfRainContainer.addSubview(chanceOfRainLabel)
        addSubview(minWeatherIconContainer)
        minWeatherIconContainer.addSubview(minWeatherIconImage)
        addSubview(maxWeatherIconContainer)
        maxWeatherIconContainer.addSubview(maxWeatherIconImage)
        addSubview(temperatureContainer)
        temperatureContainer.addSubview(temperatureLabel)
        setupLayout()
    }

    /* Add layout constraints */
    private func setupLayout() {
        var constraints = [NSLayoutConstraint]()

        constraints.append(self.heightAnchor.constraint(equalToConstant: 35))

        // Day
        constraints.append(contentsOf: [
            dayContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dayContainer.topAnchor.constraint(equalTo: self.topAnchor),
            dayContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dayContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25)
        ])
        dayLabel.constrainEdges(to: dayContainer)

        // Rain
        constraints.append(contentsOf: [
            chanceOfRainContainer.leadingAnchor.constraint(equalTo: dayContainer.trailingAnchor),
            chanceOfRainContainer.topAnchor.constraint(equalTo: self.topAnchor),
            chanceOfRainContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            chanceOfRainContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25)
        ])

        constraints.append(contentsOf: [
            chanceOfRainImageView.leadingAnchor.constraint(equalTo: chanceOfRainContainer.leadingAnchor),
            chanceOfRainImageView.centerYAnchor.constraint(equalTo: chanceOfRainContainer.centerYAnchor),
            chanceOfRainImageView.heightAnchor.constraint(equalToConstant: 10),
            chanceOfRainImageView.widthAnchor.constraint(equalTo: chanceOfRainLabel.heightAnchor)
        ])

        constraints.append(contentsOf: [
            chanceOfRainLabel.leadingAnchor.constraint(equalTo: chanceOfRainImageView.trailingAnchor),
            chanceOfRainLabel.topAnchor.constraint(equalTo: chanceOfRainContainer.topAnchor),
            chanceOfRainLabel.bottomAnchor.constraint(equalTo: chanceOfRainContainer.bottomAnchor),
            chanceOfRainLabel.trailingAnchor.constraint(equalTo: chanceOfRainContainer.trailingAnchor)
        ])

        // Max Icon
        constraints.append(contentsOf: [
            maxWeatherIconContainer.leadingAnchor.constraint(equalTo: chanceOfRainContainer.trailingAnchor),
            maxWeatherIconContainer.topAnchor.constraint(equalTo: self.topAnchor),
            maxWeatherIconContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            maxWeatherIconContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1)
        ])
        maxWeatherIconImage.constrainEdges(to: maxWeatherIconContainer)

        // Min Icon
        constraints.append(contentsOf: [
            minWeatherIconContainer.leadingAnchor.constraint(equalTo: maxWeatherIconContainer.trailingAnchor),
            minWeatherIconContainer.topAnchor.constraint(equalTo: self.topAnchor),
            minWeatherIconContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            minWeatherIconContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1)
        ])
        minWeatherIconImage.constrainEdges(to: minWeatherIconContainer)

        // temperature
        constraints.append(contentsOf: [
            temperatureContainer.leadingAnchor.constraint(equalTo: minWeatherIconContainer.trailingAnchor),
            temperatureContainer.topAnchor.constraint(equalTo: self.topAnchor),
            temperatureContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            temperatureContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        temperatureLabel.constrainEdges(to: temperatureContainer)

        NSLayoutConstraint.activate(constraints)
    }
}

extension UIView {

    func constrainEdges(to containerView: UIView) {
        self.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
}
