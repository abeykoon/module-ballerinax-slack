// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
import ballerina/http;
import ballerina/log;
import ballerina/test;
import ballerina/config;

boolean msgReceived = false;

string token = config:getAsString("VERIFICATION_TOKEN");

ListenerConfiguration config = {verificationToken: token};

listener SlackEventListener slackListener = new (9090, config);

service /slack on slackListener {
    resource function post events(http:Caller caller, http:Request request) returns error? {

        var event = slackListener.getEventData(caller, request);

        if (event is SlackEvent) {
            string eventType = event.'type;
            if (eventType == APP_MENTION) {
                //triggered when your app mentioned in a chat
                log:print("App Mention Event Triggered");
            } else if (eventType == APP_HOME_OPENED) {
                //triggered when your app home opened
                log:print("App Home Opened Event Triggered");
            } else if (eventType == MESSAGE) {
                //triggered when messaged to a app home 
                log:print("Message Event Triggered");
            }
        } else {
            log:print("Error occured : " + event.toString());
        }

    }
}

@test:Config {enable: false}
function testMessageEvent() {
    test:assertTrue(msgReceived, msg = "Message Event Trigger Failed");
}



