//
//  NewWords.h
//  DocReader
//
//  Created by pei hao on 13-11-5.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewWords : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSDate * addDate;
@end
