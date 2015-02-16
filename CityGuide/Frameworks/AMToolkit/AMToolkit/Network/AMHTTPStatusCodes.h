//
//  AMHTTPStatusCodes.h
//  PullToRefreshSample
//
//  Created by Anton Kaizer on 18.02.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#ifndef AMToolkit_AMHTTPStatusCodes_h
#define AMToolkit_AMHTTPStatusCodes_h

enum AMHTTPStatusCodes {
	HTTP_OK = 200,						//all ok
	
	HTTP_BAD_REQUEST = 400,				//wrong request
	HTTP_UNAUTORIZED = 401,				//need autorization
	HTTP_FORBIDDEN = 403,				//service refuse to fulfill request(for examlpe: if user not have enough privileges)
	HTTP_NOT_FOUND = 404,				//resource not found
	
	HTTP_MOVED_PERMANENTLY = 301,		//used for redirects
	HTTP_FOUND = 302,
	
	HTTP_INTERNAL_SERVER_ERROR = 500,	//service exception(may not have response body, or response body will contain html with error description)
	HTTP_NOT_IMPLEMENTED = 501,			//method not implemented
	HTTP_BAD_GATEWAY = 502,				//502, 503 and 504 - gateway problems
	HTTP_SERVICE_UNAVAILABLE = 503,
	HTTP_GATEWAY_TIMEOUT = 504
};

#endif
