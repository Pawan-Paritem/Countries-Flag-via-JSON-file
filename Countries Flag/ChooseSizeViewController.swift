//
//  ChooseSizeViewController.swift
//  PhotoEditorForPassport
//
//  Created by Pawan iOS on 23/09/2022.
//

import UIKit

class ChooseSizeViewController: UIViewController {
    
    // MARK: - IBOutlets, Variables & Constants
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCustomSizeButton: UIButton!
    
    var allCountriesInfoArray   : Continents?
    var newData                 : Continents?
    var CommonCountries         : [DataModel]?
    var searchCommonCountries   : [DataModel]?
    var searchCountries         : [DataModel]?
    
    
    //MARK: - Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarColor()
        searchBarCustomization()
        
        allCountriesInfoArray = loadJSONData(fileName: "countries")
        newData = allCountriesInfoArray
        
        CommonCountries = newData?.common
        searchCommonCountries = newData?.common
        searchCountries = newData?.countries
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        Application.statusBarColorChange(value: true)
        navigationBarColor()
    }
        
    // MARK: - IBActions
    @IBAction func addCustomSizeActionButton(_ sender: UIButton) {
        
        let controller = CustomSizeViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Private Methods
    
    
    private func navigationBarColor() {
       navigationController?.navigationBar.isTranslucent = false
       navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 53/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1)
       
       let imgBack = UIImage(named: "arrow-square-down")
       navigationController?.navigationBar.backIndicatorImage = imgBack
       navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBack
       
       //navigationItem.leftItemsSupplementBackButton = true
       navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
       
       UINavigationBar.appearance().tintColor = UIColor.white
       UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
       navigationItem.title = "Choose Size"
       
   }
    
    private func searchBarCustomization() {
        
        let searchTextField:UITextField = searchBar.searchTextField
        searchTextField.textAlignment = .left
        searchTextField.layer.cornerRadius = 15
        searchTextField.layer.masksToBounds = true
        searchTextField.leftView = .none
        searchTextField.backgroundColor = .white
        searchTextField.borderStyle = .none
    
    }
    
    private func loadJSONData(fileName: String) -> Continents? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Continents.self, from: data.self)
                return jsonData
            } catch {
                print("Error")
            }
        }
        return nil
    }

}

//MARK: -  UITableViewDelegate, UITableViewDataSource
extension ChooseSizeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let sectionLabel = UILabel(frame: CGRect(x: 23, y: 0, width:tableView.bounds.size.width, height: 20))
        sectionLabel.font = UIFont(name: "Outfit", size: 16)
        sectionLabel.textColor = UIColor(displayP3Red: 53/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        
        if section == 0 {
            sectionLabel.text = "Common Size"
        } else {
            sectionLabel.text = "Select Size"
        }
        
        view.backgroundColor = UIColor.init(displayP3Red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        view.addSubview(sectionLabel)
        
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return (searchCommonCountries?.count) ??  0
        } else {
            return (searchCountries?.count) ??  0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = CountriesDetailTableViewCell.registerTableViewCell(tableView: tableView, indexPath: indexPath)
            cell.countryFlag.image = UIImage(named: (searchCommonCountries![indexPath.row].flag))
            cell.countryName.text = searchCommonCountries![indexPath.row].name
            
            let height = searchCommonCountries![indexPath.row].height
            let widht = searchCommonCountries![indexPath.row].widht
            
            let heightConvert  = height * 10
            let widhtConvert   = widht * 10
            
            cell.height.text = "\(height)x\(widht)cm (\(heightConvert)x \(widhtConvert)mm)"
            
            cell.bgColor.text  = "Background Color: \(String(describing: searchCommonCountries![indexPath.row].bgColor ?? ""))"
            
            cell.contentView.backgroundColor = UIColor.white
            return cell
            
        } else {
            let cell = CountriesDetailTableViewCell.registerTableViewCell(tableView: tableView, indexPath: indexPath)
            cell.countryFlag.image = UIImage(named: (searchCountries![indexPath.row].flag))
            cell.countryName.text = searchCountries![indexPath.row].name
            
            let height = searchCountries![indexPath.row].height
            let widht = searchCountries![indexPath.row].widht
            
            let heightConvert  = height * 10
            let widhtConvert   = widht * 10
            
            cell.height.text = "\(height)x\(widht)cm (\(heightConvert)x \(widhtConvert)mm)"
            
            cell.bgColor.text  = "Background Color: \(String(describing: searchCountries![indexPath.row].bgColor ?? ""))"
            cell.contentView.backgroundColor = UIColor.white
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = PreviewController()
        navigationController?.pushViewController(controller, animated: true)
        controller.units = "Centimeters"
        controller.headSize = "18"
        if indexPath.section == 0 {
            controller.height = searchCommonCountries![indexPath.row].height
            controller.width = searchCommonCountries![indexPath.row].widht
        } else {
            controller.height = searchCountries![indexPath.row].height
            controller.width = searchCountries![indexPath.row].widht
        }
        view.endEditing(true)
    }
}

//MARK: - UISearchBarDelegate
extension ChooseSizeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchCommonCountries = CommonCountries?.filter({ dataModel in return dataModel.name.contains(searchText) })
            searchCountries       = newData?.countries.filter({ dataModel in return dataModel.name.contains(searchText) })
            tableView.reloadData()
        } else {
            searchCommonCountries = CommonCountries
            searchCountries       = newData?.countries
            tableView.reloadData()
        }
    }
}
