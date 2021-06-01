//
//  FormView.swift
//  LifeHourglass
//
//  Created by 柴英嗣 on 2021/04/25.
//

import Foundation
import UIKit
import Eureka
import Cartography
import SCLAlertView

class FormView : FormViewController {
    
    var sex : String = ""
    var Birth : Date?
    var backimage : String = ""
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        form
        +++ Section("あなたの生年月日を選択")
            <<< DateRow("生年月日"){
                $0.title = "生年月日"
                $0.value = self.Birth ?? Date(timeIntervalSinceReferenceDate: 0)
                self.Birth = $0.value
            }.onChange({ [unowned self] row in
                self.Birth = row.value ?? nil
            })
        +++ Section("なりたい歴史上の人物を選択")
            <<< PushRow<String>(){
                $0.title = "人物名"
                $0.options = ["トーマス・エジソン","ヘレン・ケラー","アルベルト・アインシュタイン","ジャンヌ・ダルク","フローレンス・ナイチンゲール","レオナルド・ダ・ヴィンチ","マザーテレサ","ナポレオン・ボナパルト","アイザック・ニュートン","モーツァルト","イエス・キリスト","ガリレオ・ガリレイ","ヨハン・セバスティアン・バッハ","ニコラ・テスラ","クレオパトラ","釈迦","エイブラハム・リンカーン","スティーブ・ジョブズ","ニコラウス・コペルニクス","トルストイ","チンギス・ハーン","ジョン・レノン","ウォルト・ディズニー","マハトマ・ガンジー","ルートヴィヒ・ヴァン・ベートーヴェン","アンネ・フランク","マリー・キュリー","パブロ・ピカソ","ウィリアム・シェイクスピア","孔子","フビライ・ハーン","ジョン・フィッツジェラルド・ケネディ"]
                $0.value = self.sex
                $0.selectorTitle = "人物名"
                self.sex = $0.value ?? ""
            }.onPresent{ from, to in
                to.dismissOnSelection = true
                to.dismissOnChange = false
            }.onChange({ [unowned self] row in
                self.sex = row.value ?? ""
            })
        +++ Section("アプリの背景画像を選択")
            <<< PushRow<String>(){
                $0.title = "スタイル"
                $0.options = ["見渡す限りの遺跡" ,"地球儀と国旗" ,"古代の建造物" ,"海戦の様子","太陽が差し込む遺跡","砂漠のピラミッド" ,"戦争の様子","銃撃戦の様子","遠くに浮かぶ船"]
                $0.value = self.backimage
                $0.selectorTitle = "画像"
                self.backimage = $0.value ?? "見渡す限りの遺跡"
            }.onPresent{ from, to in
                to.dismissOnSelection = true
                to.dismissOnChange = false
            }.onChange({ [unowned self] row in
                self.backimage = row.value ?? "見渡す限りの遺跡"
            })
        +++ Section("選択した歴史上の人物の享年から残りの人生時間を算出しています")
            <<< ButtonRow("Button1") {row in
                    row.title = "登録"
                    row.onCellSelection{[unowned self] ButtonCellOf, row in
                        
                        if self.Birth == nil || self.sex == "" || self.sex == nil || self.backimage == "" || self.backimage == nil {
                            let alertView = SCLAlertView()
                            alertView.showInfo("", subTitle: "正しい情報を設定してください", closeButtonTitle: "OK")
                        }
                        else{
                        
                            let userDefaults = UserDefaults.standard
                            let BirthArray = self.Birth
                            let Sex = self.sex
                            // 配列の保存
                            userDefaults.set(BirthArray, forKey: "BirthArray")
                            userDefaults.set(Sex, forKey: "sex")
                            userDefaults.set(self.backimage, forKey: "style")

                            // userDefaultsに保存された値の取得
                            let birtharray = userDefaults.object(forKey: "BirthArray")
                            let sex = userDefaults.string(forKey: "sex")
                            print(load(key: "BirthArray"))
                            print(sex)
                            print(userDefaults.string(forKey: "style"))
                            
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let alertView = SCLAlertView(appearance: appearance)
                            alertView.addButton("OK") {
                                print("OK")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                NotificationCenter.default.post(name: Notification.Name("onChangeItem"), object: nil)
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                            alertView.showSuccess("", subTitle: "設定を登録しました")
                        }
                        
                    }
            }
    }
    private func load(key: String) -> Date? {
        let value = UserDefaults.standard.object(forKey: key)
        guard let date = value as? Date else {
            return nil
        }
        return date
    }
}
extension FormView {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
