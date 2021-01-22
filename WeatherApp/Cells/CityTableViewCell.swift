
import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblCoords: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCityDetails(city: City) {
        lblCityName.text = city.name
        lblCountry.text = city.country
        lblState.text = city.state
        if let coord = city.coord, let lon = coord.lon, let lat = coord.lat {
            lblCoords.text = "(\(lon.round(to: 3)),\(lat.round(to: 3)))"
        } else {
            lblCoords.text = ""
        }
    }
}


extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
