//
//  LifeHourglassView.swift
//  LifeHourglass
//
//  Created by 柴英嗣 on 2021/04/25.
//

import Foundation
import UIKit
import Eureka
import Cartography
import SCLAlertView

class LifeHourglassView: UIViewController {
    
    var hourgrassImage : UIImageView!
    let now_time = UILabel()
    var timer: Timer!
    
    let hello = UILabel()
    let registerButton = UIButton()
    let registerButton1 = UIButton()
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    var imageViewBackground = UIImageView()
    var imagearray : [String : String] = ["見渡す限りの遺跡" : "1" ,"地球儀と国旗" : "2","古代の建造物" : "3","海戦の様子" : "4","太陽が差し込む遺跡" : "5","砂漠のピラミッド" : "6","戦争の様子" : "7","銃撃戦の様子" : "8","遠くに浮かぶ船" : "9"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaults.standard.removeObject(forKey: "BirthArray")
        if let back = UserDefaults.standard.string(forKey: "style") {
            //self.view.addBackground(name: back)
            imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            imageViewBackground.image = UIImage(named: imagearray[back]!)
            imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
            imageViewBackground.alpha = 0.65
            self.view.addSubview(imageViewBackground)
        }
        else{
//            self.view.addBackground(name: "雲がきれいな空と山")
            imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            imageViewBackground.image = UIImage(named: imagearray["見渡す限りの遺跡"]!)
            imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
            imageViewBackground.alpha = 0.65
            self.view.addSubview(imageViewBackground)
        }
        self.title = "偉人生涯シミュレーター(海外版)"
        self.view.backgroundColor = UIColor.hex(string: "#eeeeee", alpha: 1.0)
        
        let format = DateFormatter()
        format.dateFormat = "yyyy年MM月dd日"
        now_time.font = UIFont.boldSystemFont(ofSize: 30)
        now_time.textAlignment = .left
        now_time.numberOfLines = 0
        now_time.text = format.string(from: Date())
        self.view.addSubview(now_time)
        constrain(now_time, self.view) { i, view in
            i.center == i.superview!.center
            i.width == self.view.frame.width - 30
            i.height >= 30
        }
        
        
        hello.font = UIFont.systemFont(ofSize: 20)
        hello.textAlignment = .center
        hello.textColor = .white
        hello.numberOfLines = 0
        hello.clipsToBounds = true
        hello.layer.cornerRadius = 10
        hello.backgroundColor = UIColor.hex(string: "#707070", alpha: 0.8)
        hello.text = "偉人生涯シミュレーターへようこそ！\n\nこのアプリは、もしあなたが歴史上の偉人だった時、享年までどのくらいの時間が残されているのかをナノ秒単位でシミュレーションします。\n\nまずは生年月日となりたい歴史上の人物を設定してください。"
        self.view.addSubview(hello)
        constrain(hello, self.view) { i, view in
            i.center == i.superview!.center
            i.width == self.view.frame.width - 100
            i.height >= 30
        }
        
        registerButton.addTarget(self, action: #selector(registerEvent(_:)), for: UIControl.Event.touchUpInside)
        registerButton.setTitle("生年月日を設定する", for: .normal)
        registerButton.backgroundColor = UIColor.hex(string: "#9347a9", alpha: 1.0)
        registerButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        registerButton.layer.cornerRadius = 10
        registerButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0 )
        registerButton.layer.shadowOpacity = 0.3
        registerButton.layer.shadowRadius = 3
        registerButton.layer.shadowColor = UIColor.black.cgColor
        self.view.addSubview(registerButton)
        constrain(registerButton, hello) { Field, view in
            Field.width  == 240
            Field.height == 48
            Field.top == view.bottom + 50
            Field.centerX == Field.superview!.centerX
        }
        
        
        registerButton1.addTarget(self, action: #selector(registerEvent1(_:)), for: UIControl.Event.touchUpInside)
        registerButton1.setTitle("設定", for: .normal)
        registerButton1.titleLabel?.numberOfLines = 0
        registerButton1.titleLabel?.textAlignment = .center
        registerButton1.backgroundColor = UIColor.hex(string: "#9347a9", alpha: 1.0)
        registerButton1.setTitleColor(UIColor.white, for: UIControl.State.normal)
        registerButton1.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        registerButton1.layer.cornerRadius = 30
        registerButton1.layer.shadowOffset = CGSize(width: 1.0, height: 1.0 )
        registerButton1.layer.shadowOpacity = 0.3
        registerButton1.layer.shadowRadius = 10
        registerButton1.layer.shadowColor = UIColor.black.cgColor
        self.view.addSubview(registerButton1)
        constrain(registerButton1, self.view) { Field, view in
            Field.width  == 60
            Field.height >= 60
            Field.bottom == view.bottom - 30
            Field.right == Field.superview!.right - 30
        }
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                                 selector: #selector(self.updateTime),
                                 userInfo: nil, repeats: true)
        }
            

    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(true)
            timer.invalidate()
        }
    @objc func registerEvent(_ sender: UIButton) {
        let vc = FormView()
        vc.presentationController?.delegate = self
        vc.title = "誕生日設定"
            vc.navigationItem.rightBarButtonItem = {
                let btn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.onPressClose(_:)))
                return btn
            }()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    @objc func registerEvent1(_ sender: UIButton) {
        let vc = FormView()
        vc.presentationController?.delegate = self
        vc.title = "誕生日設定"
        vc.backimage = UserDefaults.standard.string(forKey: "style") ?? "見渡す限りの遺跡"
        vc.Birth = load(key: "BirthArray")!
        vc.sex = UserDefaults.standard.string(forKey: "sex") ?? ""
            vc.navigationItem.rightBarButtonItem = {
                let btn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.onPressClose(_:)))
                return btn
            }()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    @objc func updateTime() {
        if let storedData = UserDefaults.standard.object(forKey: "BirthArray") as? Date {
            // 時刻を取得してラベルに表示
            now_time.isHidden = false
            hello.isHidden = true
            registerButton.isHidden = true
            registerButton1.isHidden = false
            
            let namedictionary : [String: Int] = ["トーマス・エジソン" : 84,"ヘレン・ケラー" : 87,"アルベルト・アインシュタイン" : 76,"ジャンヌ・ダルク" : 19,"フローレンス・ナイチンゲール" : 90,"レオナルド・ダ・ヴィンチ" : 67,"マザーテレサ" : 87,"ナポレオン・ボナパルト" : 51,"アイザック・ニュートン" : 84,"モーツァルト" : 35,"イエス・キリスト" : 33,"ガリレオ・ガリレイ" : 77,"ヨハン・セバスティアン・バッハ" : 65,"ニコラ・テスラ" : 86,"クレオパトラ" : 39,"釈迦" : 80,"エイブラハム・リンカーン" : 56,"スティーブ・ジョブズ" : 56,"ニコラウス・コペルニクス" : 70,"トルストイ" : 82,"チンギス・ハーン" : 65,"ジョン・レノン" : 40,"ウォルト・ディズニー" : 65,"マハトマ・ガンジー" : 78,"ルートヴィヒ・ヴァン・ベートーヴェン" : 56,"アンネ・フランク" : 16,"マリー・キュリー" : 66,"パブロ・ピカソ" : 91,"ウィリアム・シェイクスピア" : 52,"孔子" : 71,"フビライ・ハーン" : 78,"ジョン・フィッツジェラルド・ケネディ" : 46]
            
            let name = UserDefaults.standard.string(forKey: "sex") ?? "トーマス・エジソン"
            var modifiedDate = Calendar.current.date(byAdding: .year, value: namedictionary[name]!, to: load(key: "BirthArray")!)!
            now_time.text = TimerFunction(setDate: modifiedDate)
            
            
            
            
        }
        else{
            print("no")
            now_time.isHidden = true
            hello.isHidden = false
            registerButton.isHidden = false
            registerButton1.isHidden = true
        }
    }
    func TimerFunction(setDate: Date) -> String {

        var nowDate: Date = Date()

        let calendar = Calendar(identifier: .japanese)
        let timeValue = calendar
            .dateComponents([.year,.day, .hour, .minute, .second, .nanosecond], from: nowDate, to: setDate)
        return String(format: "あなた(\(UserDefaults.standard.string(forKey: "sex") ?? ""))の\n残りの人生時間\nあと"+"%02d年%02d日\n%02d時間%02d分\n%02d.%02d秒",
        timeValue.year!,
        timeValue.day!,
        timeValue.hour!,
        timeValue.minute!,
        timeValue.second!,
        timeValue.nanosecond!)
    }
    @objc func onPressClose(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
    }
    private func load(key: String) -> Date? {
        let value = UserDefaults.standard.object(forKey: key)
        guard let date = value as? Date else {
            return nil
        }
        return date
    }

}

