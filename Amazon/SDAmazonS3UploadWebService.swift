//
//  SDAmazonS3UploadWebService.swift
//  ShreddDemand
//
//  Created by Kabir on 20/10/2015.
//  Copyright © 2015 Folio3. All rights reserved.
//

import Foundation
import AWSS3

class SDAmazonS3UploadWebService: SDAmazonBaseWebService {
    
    
    override init(amazonBaseUri: String, bucket: String) {
        super.init(amazonBaseUri: amazonBaseUri, bucket: bucket)
    }
    
    /**
    upload content on Amazon S3
    
    - Parameter file : file url, where url need to be local
    - Parameter key: Path where data needs to be reside. Optional parameter if key is nil resource will be upload on root.
    - Parameter completion: Get from amazon cognito console
    
    - Throws: nil
    
    - Returns: create request SDAWSS3TransferManagerDownloadRequest
    */
    
    func upload(fileUrl: NSURL, key: String?, completion: SDAS3WSCompletionCallback) -> SDAWSS3TransferManagerUploadRequest {
        let request = SDAWSS3TransferManagerUploadRequest()
        request.body = fileUrl
        request.key = key
        request.bucket = self.bucket
        request.ACL = .PublicReadWrite
        
        self.upload(request, completion: completion)
        
        return request
    }
    
    /**
    download content from Amazon S3
    
    - Parameter file : file url
    - Parameter completion: Get from amazon cognito console
    - Parameter completion: Get from amazon cognito console
    
    - Throws: nil
    
    - Returns: create request SDAWSS3TransferManagerDownloadRequest
    */
    func upload(request: SDAWSS3TransferManagerUploadRequest, completion: SDAS3WSCompletionCallback) {
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        transferManager.upload(request).continueWithBlock { (task) -> AnyObject! in
            dispatch_async(dispatch_get_main_queue(), {
            
                completion(result: self.getRequestResponse(request, task: task), error: self.getErrorFromTask(task), exception: task.exception)
            })

            
            return request
        }
    }
    
    // MARK: Private
    
    /**
    Get response object from Amazon web service task
    
    - Parameter task: Amazon web service task
    
    - Throws: nil
    
    - Returns: Optional Error
    */
    func getRequestResponse(request: SDAWSS3TransferManagerUploadRequest, task: AWSTask) -> [String: String]? {
        guard let output = task.result as? AWSS3TransferManagerUploadOutput else {
            return nil
        }
        
        let uri = "\(self.amazonBaseUri)/\(request.bucket!)/\(request.key!)"
        let etag = output.ETag!.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let info = ["etag": etag, "uri": uri, "key_path": request.key!]
        return info
    }

}