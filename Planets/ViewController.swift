//
//	ViewController.swift
// 	Planets
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var planetsArray = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]
    let pickerViewHeight: CGFloat = 200
    
    @IBOutlet weak var planetsPickerView: UIPickerView!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        planetsPickerView.delegate = self
        planetsPickerView.dataSource = self
        

        // pickerView rotating
        planetsPickerView.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        planetsPickerView.frame = CGRect(x: 0,
                                         y: view.frame.height - pickerViewHeight,
                                         width: view.frame.width,
                                         height: pickerViewHeight)
        planetsPickerView.center.x = view.center.x
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - PickerView methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return planetsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return view.frame.width
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let width: CGFloat = pickerView.frame.width
        let heigth: CGFloat = pickerView.frame.height

        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: heigth)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: width, height: heigth)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.text = planetsArray[row]
        label.textColor = .white
        
        view.addSubview(label)

        // view rotating
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))

        return view
    }

}

