//
//  MainViewController.swift
//  Weather App
//
//  Created by Pasha on 01.11.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var dayWeatherCollectionView: UICollectionView!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirection: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        darkView.isHidden = false
    }


    @IBAction func goToSearch(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SearchVC") as! SearchViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

