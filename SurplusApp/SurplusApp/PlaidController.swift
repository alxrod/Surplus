//
//  PlaidController.swift
//
//
//  Created by Alex Rodriguez on 5/25/19.
//

import Foundation
import Alamofire

class PlaidController {
    let rootURL = "sandbox.plaid.com"
    let client_id = "5ce9724e3462c600135e3843"
    let dev_secret = "fa6959a3edf412189534893e5d76e2"
    
    func getCoreComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = rootURL
        return components
    }
    
    typealias ConfServiceResponse = (String?,Error?) -> Void
    
    func get_access_tok(public_token: String, completion: @escaping ConfServiceResponse) {
        var components = getCoreComponents()
        components.path = "/item/public_token/exchange"
        
        let data = [
            "public_token": public_token,
            "client_id": client_id,
            "secret": dev_secret
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        
        //        components.queryItems = [queryPubToken, queryClientId, queryDevSecret]
        
        guard let url = components.url else { return }
        
        var urlRequest = URLRequest(url:url)
        urlRequest.httpBody = jsonData
        urlRequest.httpMethod = "POST"
        let header = HTTPHeader(name: "Content-Type", value: "application/json")
        urlRequest.headers = [header]
        
        AF.request(urlRequest).validate(contentType: ["application/json"]).responseJSON { response in
            switch response.result {
            case let .success(value):
                print("barely workoing ")
                print(value)
                if let dict = value as? Dictionary<String, String> {
                    if let token = dict["access_token"] as? String {
                        completion(token,nil)
                    }
                }
            case let .failure(error):
                
                completion(nil,error)
                
            }
        }
    }
    
    typealias TransServiceResponse = (Dictionary<String, Double>?,Error?) -> Void
    
    func get_transcations(access_token: String, completion: @escaping TransServiceResponse) {
        var components = getCoreComponents()
        components.path = "/transactions/get"
        
        
        let dateF = DateFormatter()
        dateF.dateFormat = "YYYY-MM-dd"
        let lastWeek = dateF.string(from: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!)
        let today = dateF.string(from: Date())
        
        
        let data = [
            "access_token": access_token,
            "client_id": client_id,
            "secret": dev_secret,
            "start_date": lastWeek,
            "end_date": today,
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        
        //        components.queryItems = [queryPubToken, queryClientId, queryDevSecret]
        
        guard let url = components.url else { return }
        
        var urlRequest = URLRequest(url:url)
        urlRequest.httpBody = jsonData
        urlRequest.httpMethod = "POST"
        let header = HTTPHeader(name: "Content-Type", value: "application/json")
        urlRequest.headers = [header]
        
        AF.request(urlRequest).validate(contentType: ["application/json"]).responseJSON { response in
            switch response.result {
            case let .success(value):
                print(value)
                //              if let dict = value as? Dictionary<String, Any> {
                var transactions: Dictionary<String, Double>
                transactions = [:]
                
                var total = 0
                var success = 0
                print("Initial Start")
                if let dict = value as? Dictionary<String, Any> {
                    //                        print("Outer dict worked")
                    if let transactionsJson = dict["transactions"] as? [Any] {
                        //                            print("mj dict cast worked")
                        for trans in transactionsJson {
                            if let transaction = trans as? Dictionary<String, Any> {
                                //                                    print("Small scale dict cast worked")
                                guard let amount = transaction["amount"] as? Double else {
                                    print(transaction["amount"]!)
                                    return
                                    
                                }
                                guard let name = transaction["name"] as? String else {
                                    print(transaction["name"])
                                    return
                                }
                                transactions[name] = amount
                                //                                    print("Far enough with \(amount)")
                                success+=1
                                
                            }
                            total+=1
                            
                        }
                        
                        
                    }
                }
                
                print("parsing finished")
//                print("Sucess rate \(success/total)")
                completion(transactions,nil)
                
                //                        completion(token,nil)
                
            case let .failure(error):
                
                completion(nil,error)
                
            }
        }
    }
    
    
    
}




