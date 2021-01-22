
import UIKit
import Kingfisher
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cities = [City]()
    var filteredCities = [City]()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cities Weather"
        searchBar.delegate = self
        setupTable()
        getCitiesFromFile()
        registerForKeyboardNotifications()
        checkForLocationPermision()
    }
    
    func checkForLocationPermision() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = 100
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            break
        case .restricted:
            break
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func testNotification() {
        print("Here goes notification")
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
                tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)                
            }
        } 
    }
    
    @objc func keyboardDidHide(notification: Notification) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)                
    }
    
    func setupTable() {
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "cityCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getCitiesFromFile() {
        guard let url = Bundle.main.url(forResource: "city.list", withExtension: "json") else { 
            return
        }
        
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        
        cities = try! decoder.decode([City].self, from: data)
        filteredCities.append(contentsOf: cities)
    }
    
    func getAdressFromLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
                   
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                if let firstLocation = placemarks?[0] {
                    if let city = firstLocation.locality {
                        
                        if let index = self.cities.firstIndex(where: { (currentCity) -> Bool in
                            return currentCity.name == city
                        }) {
                            let foundCity = self.cities.remove(at: index)
                            self.cities.insert(foundCity, at: 0)
                            self.filteredCities = self.cities
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                // An error occurred during geocoding.
            }
        })
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getAdressFromLocation(location: location)
        }
    }
}

extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredCities.removeAll()
            filteredCities.append(contentsOf: cities)
            tableView.reloadData()
            return
        }
        let text = searchText.trimmingCharacters(in: .whitespaces)
        filteredCities = cities.filter({ $0.name.lowercased().hasPrefix(text.lowercased()) })
//        filteredCities = cities.filter({ (city) -> Bool in
//            return city.name.lowercased().hasPrefix(text.lowercased())
//        })
        tableView.reloadData()
        
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as! CityTableViewCell
        let city = filteredCities[indexPath.row]
        cell.setCityDetails(city: city)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let city = filteredCities[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        controller.city = city
        
        
        //present(controller, animated: true, completion: nil)

        navigationController?.pushViewController(controller, animated: true)
        
        
    }
}
