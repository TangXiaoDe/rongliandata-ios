//
//  String+URL.swift
//  RongLianData
//
//  Created by 小唐 on 2019/7/8.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  String相关扩展

import Foundation
import UIKit
import CommonCrypto

extension String {



}

class XDStringHelper {
    
    /// 手机号掩码处理 - 中间4位****处理
    open class func phoneMaskProcess(_ phone: String?) -> String? {
        guard var phone = phone, !phone.isEmpty else {
            return nil
        }
        var maskPhone: String? = phone
        if 11 == phone.count {
            // 11 位
            let replaceRange = Range<String.Index>.init(uncheckedBounds: (lower: phone.index(phone.startIndex, offsetBy: 3), upper: phone.index(phone.startIndex, offsetBy: 7)))
            phone.replaceSubrange(replaceRange, with: "****")
            maskPhone = phone
        } else if 11 < phone.count {
            // 超过 11 位 - 前3位 和 最后4位
            let strSuffix = phone.subString(location: UInt(phone.count - 4), length: 4)
            let strPrefix = phone.subString(location: 0, length: 3)
            maskPhone = strPrefix + "****" + strSuffix
        } else if 11 > phone.count {
            // 不足 11 位 - 不予处理
            maskPhone = phone
        }
        return maskPhone
    }
    
    
    /// 身份张掩码处理 - 前面6位后面5位(xxxxxxYYYYMMDDxxxx)
    open class func idCardNoMaskProcess(_ idCardNo: String?) -> String? {
        guard var idCardNo = idCardNo, !idCardNo.isEmpty else {
            return nil
        }
        var maskIdCardNo: String? = idCardNo
//        if 18 == idCardNo.count {
//            // 18 位
//            let replaceRange = Range<String.Index>.init(uncheckedBounds: (lower: idCardNo.index(idCardNo.startIndex, offsetBy: 6), upper: idCardNo.index(idCardNo.startIndex, offsetBy: 13)))
//            idCardNo.replaceSubrange(replaceRange, with: "*******")
//            maskIdCardNo = idCardNo
//        } else
        if 18 <= idCardNo.count {
            // 超过 18 位 - 前6位 和 最后5位
            let strSuffix = idCardNo.subString(location: UInt(idCardNo.count - 5), length: 5)
            let strPrefix = idCardNo.subString(location: 0, length: 6)
            maskIdCardNo = strPrefix + "*******" + strSuffix
        } else if 18 > idCardNo.count {
            // 不足 18 位 - 不予处理
            maskIdCardNo = idCardNo
        }
        return maskIdCardNo
    }
    
    
    /// 姓名掩码处理 - 前后各1位
    open class func nameMaskProcess(_ name: String) -> String {
        guard !name.isEmpty else {
            return ""
        }
        var result: String = name
        if 2 <= name.count {
            // 超过 2 位 - 前1位 和 最后1位
            let strSuffix = name.subString(location: UInt(name.count - 1), length: 1)
            let strPrefix = name.subString(location: 0, length: 1)
            result = strPrefix + "*" + strSuffix
        } else if 2 > name.count {
            // 不足 2 位 - 不予处理
            result = name
        }
        return result
    }
    
    /// 支付宝账号/银行卡 掩码处理 - 中间4位****处理
    open class func cnyAccountMaskProcess(_ account: String) -> String {
        guard !account.isEmpty else {
            return ""
        }
        var maskPhone: String = account
        if 7 <= account.count {
            // 超过 6 位 - 前3位 和 最后4位
            let strSuffix = account.subString(location: UInt(account.count - 4), length: 4)
            let strPrefix = account.subString(location: 0, length: 3)
            maskPhone = strPrefix + "****" + strSuffix
        } else if 7 > account.count {
            // 不足 7 位 - 不予处理
            maskPhone = account
        }
        return maskPhone
    }
}





extension String {
    
