//
//  CityViewController.swift
//  WeatherApp
//
//  Created by James Sinclair on 2021/01/12.
//

import UIKit

protocol CityViewControllerDelegate: class {
    func cityViewController(citySelected controller: CityViewController)
}

class CityViewController: UIViewController {

    /* UI Outlets */
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    /* Refresh Control for the table */
    private lazy var refreshControl = UIRefreshControl()

    weak var delegate: CityViewControllerDelegate?

    /* View Models */
    private let localViewModel = LocalSearchCityViewModel()
    private let webViewModel = WebSearchCityViewModel()

    /* This will be either the web or local view model */
    internal var currentDataSource: CityDataSource?

    internal let cellReuseIdentifier = "BasicCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure Nav Bar
        self.title = "City Finder"
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.backPressed))
        self.navigationItem.leftBarButtonItem = backButton

        // Configure view model delegates
        localViewModel.delegate = self
        webViewModel.delegate = self

        // Configure initial data provider
        if localViewModel.savedCityCount() > 1 {
            searchBar.selectedScopeButtonIndex = 0
            currentDataSource = localViewModel
        } else {
            searchBar.selectedScopeButtonIndex = 1
            currentDataSource = webViewModel
        }

        // Configure SearchBar
        searchBar.delegate = self

        // Configure TableView
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

/* View Model delegate functions */
extension CityViewController: CityViewModelDelegate {
    func cityViewModel(updated dataSource: CityDataSource, with error: Bool, message: String) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableView.refreshControl = nil
            self.tableView.reloadData()

            // Handle error or no results user feed back
            self.handleErrorOrNoData(dataSource: dataSource, error: error, message: message)
        }
    }

    private func handleErrorOrNoData(dataSource: CityDataSource, error: Bool, message: String) {
        if error {
            let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else if dataSource.cityViewModelCityCount() == 0 {
            let alert = UIAlertController(title: "No cities were found for the search term, try a different one.",
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

/* Search delegate functions */
extension CityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Display the refresh control
        tableView.refreshControl = refreshControl
        refreshControl.beginRefreshing()
        tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y
                                            - (refreshControl.frame.size.height)), animated: true)

        currentDataSource?.cityViewModel(search: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
            currentDataSource = localViewModel
        } else {
            currentDataSource = webViewModel
        }

        tableView.reloadData()
    }
}

/* table datasource and delegate functions */
extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let city = currentDataSource?.cityViewModelCity(at: indexPath.row) else {
            return
        }

        localViewModel.setCurrent(city: city)

        delegate?.cityViewController(citySelected: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource?.cityViewModelCityCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) ??
            UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)

        if let city = currentDataSource?.cityViewModelCity(at: indexPath.row) {
            cell.textLabel?.text = city.cityName()
            cell.detailTextLabel?.text = city.countryName()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return searchBar.selectedScopeButtonIndex == 0
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            localViewModel.deleteSavedCity(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
