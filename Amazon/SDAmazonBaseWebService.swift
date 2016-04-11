//
//  SDAmazonBaseWebService.swift
//  ShreddDemand
//
//  Created by Kabir on 21/10/2015.
//  Copyright © 2015 Folio3. All rights reserved.
//

import Foundation
import AWSS3

public enum SDAS3WSErrorType : Int {
    case Unknown
    case Cancelled
    case Paused
    case Completed
    case InternalInConsistency
    case MissingRequiredParameters
    case InvalidParameters
}

public enum SDAS3WSRequestState : Int {
    case NotStarted
    case Running
    case Paused
    case Canceling
    case Completed
}


public typealias SDAS3WSCompletionCallback = (result: AnyObject!, error: NSError!, exception: NSException!) -> Void

class SDAmazonBaseWebService {
    
    var bucket: String! // S3 bucket
    var amazonBaseUri: String! // S3 Amazon base uri
    
    init(amazonBaseUri: String, bucket: String) {
        self.bucket = bucket
        self.amazonBaseUri = amazonBaseUri
    }
    
    
    /**
    Cancel all request
    
    - Throws: nil
    
    - Returns: nil
    */
    
    func cancelAll() {
        // Overide this in child class
    }
    
    
    /**
    Get error from Amazon web service task
    
    - Parameter task: Amazon web service task
    
    - Throws: nil
    
    - Returns: Optional Error
    */
    func getErrorFromTask(task: AWSTask) -> NSError? {
        var error = task.error
        /*
        print(" --------------- AMAZON ERROR ---------------")
        print("Error : \(error)")
        print("Error localizedDescription : \(error?.localizedDescription)")
        print(" -------------------------------------")
        */
        if error != nil {
            if error.domain == AWSS3TransferManagerErrorDomain as String {
                if let errorCode = SDAS3WSErrorType(rawValue: error.code) {
                    error = NSError(domain: error.domain, code: errorCode.rawValue, userInfo: error.userInfo)
                }
            }
        }

        return error
    }
}