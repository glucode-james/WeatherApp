//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by James Sinclair on 2021/01/12.
//

import UIKit

class WeatherViewController: UIViewController {

    /* Current Conditions Outlets */
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentConditionsImage: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentDescLabel: UILabel!
    @IBOutlet weak var currentMinMaxLabel: UILabel!
    @IBOutlet weak var currentFeelsLikeLabel: UILabel!

    /* Hourly Outlets */
    @IBOutlet weak var hourlyStackView: UIStackView!

    /* Daily Outlets */

    /* View Model */
    private let viewModel = WeatherViewModel()

    private var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.delegate = self

        dateFormatter.dateFormat = "EEEE, dd MMM HH:mm"
    }

    @IBAction func openCityViewController(_ sender: Any) {
        let cityController = CityViewController()
        cityController.delegate = self

        let navController = UINavigationController(rootViewController: cityController)
        navController.modalPresentationStyle = .fullScreen

        self.present(navController,
                     animated: true,
                     completion: nil)
    }

    // MARK: - UI Population Functions
    func populateCurrentConditions() {
        guard let currentConditions = viewModel.getCurrentConditions() else {
            return
        }

        if let city = viewModel.getSelectedCity() {
            locationLabel.text = city.cityName()
        } else {
            locationLabel.text = "Current Location"
        }

        currentTemperatureLabel.text = "\(currentConditions.temp_C)°"
        currentDescLabel.text = currentConditions.getWeatherDesc()

        /* the first entry is today */
        if let today = viewModel.getDailyWeather(at: 0) {
            currentMinMaxLabel.text = "\(today.mintempC)°/\(today.maxtempC)°"
        } else {
            currentMinMaxLabel.text = ""
        }

        currentFeelsLikeLabel.text = "Feels like \(currentConditions.FeelsLikeC)°"

        print(currentConditions.getWeatherIconURL())
        if let url = URL(string: currentConditions.getWeatherIconURL()),
           let data = try? Data(contentsOf: url) {
            currentConditionsImage.image = UIImage(data: data)
        } else {
            currentConditionsImage.image = UIImage(named: "MissingIcon")
        }

        dateLabel.text = dateFormatter.string(from: Date())
    }

    func populateHourlyViews() {

    }

    func populateDailyViews() {

    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func weatherViewModel(weatherUpdated weatherViewModel: WeatherViewModel, error: Bool, message: String) {
        if error {
            let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            // Populate the UI
            DispatchQueue.main.async {
                self.populateCurrentConditions()
                self.populateHourlyViews()
                self.populateDailyViews()
            }
        }
    }
}

extension WeatherViewController: CityViewControllerDelegate {
    func cityViewController(citySelected controller: CityViewController) {
        /* Begin repopulating the weather data when the city controller selects a new city */
        controller.dismiss(animated: true, completion: nil)

        viewModel.loadWeatherForSelectedCity()
    }
}
