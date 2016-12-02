/****************************************************************************
 * Copyright 2016, Optimizely, Inc. and contributors                        *
 *                                                                          *
 * Licensed under the Apache License, Version 2.0 (the "License");          *
 * you may not use this file except in compliance with the License.         *
 * You may obtain a copy of the License at                                  *
 *                                                                          *
 *    http://www.apache.org/licenses/LICENSE-2.0                            *
 *                                                                          *
 * Unless required by applicable law or agreed to in writing, software      *
 * distributed under the License is distributed on an "AS IS" BASIS,        *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. *
 * See the License for the specific language governing permissions and      *
 * limitations under the License.                                           *
 ***************************************************************************/

#import <Foundation/Foundation.h>
#import <OptimizelySDKCore/OPTLYUserProfile.h>
#import "OPTLYUserProfileBuilder.h"

@protocol OPTLYLogger;

@interface OPTLYUserProfile : NSObject<OPTLYUserProfile>

/// Logger provided by the user
@property (nonatomic, strong, nullable) id<OPTLYLogger> logger;

/**
 * Initializer for Optimizely User Profile object
 *
 * @param block The builder block with which to initialize the Optimizely User Profile object
 * @return An instance of OPTLYUserProfile
 */
+ (nullable instancetype)initWithBuilderBlock:(nonnull OPTLYUserProfileBuilderBlock)block;

/**
 * Default initializer for Optimizely User Profile object
 */
- (nullable instancetype)init;

/**
 * Cleans and removes all bucketing mapping for specific userId.
 * @param userId The user ID to remove all bucketing value.
 **/
- (void)removeUserExperimentRecordsForUser:(nonnull NSString *)userId;

/**
 * Cleans and removes all bucketing mapping.
 **/
- (void)removeAllUserExperimentRecords;

@end