//
//  AMToolkitDefines.h
//  AMToolkit
//
//  Created by Konstantin Kabanov on 10/22/12.
//  Copyright (c) 2012 Arello Mobile. All rights reserved.
//

#ifndef AMToolkit_AMToolkitDefines_h
#define AMToolkit_AMToolkitDefines_h

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_WIDESCREEN  ([ [ UIScreen mainScreen ] bounds ].size.height == 568 )

#define IS_IOS7 ([[[UIDevice currentDevice].systemVersion substringToIndex:1] integerValue] >= 7)

#endif
