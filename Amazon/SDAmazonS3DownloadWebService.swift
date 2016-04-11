//
//  SDAmazonS3DownloadWebService.swift
//  ShreddDemand
//
//  Created by Kabir on 20/10/2015.
//  Copyright © 2015 Folio3. All rights reserved.
//

import Foundation
import AWSS3

class SDAmazonS3DownloadWebService: SDAmazonBaseWebService {
    
    /**
    download content from Amazon S3
    
    - Parameter file : file url
    - Parameter completion: Get from amazon cognito console
    - Parameter completion: Get from amazon cognito console
    
    - Throws: nil
    
    - Returns: create request SDAWSS3TransferManagerDownloadRequest
    */
    
    func download(fileUrl: NSURL, completion: SDAS3WSCompletionCallback) -> SDAWSS3TransferManagerDownloadRequest {
        let request = SDAWSS3TransferManagerDownloadRequest()
        request.bucket = self.bucket
        request.key = fileUrl.lastPathComponent
        request.downloadingFileURL = fileUrl
  
        self.download(request, completion: completion)
        
        return request
    }
    
    /**
    download content from Amazon S3
    
    - Parameter request: Amazon S3 Transfer Manager Download Request
    - Parameter completion: Get from amazon cognito console
    
    - Throws: nil
    
    - Returns: create request SDAWSS3TransferManagerDownloadRequest
    */
    func download(request: SDAWSS3TransferManagerDownloadRequest, completion: SDAS3WSCompletionCallback?) {
        switch (request.state) {
        case .NotStarted, .Paused:
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            transferManager.download(request).continueWithBlock({ (task) -> AnyObject! in
                if completion != nil {
                    completion!(result: task, error: self.getErrorFromTask(task), exception: task.exception)
                }
                return request
            })
            
            break
        default:
            break
        }
    }
}