extension LifeHourglassView: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        //処理
        if let back = UserDefaults.standard.string(forKey: "style") {
//            self.view.addBackground1(name: back)
            imageViewBackground.image = UIImage(named: imagearray[back]!)
            imageViewBackground.alpha = 0.65
            print(back)
        }
        else{
//            self.view.addBackground1(name: "雲がきれいな空と山")
            imageViewBackground.image = UIImage(named: "見渡す限りの遺跡")
            imageViewBackground.alpha = 0.65
            print("vf")
        }
        
    }
}
extension UIView {
    func addBackground(name: String) {
        // スクリーンサイズの取得
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        // スクリーンサイズにあわせてimageViewの配置
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        //imageViewに背景画像を表示
        imageViewBackground.image = UIImage(named: name)

        // 画像の表示モードを変更。
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

        // subviewをメインビューに追加
        self.addSubview(imageViewBackground)
        // 加えたsubviewを、最背面に設置する
        self.sendSubviewToBack(imageViewBackground)
    }
    func addBackground1(name: String) {
        // スクリーンサイズの取得
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        // スクリーンサイズにあわせてimageViewの配置
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        //imageViewに背景画像を表示
        imageViewBackground.image = UIImage(named: name)
        // 画像の表示モードを変更。
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

        // subviewをメインビューに追加
        self.addSubview(imageViewBackground)
        // 加えたsubviewを、最背面に設置する
        self.sendSubviewToBack(imageViewBackground)
    }
}

extension UIColor {
    class func hex ( string : String, alpha : CGFloat) -> UIColor {
        let string_ = string.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: string_ as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            return UIColor.white;
        }
    }
}
