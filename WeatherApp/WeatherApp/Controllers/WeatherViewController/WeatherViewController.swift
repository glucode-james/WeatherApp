//
//  WeatherViewController.swift
//  WeatherApp
//

import UIKit

class WeatherViewController: UIViewController {

    /* UI Outlets */
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var noCitiesView: UIView!
    @IBOutlet weak var cityFinderButton: UIButton!
    @IBOutlet weak var topStackView: UIStackView!

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
    let hourlyViews = [
        HourlyView(),
        HourlyView(),
        HourlyView(),
        HourlyView(),
        HourlyView()
    ]

    /* Daily Outlets */
    @IBOutlet weak var dailyStackView: UIStackView!
    let dailyViews = [
        DailyView(),
        DailyView(),
        DailyView(),
        DailyView(),
        DailyView()
    ]

    /* View Model */
    private let viewModel = WeatherViewModel()

    /* The date formatter is for the current conditions. */
    let dateFormatter = DateFormatter()

    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.delegate = self
        cityFinderButton.setImage(cityFinderButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        cityFinderButton.imageView?.tintColor = .label

        // Configure date formatters
        dateFormatter.dateFormat = "EEEE, dd MMM HH:mm"

        // Configure refresh control for scrollview
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self,
                                 action: #selector(handleRefreshWeatherData),
                                 for: .valueChanged)

        // Configure Hourly Views
        for view in hourlyViews {
            hourlyStackView.addArrangedSubview(view)
        }

        // Configure Daily Views
        for view in dailyViews {
            dailyStackView.addArrangedSubview(view)
        }

        // If there is a selected city, load its weather. Otherwise offer the user a choice.
        if viewModel.getSelectedCity() != nil {
            weatherView.isHidden = false
            loadWeatherForSelectedCity()
        } else {
            noCitiesView.isHidden = false
        }
    }

    // MARK: - No Locations Functions
    @IBAction func useMyLocationPressed(_ sender: Any) {
        viewModel.useMyLocation()

        loadWeatherForSelectedCity(updateVisibleView: true)
    }

    @IBAction func addALocationPressed(_ sender: Any) {
        openCityViewController(sender)
    }

    @objc func handleRefreshWeatherData() {
        viewModel.loadWeatherForSelectedCity()
    }

    private func loadWeatherForSelectedCity(updateVisibleView: Bool = false) {
        if updateVisibleView {
            animateShowWeather()
        }

        refreshControl.beginRefreshing()
        scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y - (self.refreshControl.frame.size.height)),
                                    animated: true)

        viewModel.loadWeatherForSelectedCity()
    }

    private func animateShowWeather() {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.noCitiesView.isHidden = true
                        self.weatherView.isHidden = false
                        self.topStackView.layoutIfNeeded()
                       },
                       completion: nil)
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

        locationLabel.text = viewModel.getSelectedCity()?.cityName()

        currentTemperatureLabel.text = "\(currentConditions.temp_C)°"
        currentDescLabel.text = currentConditions.getWeatherDesc()

        /* the first entry is today */
        if let today = viewModel.getDailyWeather(at: 0) {
            currentMinMaxLabel.text = today.formattedTemp
        } else {
            currentMinMaxLabel.text = ""
        }

        currentFeelsLikeLabel.text = "Feels like \(currentConditions.FeelsLikeC)°"
        currentConditionsImage.downloaded(from: currentConditions.getWeatherIconURL())
        dateLabel.text = dateFormatter.string(from: Date())
    }

    func populateHourlyViews() {
        for i in 0..<hourlyViews.count {

            let hourData = viewModel.getHourlyWeather(at: i)

            hourlyViews[i].timeLabel.text = hourData?.formattedTime
            hourlyViews[i].weatherIconImage.downloaded(from: hourData?.hourlyWeather.getWeatherIconURL() ?? "")
            hourlyViews[i].temperatureLabel.text = "\(hourData?.hourlyWeather.tempC ?? "-")°"
            hourlyViews[i].chanceOfRainImageView.image = hourData?.chanceOfRainImage
            hourlyViews[i].chanceOfRainLabel.text = "\(hourData?.hourlyWeather.chanceofrain ?? "-")%"
        }
    }

    func populateDailyViews() {
        for i in 0..<dailyViews.count {
            let dayData = viewModel.getDailyWeather(at: i)

            dailyViews[i].dayLabel.text = dayData?.formattedDate
            dailyViews[i].chanceOfRainImageView.image = dayData?.chanceOfRainImage
            dailyViews[i].chanceOfRainLabel.text = dayData?.chanceOfRain
            dailyViews[i].maxWeatherIconImage.downloaded(from: dayData?.maxTempURL ?? "")
            dailyViews[i].minWeatherIconImage.downloaded(from: dayData?.minTempURL ?? "")
            dailyViews[i].temperatureLabel.text = dayData?.formattedTemp
        }
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func weatherViewModel(locationServicesDisabled weatherViewModel: WeatherViewModel) {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "You need to enable location services for the app if you want to use your current location",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.present(alert, animated: true)
        }
    }

    func weatherViewModel(weatherUpdated weatherViewModel: WeatherViewModel, error: Bool, message: String) {
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.scrollView.refreshControl?.endRefreshing()
        }

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
        controller.dismiss(animated: true, completion: {
            self.loadWeatherForSelectedCity(updateVisibleView: true)
        })
    }
}
