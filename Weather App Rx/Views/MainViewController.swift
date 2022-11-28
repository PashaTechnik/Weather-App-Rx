//
//  MainViewController.swift
//  Weather App
//
//  Created by Pasha on 01.11.2022.
//

import UIKit
import RxCocoa
import RxSwift

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
    
    private let bag = DisposeBag()
    private let viewModel = WeatherViewModel()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindings()
        weatherTableView.rx.setDelegate(self).disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        darkView.isHidden = false
    }

    private func bindings() {
        
        viewModel.weatherCellViewModels.bind(to: weatherTableView.rx.items(cellIdentifier: WeatherCell.identifier, cellType: WeatherCell.self)) { (row,item,cell) in
            cell.cellViewModel = item
        }.disposed(by: bag)
        
        viewModel.dayWeatherCellViewModels.bind(to: dayWeatherCollectionView.rx.items(cellIdentifier: DayWeatherCell.identifier, cellType: DayWeatherCell.self)) { (row,item,cell) in
            cell.cellViewModel = item
        }.disposed(by: bag)
        
        viewModel.weatherModel.bind { [weak self] weatherModel in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.darkView.isHidden = true
            self.dateLabel.text = weatherModel.date
            self.cityNameLabel.text = weatherModel.city
            self.humidityValueLabel.text = weatherModel.humidity
            self.temperatureValueLabel.text = "\(String(Int(weatherModel.minTemperature)))° / \(String(Int(weatherModel.maxTemperature)))°"
            self.weatherIcon.image = UIImage(named: Utilities.iconDict[weatherModel.icon, default: "ic_white_day_bright"]) ?? UIImage()
            self.windLabel.text = weatherModel.windSpeed
            self.windDirection.image = UIImage(named: weatherModel.windDirection)
        }.disposed(by: bag)
        
    }

    @IBAction func goToSearch(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SearchVC") as! SearchViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainViewController: UITableViewDelegate, UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height)
    }
}
