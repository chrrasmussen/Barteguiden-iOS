//
//  LocalizedFeatured.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LocalizedText.h"

@class Event;

@interface LocalizedFeatured : LocalizedText

@property (nonatomic, retain) Event *event;

@end