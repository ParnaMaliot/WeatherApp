
import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblWeatherDesc: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func startLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        lblWeatherDesc.isHidden = false
        lblTemp.isHidden = false
    }
    
    func setWeatherInfoForCity(city: City) {
        self.lblName.text = city.name
        startLoading()
        APIManager.shared.getWeatherForCity(id: city.id) { (weather, error) in
            self.stopLoading()
            if let weather = weather {
                self.lblTemp.text = "\(weather.main.temp!)°"
                self.lblWeatherDesc.text = weather.weather[0].description?.capitalized
            
                if let iconName = weather.weather[0].icon {
                    let imageUrl = BASE_ICON_URL + iconName + "@2x.png" 
                    self.icon.kf.setImage(with: URL(string: imageUrl))
                }
            }
        }
    }
}
