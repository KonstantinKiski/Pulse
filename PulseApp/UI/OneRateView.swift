//
//  OneRateView.swift
//  PulseApp
//
//  Created by Константин Киски on 16.02.2021.
//

import Foundation

class OneRateView: UIView {
    
    // MARK: - UI Elements

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var bpmLabel: UILabel!
    @IBOutlet private var pulseView: UIView!
    @IBOutlet private var infoImageView: UIImageView!
    @IBOutlet private var pulseLabel: UILabel!
    @IBOutlet private var iconImage: UIImageView!
    @IBOutlet private var iconView: UIView!
    
    private var view: UIView!

    // MARK: - Set data
    
    public func setData(date: Date, pulse: Int, icon: UIImage) {
        if pulse < 65 {
            setLowPulse()
        } else if pulse > 86 {
            setBadPulse()
        } else {
            setNormalPulse()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY, HH:mm"
        
        dateLabel.text = "\(dateFormatter.string(from: Date()))"
        bpmLabel.text = "\(pulse) bpm"
        iconView.layer.borderColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1.00).cgColor
    }
    
    private func setNormalPulse() {
        pulseView.backgroundColor = UIColor(red: 0.68, green: 0.92, blue: 0.86, alpha: 1.00)
        pulseLabel.textColor = UIColor(red: 0.00, green: 0.74, blue: 0.08, alpha: 1.00)
        infoImageView.tintColor = UIColor(red: 0.00, green: 0.74, blue: 0.08, alpha: 1.00)
//UIColor(red: 0.00, green: 0.74, blue: 0.55, alpha: 1.00)
        pulseLabel.text = "Normal pulse"
    }
    
    private func setLowPulse() {
        pulseView.backgroundColor = UIColor(red: 0.98, green: 0.84, blue: 0.72, alpha: 1.00)
        pulseLabel.textColor = UIColor(red: 0.96, green: 0.49, blue: 0.15, alpha: 1.00)
        infoImageView.tintColor = UIColor(red: 0.96, green: 0.49, blue: 0.15, alpha: 1.00)
        pulseLabel.text = "Low pulse"
    }
    
    private func setBadPulse() {
        pulseView.backgroundColor = UIColor(red: 0.98, green: 0.70, blue: 0.71, alpha: 1.00)
        pulseLabel.textColor = UIColor(red: 0.92, green: 0.10, blue: 0.19, alpha: 1.00)
        infoImageView.tintColor = UIColor(red: 0.92, green: 0.10, blue: 0.19, alpha: 1.00)
        pulseLabel.text = "Bad pulse"
    }
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OneRateView", bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        view?.prepareForInterfaceBuilder()
    }
}
