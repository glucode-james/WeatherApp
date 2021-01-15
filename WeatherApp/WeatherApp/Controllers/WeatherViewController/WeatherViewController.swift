//
//  WeatherViewController.swift
//  WeatherApp
//

import UIKit

class WeatherViewController: UIViewController {

    /* UI Outlets */
    @IBOutlet weak var scrollView: UIScrollView!

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

    /* The date formatter is for the current conditions. The daily formatter is for daily sections and the time is for the hourly */
    let dateFormatter = DateFormatter()
    let dailyInFormatter = DateFormatter()
    let dailyOutFormatter = DateFormatter()
    let timeInFormatter = DateFormatter()
    let timeOutFormatter = DateFormatter()

    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.delegate = self

        // Configure date formatters
        dateFormatter.dateFormat = "EEEE, dd MMM HH:mm"
        dailyOutFormatter.dateFormat = "EEEE"
        dailyInFormatter.dateFormat = "yyyy-MM-dd"
        timeOutFormatter.dateFormat = "HH:mm"
        timeInFormatter.dateFormat = "HHmm"

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

        // Begin loading weather data
        refreshControl.beginRefreshing()
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - (refreshControl.frame.size.height)),
                                    animated: true)
        viewModel.loadWeatherForSelectedCity()
    }

    @objc func handleRefreshWeatherData() {
        viewModel.loadWeatherForSelectedCity()
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
            currentMinMaxLabel.text = "\(today.maxtempC)°/\(today.mintempC)°"
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

            hourlyViews[i].timeLabel.text = formatHourlyTime(timeString: hourData?.time ?? "")

            hourlyViews[i].weatherIconImage.downloaded(from: hourData?.getWeatherIconURL() ?? "")

            hourlyViews[i].temperatureLabel.text = "\(hourData?.tempC ?? "?")°"
            hourlyViews[i].chanceOfRainLabel.text = "\(hourData?.chanceofrain ?? "?")%"
        }
    }

    func populateDailyViews() {
        for i in 0..<dailyViews.count {
            let dayData = viewModel.getDailyWeather(at: i)

            dailyViews[i].dayLabel.text = i == 0 ? "Today" : formatDailyDay(dateString: dayData?.date ?? "")

            /* Work out the min and max icon indexes to set. Also work out average chance of rain */
            var minTemp = 100, maxTemp = -100
            var minURL = "", maxURL = ""
            var totalChanceOfRain = 0, records = 0
            if let dayData = dayData {
                for hourData in dayData.hourly {
                    let hourTemp = Int(hourData.tempC)
                    if hourTemp ?? 100 < minTemp {
                        minTemp = hourTemp ?? 100
                        minURL = hourData.getWeatherIconURL()
                    }
                    if hourTemp ?? -100 > maxTemp {
                        maxTemp = hourTemp ?? -100
                        maxURL = hourData.getWeatherIconURL()
                    }

                    totalChanceOfRain += (Int(hourData.chanceofrain) ?? 0)
                    records += 1
                }
            }

            dailyViews[i].chanceOfRainLabel.text = "\(records > 0 ? totalChanceOfRain / records : 0)%"

            dailyViews[i].maxWeatherIconImage.downloaded(from: maxURL)
            dailyViews[i].minWeatherIconImage.downloaded(from: minURL)

            dailyViews[i].temperatureLabel.text = "\(dayData?.maxtempC ?? "?")°/\(dayData?.mintempC ?? "?")°"
        }
    }

    private func formatHourlyTime(timeString: String) -> String {
        var padded = timeString

        while padded.count < 4 {
            padded = "0\(padded)"
        }

        guard let date = timeInFormatter.date(from: padded) else {
            return padded
        }
        return timeOutFormatter.string(from: date)
    }

    private func formatDailyDay(dateString: String) -> String {
        guard let date = dailyInFormatter.date(from: dateString) else {
            return dateString
        }
        return dailyOutFormatter.string(from: date)
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
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
            self.refreshControl.beginRefreshing()
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y - (self.refreshControl.frame.size.height)),
                                             animated: true)

            self.viewModel.loadWeatherForSelectedCity()
        })

    }
}
