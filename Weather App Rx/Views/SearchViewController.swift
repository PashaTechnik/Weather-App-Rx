//
//  SearchViewController.swift
//  Weather App
//
//  Created by Pasha on 01.11.2022.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    

    private let bag = DisposeBag()
    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView()
        bind(textField: textField, to: viewModel.cityName)
        tableView.rx.setDelegate(self).disposed(by: bag)
    }
    
    private func bindTableView() {
        
        viewModel.placesResult.bind(to: tableView.rx.items(cellIdentifier: LocationCell.identifier, cellType: LocationCell.self)) { (row,item,cell) in
            cell.locationLabel.text = item.attributedFullText.string
        }.disposed(by: bag)
        
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: { item in
            print("SelectedItem: \(item)")
        }).disposed(by: bag)
        
        viewModel.initPlacesResult()
    }
    

    private func bind(textField: UITextField, to behaviorRelay: BehaviorRelay<String>) {
        behaviorRelay.asObservable()
            .bind(to: textField.rx.text)
            .disposed(by: bag)
        textField.rx.text.orEmpty
            .bind(to: behaviorRelay)
            .disposed(by: bag)
    }
    
    @IBAction func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
}


extension SearchViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cityName = placesResult[indexPath.row].attributedPrimaryText.string
//        navigationController?.popViewController(animated: true)
//        let vc = navigationController?.topViewController as! MainViewController
//        //vc.city = cityName
//    }


}
