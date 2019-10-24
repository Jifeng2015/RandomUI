//
//  NetworkManager.swift
//  BeeColony
//
//  Created by TralyFang on 2019/3/21.
//  Copyright © 2019 TralyFang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import HandyJSON

class NetworkManager: NSObject {

    public enum HttpRequestMethod {
        case GET
        case POST

        var type: HTTPMethod {
            switch self {
            case .POST:
                return HTTPMethod.post
            default:
                return HTTPMethod.get
            }
        }
    }

    // 精简的请求处理
    public static func fastRequestHandler(method: HttpRequestMethod = .GET,host:String?=nil, pathString: String, parameters: [String: Any]? = nil, showError: Bool = true,both:Bool=false, completion: @escaping ((_ respModel :Any?)->())) {
        
        let appHost = "http://appid.985-985.com:8088/getAppConfig.php?appid=iosapptest"
        
        let URLString = String.init(format: "%@%@", host ?? appHost, pathString)
        
        let taskReq = Alamofire.request(URLString, method: method.type, parameters: parameters).responseJSON { (resp) in
            if !both {
                HttpClientManager.manager.taskRequestCancel(key: pathString)
            }
            logRespone(resp, path: URLString, params: parameters)
            completion(responseParser(resp))
            HttpClientManager.responseHandler(resp, showError: showError)
        }
        if !both { // 可同时请求相同的接口
            HttpClientManager.manager.taskRequestAdd(taskReq, key: pathString)
        }

    }
    fileprivate static func responseParser(_ resp: DataResponse<Any>) -> Any? {
        return resp.value
    }

    fileprivate static func logRespone(_ resp: DataResponse<Any>, path: String, params: [String: Any]? = nil) {
        let log = String(format: "%@%@%@==error:%@=statusCode:%d", path, params ?? [:], JSON(resp.value ?? [:]).debugDescription,resp.error.debugDescription,resp.response?.statusCode ?? 0)
        print(log)
    }

}


open class HttpClientManager {
    private var taskRequests = [AnyHashable: DataRequest]()

    public static let manager: HttpClientManager = { return HttpClientManager() }()

    class func responseHandler(_ response: DataResponse<Any>, showError: Bool = true) {

        if let _ = response.value {
        }

        if response.error?.localizedDescription.contains("超时") ?? false {
            if showError {
//                EPHud.showInfo("抱歉，连接服务器失败，请稍后重试")
            }
        }
        if let code = response.response?.statusCode {
            if showError && code < 600 && code > 499 {
//                EPHud.showInfo("抱歉，服务器正在升级维护中，请稍后重试 Code:\(code)")
            }
        }
    }


    // MARK: - 请求进程处理
    func taskRequestAdd(_ requset: DataRequest, key: String) {
        taskRequests[NSString(string: key).md5()] = requset
    }
    func taskRequestCancel(key: String) {
        if let req = taskRequests[NSString(string: key).md5()] {
            req.cancel()
        }
    }
    func taskResquestAllCancel() {
        for key in taskRequests.keys {
            if let req = taskRequests[key] {
                req.cancel()
            }
        }
    }
}
