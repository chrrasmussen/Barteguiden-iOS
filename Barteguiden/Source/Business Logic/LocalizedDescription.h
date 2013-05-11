//
//  _LocalizedDescription.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LocalizedText.h"

@class Event;

@interface LocalizedDescription : LocalizedText

@property (nonatomic, retain) Event *event;

@end