//
//  ServiceManager.swift
//  FitnessExprt
//
//  Created by Codexprt on 21/12/21.
//

import Foundation
import Alamofire

class ServiceManager{
    
    let baseURL = "http://192.168.0.115:3000/api/user/"
    let baseURLNutrition = "http://192.168.0.115:5000/api/nutrition/"
    let baseURLBlog = "http://192.168.0.115:5000/api/blog/"
    let baseComonURL = "http://192.168.0.115:5000/api/"

    let Register = "register"
    let Login = "login"

    func PostUploadImage(url:String, img:UIImage,handler:@escaping ([String:Any]?,Error?) -> Void){
        let FullURl = baseURL+url
        var accessToken =  UserDefaults.standard.string(forKey: "access_token") ?? ""
        let access:HTTPHeaders = ["Authorization": "bearer \(accessToken)"]
        let imgData = img.jpegData(compressionQuality: 0.2)!
        AF.upload(multipartFormData: { multipartFormData in
               multipartFormData.append(imgData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
           },to:FullURl,headers: access).responseJSON{
            responce in
            switch responce.result{
            case .success(let res):
                print(res)
                break
                
            case.failure(let error):
                print(error)
                break
            }
        }
    }
    
    func PostAddRecipeImage(url:String, parameters : [String:String] ,img:UIImage,handler:@escaping ([String:Any]?,Error?) -> Void){
        let FullURl = baseComonURL+url
        var accessToken =  UserDefaults.standard.string(forKey: "access_token") ?? ""
        let access:HTTPHeaders = ["Authorization": "bearer \(accessToken)"]
        let imgData = img.jpegData(compressionQuality: 0.2)!
        AF.upload(multipartFormData: { multipartFormData in
               multipartFormData.append(imgData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }

        },to:FullURl,headers: access).responseJSON{
            responce in
            switch responce.result{
            case .success(let res):
                print(res)
                let res = res as! [String: Any]
                handler(res,nil)
                break
                
            case.failure(let error):
                print(error)
                print(error)
                handler(nil,error)
                break
            }
        }
    }
    
    func PostRequestDeleteNutrion(url: String,param:[String:Any], handler:@escaping ([String:Any]?,Error?) -> Void){
        let FullURl = baseComonURL+url
        var accessToken =  UserDefaults.standard.string(forKey: "access_token") ?? ""
        let access:HTTPHeaders = ["Authorization": "bearer \(accessToken)"]
        AF.request(FullURl ,method: .post, parameters:param, encoding:JSONEncoding.default,headers: access).responseJSON{[self] response in
            switch response.result{
            case.success(let value):
                print(value)
                let res = value as! [String: Any]
                handler(res,nil)
                break
            case.failure(let error):
                print(error)
                handler(nil,error)
                break
            }
        }
    }

    func PostRequestWithToken(url: String,param:[String:String], handler:@escaping ([String:Any]?,Error?) -> Void){
        let FullURl = baseComonURL+url
        var accessToken =  UserDefaults.standard.string(forKey: "access_token") ?? ""
        let access:HTTPHeaders = ["Authorization": "bearer \(accessToken)"]
        AF.request(FullURl ,method: .post, parameters:param, headers: access).responseJSON{[self] response in
            switch response.result{
            case.success(let value):
                print(value)
                let res = value as! [String: Any]
                handler(res,nil)
                break
            case.failure(let error):
                print(error)
                handler(nil,error)
                break
            }
        }
    }
    
    func PostRequest(url: String,param:[String:String], handler:@escaping ([String:Any]?,Error?) -> Void){
        let FullURl = baseURL+url
        
        AF.request(FullURl,method: .post,parameters:param).responseJSON{[self] response in
            switch response.result{
            case.success(let value):
                print(value)
                let res = value as! [String: Any]
                handler(res,nil)
                break
            case.failure(let error):
                print(error)
                handler(nil,error)
                break
            }
        }
    }

    func getRequest(url:String, handler:@escaping ([String:Any]?,Error?) -> Void){
        let FullUrl = baseURL+url
        var accessToken =  "cd8de2f0dd92612891bb97a5a24cdfd583f493428e43884dfad9b166b432e942"
        let access:HTTPHeaders = ["Authorization": "bearer \(accessToken)"]
        AF.request(FullUrl,headers:access).responseJSON{ response in
            switch response.result
            {
            case .success(let value):
                print(value)
                let res = value as! [String: Any]
                handler(res,nil)
                break
            case .failure(let error):
                print(error)
                handler(nil,error)
            }
        }
    }

    func getRequestNutrition(url:String, handler:@escaping ([String:Any]?,Error?) -> Void){
        let FullUrl = baseComonURL+url
        var accessToken =  UserDefaults.standard.string(forKey: "access_token") ?? ""
        let access:HTTPHeaders = ["Authorization": "bearer \(accessToken)"]
        AF.request(FullUrl,headers:access).responseJSON{ response in
            switch response.result
            {
            case .success(let value):
                print(value)
                let res = value as! [String: Any]
                handler(res,nil)
                break
            case .failure(let error):
                print(error)
                handler(nil,error)
            }
        }
    }

    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
   

}

