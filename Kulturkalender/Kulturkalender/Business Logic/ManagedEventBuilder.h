//
//  ManagedEventBuilder.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ManagedEvent;

@interface ManagedEventBuilder : NSObject

+ (ManagedEvent *)eventFromDictionary:(NSDictionary *)dictionary;

@end
