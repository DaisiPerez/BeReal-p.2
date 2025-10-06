# Project 3 - BeReal

Submitted by: Daisi Perez

BeReal is a social media app that allows you to upload pictures in real time. There is a feed that demonstrates pictures shared by the users in addition to a caption and location. 
There is now a comment feature and users can't see other posts unless they post first! After 24 hours, all posts get get erased from the feed, thus, making
room for more posts!

Time spent: 10 hours spent in total

## Required Features

The following **required** functionality is completed:

- [ ] User can launch camera to take photo instead of photo library
  - [X] Users without iPhones to demo this feature can manually add unique photos to their simulator's Photos app
- [X] Users are not able to see other users’ photos until they upload their own.
- [X] Users can intereact with posts via comments, comments will have user data such as username and name
- [X] Posts have a time and location attached to them
- [X] Users are not able to see other photos until they post their own (within 24 hours)	
 
The following **optional** features are implemented:

- [ ] User receive notifcation when it is time to post

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

## Video Walkthrough

https://youtu.be/n-20y4YiZF0

## Notes

My biggest challenge while working on this app was the comment secton. I had a lot of trouble with the UI features on storyboard, especially the keyboard functionality.
I tried implementing it using the the bottom constraint plugin but it would not work for dear life! I ended up just coding it in the CommentViewFinder.swift file.
I would like to mention that posts actually do get erased after 24 hours! The previous posts made from part 1 of this project are long gone, as demonstrated in the video. 

## License

    Copyright [2025] [Daisi Perez]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
