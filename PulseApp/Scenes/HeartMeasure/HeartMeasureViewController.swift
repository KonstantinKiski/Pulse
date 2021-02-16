//
//  HeartMeasureViewController.swift
//  PulseApp
//
//  Created by Viacheslav Tolstopiatenko on 5/01/21.

import UIKit


class HeartMeasureViewController: UIViewController {

    @IBOutlet weak var bpmValue: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var bpmProgress: UIProgressView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var hitLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bpmProgress.setProgress(0.0, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    private func setupViews() {
        bpmProgress.setProgress(0.0, animated: false)
        self.startButton.isHidden = false
        self.hitLabel.isHidden = true
        self.view.backgroundColor = PulseColor.background
        self.title = PulseTabsName.heart
        bpmValue.textColor = PulseColor.lightGray
        bpmValue.font = PulseFont.medium(80)
        bpmLabel.textColor = PulseColor.lightGray
        bpmLabel.font = PulseFont.medium(30)
        bpmProgress.progressTintColor = PulseColor.red
        bpmProgress.trackTintColor = PulseColor.lightGray
        hitLabel.textColor = PulseColor.red
        hitLabel.font = PulseFont.regular(15)
        PulseViewSetting.setupSystemButton(&startButton, title: "Start measure")
    }

    @IBAction func startMeasureAction(_ sender: UIButton) {
        
    }

}

extension HeartMeasureViewController: HeartRateKitControllerDelegate {
    func heartRateKitController(_ controller: HeartRateKitController, didFinishWith result: HeartRateKitResult) {
        
    }
    
    func heartRateKitControllerDidCancel(_ controller: HeartRateKitController) {
        
    }
}


//extension HeartMeasureViewController: HeartRateDetectionModelDelegate {
//    func heartRateUpdate(_ bpm: Int32, atTime seconds: Int32, brightness brightnessValue: Float) {
//        let value = Float(30.0 / Float(seconds))
//        bpmProgress.setProgress(value, animated: true)
//        bpmValue.text = String(bpm)
//        print("bpm: \(bpm): seconds: \(seconds) brightness: \(brightnessValue)")
//    }
//
////    func heartRateUpdate(_ bpm: Int, atTime seconds: Int, brightness brightnessValue: Float) {
////
////    }
//
//    func heartRateStart() {
//        bpmProgress.setProgress(0.0, animated: false)
//        self.startButton.isHidden = true
//        self.hitLabel.isHidden = false
//    }
//
//    func heartRateEnd() {
//        bpmProgress.setProgress(1.0, animated: true)
//        self.startButton.isHidden = false
//        self.hitLabel.isHidden = true
//    }
//}


