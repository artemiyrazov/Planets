//
//	ViewController.swift
// 	Planets
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var planetsArray: [Planet] = []
    var context: NSManagedObjectContext!

    
    @IBOutlet weak var planetsPickerView: UIPickerView!
    @IBOutlet weak var toSunDistanceLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !(UserSettings.isDataFromFileLoaded) {
            getDataFromFile()
            UserSettings.isDataFromFileLoaded = true
        }
        fetchData()
    
        planetsPickerView.delegate = self
        planetsPickerView.dataSource = self
        
        // pickerView rotating
        let pickerViewHeight: CGFloat = view.frame.height * 0.7
        planetsPickerView.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        planetsPickerView.frame = CGRect(x: 0,
                                         y: view.frame.height - pickerViewHeight,
                                         width: view.frame.width,
                                         height: pickerViewHeight)
        planetsPickerView.center.x = view.center.x
        updateLabels(toSunDistance: planetsArray[0].toSunDistance, averageTemparature: planetsArray[0].averageTemperature)
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Supporting methods
    
    private func getDataFromFile () {
        guard   let path = Bundle.main.path(forResource: "data", ofType: "plist"),
                let dataArray = NSArray(contentsOfFile: path) else { return }
        
        for dict in dataArray {
            guard let entity = NSEntityDescription.entity(forEntityName: "Planet", in: context) else { return }
            guard let planet = NSManagedObject(entity: entity, insertInto: context) as? Planet else { return }
            
            let planetDict = dict as! [String: AnyObject]
            
            planet.name = planetDict["name"] as? String
        
            guard   let avgTemperature = (planetDict["averageTemparature"] as? NSNumber)?.intValue,
                    let toSunDistance = (planetDict["toSunDistance"] as? NSNumber)?.floatValue else { return }
            planet.toSunDistance = toSunDistance
            guard   avgTemperature == Int16(avgTemperature) else { return }
            planet.averageTemperature = Int16(avgTemperature)
            
            if let imageName = planetDict["imageName"] as? String, let image = UIImage(named: imageName) {
                let imageData = image.pngData()
                planet.imageData = imageData
            }
            
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchData () {
        let fetchRequest: NSFetchRequest<Planet> = Planet.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "toSunDistance", ascending: true)]
        
        do {
            planetsArray = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func updateLabels (toSunDistance: Float, averageTemparature: Int16) {
        toSunDistanceLabel.text = "\(toSunDistance)au to the Sun"
        temperatureLabel.text = "Average \(averageTemparature)ºC"
    }

}


// MARK: - PickerView extension

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {


    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return planetsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return view.frame.width * 1.2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let planet = planetsArray[row]
        updateLabels(toSunDistance: planet.toSunDistance, averageTemparature: planet.averageTemperature)

    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let planet = planetsArray[row]
        
        let width: CGFloat = pickerView.frame.width
        let height: CGFloat = pickerView.frame.height

        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        var imageView = UIImageView()
        if let imageData = planet.imageData {
            imageView = UIImageView(image: UIImage(data: imageData))
        }
        imageView.frame = CGRect(x: 0, y: 0, width: width * 0.9, height: width * 0.9)
        imageView.center.x = view.center.x
        
        let label = UILabel()
        label.frame = CGRect(x: 0,
                             y: imageView.frame.maxY,
                             width: width,
                             height: height - imageView.frame.height)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.text = planet.name
        label.textColor = .white

        view.addSubview(imageView)
        view.addSubview(label)
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
        
        

        return view
    }

}

