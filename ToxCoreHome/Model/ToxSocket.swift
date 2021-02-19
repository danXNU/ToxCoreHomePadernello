//
//  ToxSocket.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 29/07/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation
import Socket

struct ToxAddress {
    var host: String
    var port : Int32
}


class ToxSocket<RequestType: Codable, ReturnType: Codable> {
    
    private var socket : Socket?
    private var address : ToxAddress?
    
    init(address : ToxAddress? = nil) throws {
        let host = serverAddress ?? "localhost"
        let port = Int32((serverPort == 0) ? 8080 : 8080)
        

        
        self.address = (address == nil) ? ToxAddress(host: host, port: port) : address
        do {
            try self.socket = Socket.create()
            //self.socket?.readBufferSize = 32768
        } catch {
            throw error
        }
    }
    
    private func connect(_ completion : (Error?) -> Void) {
        if let host = address?.host, let port = address?.port {
            do {
                try socket?.connect(to: host, port: port)
                completion(nil)
            } catch {
                completion(error)
            }

        }
    }
    
    private func read(in data: inout Data) -> Int {
        return try! self.socket?.read(into: &data) ?? 0
    }
    
    public func send(request: ToxRequest<RequestType>, completionHandler: (ReturnType?, Error?) -> Void) {
        self.connect { (connError) in
            if connError != nil {
                completionHandler(nil, connError!)
                return
            }
            
            guard let requestData = request.data else {
                completionHandler(nil, ToxError.inconsistencyLocalError(msg: "requestData == nil"))
                return
            }
            
            do {
                try self.socket?.write(from: requestData)
                
                var dataRead = Data()
                var bytes = 0
                repeat {
                    bytes = self.read(in: &dataRead)
                } while bytes > 0
                
//                print(String(data: dataRead, encoding: .utf8) ?? "Errore nel parsare la string")
                let response = try JSONDecoder().decode(ToxResponse<ReturnType>.self, from: dataRead)
                let code = response.code
                if code == "OK" {
                    completionHandler(response.responseObjects, nil)
                    return
                } else {
                    completionHandler(nil, ToxError.invalidResponseMessage(msg: response.responseMessage ?? "Errore generico"))
                    let json = try? JSONEncoder().encode(response)
                    guard let jsonData = json else { return }
                    print(String(data: jsonData, encoding: .utf8) ?? "Errore nell'ottenere il response String")
                    return
                }
                
            } catch {
                completionHandler(nil, error)
            }
        }
    }
    

}