    //3des加解密
    //op传1位加密，0为解密
    func threeDESEncryptOrDecrypt(op: Int, key: String, iv: String) -> String? {
        //CCOperation（kCCEncrypt）加密 1
        //CCOperation（kCCDecrypt) 解密 0
        var ccop = CCOperation()
//        let key = "7hVz8xZAElvf4Mpyu08jiLpqnl144onLtjVhxX81x4o="
//        let iv = "84339247"
        // Key
        let keyData: NSData = (key as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        let keyBytes = UnsafeRawPointer(keyData.bytes)

        // 加密或解密的内容
        var data: NSData = NSData()
        if op == 1 {
            ccop = CCOperation(kCCEncrypt)
            data = (self as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        } else {
            ccop = CCOperation(kCCDecrypt)
            if let dataTmp = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
                data = dataTmp
            }
        }

        let dataLength = size_t(data.length)
        let dataBytes = UnsafeRawPointer(data.bytes)
        // 返回数据
        let cryptData = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)
        let cryptPointer = UnsafeMutableRawPointer(cryptData!.mutableBytes)
        let cryptLength = size_t(cryptData!.length)

        //  可选 的初始化向量
        let viData: NSData = (iv as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        let viDataBytes = UnsafeRawPointer(viData.bytes)

        // 特定的几个参数
        let keyLength = size_t(kCCKeySize3DES)
        let operation: CCOperation = UInt32(ccop)
        let algoritm: CCAlgorithm = UInt32(kCCAlgorithm3DES)
        let options: CCOptions = UInt32(kCCOptionPKCS7Padding)

        var numBytesCrypted: size_t = 0

        let cryptStatus = CCCrypt(operation, // 加密还是解密
            algoritm, // 算法类型
            options, // 密码块的设置选项
            keyBytes, // 秘钥的字节
            keyLength, // 秘钥的长度
            viDataBytes, // 可选初始化向量的字节
            dataBytes, // 加解密内容的字节
            dataLength, // 加解密内容的长度
            cryptPointer, // output data buffer
            cryptLength, // output data length available
            &numBytesCrypted) // real output data lengths

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData!.length = Int(numBytesCrypted)
            if op == 1 {
                let base64cryptString = cryptData!.base64EncodedString(options: .lineLength64Characters)
                //返回加密的数据
                return base64cryptString
            }
            else {
                let base64cryptString = NSString(data: cryptData! as Data, encoding: String.Encoding.utf8.rawValue) as String?
                //返回解密的数据
                return base64cryptString
            }
        } else {
            print("Error: \(cryptStatus)")
        }
        return nil
    }

}


public extension String {

    /// 小数前后字体不一致处理
    func doubleValueWithTwoFont(_ firstFont: UIFont, _ secondFont: UIFont) -> NSAttributedString {
        if !self.contains(".") {
            return NSAttributedString.init(string: self)
        }
        let array = self.components(separatedBy: ".")
        guard let firstStr = array.first, let secondStr = array.last else {
            return NSAttributedString.init(string: self)
        }
        let firstAtt = NSMutableAttributedString.init(string: firstStr + ".", attributes: [NSAttributedString.Key.font: firstFont])
        let secondAtt = NSMutableAttributedString.init(string: secondStr, attributes: [NSAttributedString.Key.font: secondFont])
        // doubleAtts
        let doubleAtts = NSMutableAttributedString()
        doubleAtts.append(firstAtt)
        doubleAtts.append(secondAtt)
        return doubleAtts
    }
}

public extension String {
//    "^[A-Z,a-z,\\d]+([-_.][A-Z,a-z,\\d]+)*@([A-Z,a-z,\\d]+[-.])+[A-Z,a-z,\\d]{2,4}"
    /// 邮箱正则匹配判断
    func isEmailNum() -> Bool {
        // "^1([0-9]{10})$"
        let strRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return self.isMatchRegex(strRegex)
    }
    func isTelePhoneNum() -> Bool {
        let strRegex: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        return self.isMatchRegex(strRegex)
    }
    func isEmailOrTelePhoneNum() -> Bool {
        return self.isEmailNum() || self.isTelePhoneNum()
    }
}
