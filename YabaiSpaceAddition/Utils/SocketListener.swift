//
//  SocketListener.swift
//  YabaiSpaceAddition
//
//  Created by Onni Nevala on 27.3.2025.
//

import Foundation

let targetSocket = "/tmp/yabaispacemanager.socket"

class SockListener {
    var running: Bool = true
    var topBarManager: TopBarManager
    
    init(topBarManager: TopBarManager) {
        self.topBarManager = topBarManager
    }
    
    public func kill() {
        running = false
    }
    
    public func scanner() {
        let serverSocket = socket(AF_UNIX, SOCK_STREAM, 0)
        if serverSocket == -1 {
            fatalError("Error creating socket")
        }
        var addr = sockaddr_un()
         
        addr.sun_family = sa_family_t(AF_UNIX)
        
        let pathBytes = targetSocket.utf8CString
        if pathBytes.count > MemoryLayout.size(ofValue: addr.sun_path) {
            print("Error: Socket path is too long!")
            close(serverSocket)
            return
        }
        
        withUnsafeMutablePointer(to: &addr.sun_path) { ptr in
            ptr.withMemoryRebound(to: Int8.self, capacity: pathBytes.count) { reboundedPtr in
                for i in 0..<pathBytes.count {
                    reboundedPtr[i] = pathBytes[i]
                }
            }
        }
        
        unlink(targetSocket)
        
        let addrCopy = addr
        
        let bindResult = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { addrPtr in
                Darwin.bind(serverSocket, addrPtr, socklen_t(MemoryLayout.size(ofValue:  addrCopy)))
            }
        }
        
        if bindResult == -1 {
            close(serverSocket)
            fatalError("Error binding socket")
        }
        
        if listen(serverSocket, 10) == -1 {
            perror("Error listening on socket")
            close(serverSocket)
            return
        }
        
        print("Starting list")
        
        while  self.running {
            let clientSocket = accept(serverSocket, nil, nil)
            if clientSocket == -1 {
                perror("Error accepting connection")
                continue
            }
            var buffer = [CChar](repeating: 0, count: 1024)
            let bytesRead = read(clientSocket, &buffer, 1024)
            
            if bytesRead > 0 {
                let message = String(cString: buffer)
                
                if message.contains("refresh") {
                    print("Got refresh")
                    self.topBarManager.refresh()
                }
            
                
                
                print("Received message: \(message)")
            } else {
                perror("Error reading message")
            }
            close(clientSocket)
        }
        
        close(serverSocket)
        
    }
}
