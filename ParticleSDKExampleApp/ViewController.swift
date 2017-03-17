//
//  ViewController.swift
//  ParticleSDKExampleApp
//
//  Created by Ido Kleinman on 3/31/16.
//  Copyright © 2016 Particle. All rights reserved.
//

import UIKit
import ParticleDeviceSetupLibrary
import ParticleSDK

class ViewController: UIViewController, SparkSetupMainControllerDelegate, SparkDeviceDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sparkSetupViewController(_ controller: SparkSetupMainController!, didFinishWith result: SparkSetupMainControllerResult, device: SparkDevice!) {
        
        print("result: \(result), and device: \(device)")
        
    }
    
    @IBAction func invokeSetup(_ sender: AnyObject) {
        print("Particle Device setup lib V:\(ParticleDeviceSetupLibraryVersionNumber)\nParticle SDK V:\(ParticleSDKVersionNumber)")
        
        // lines required for invoking the Spark Setup wizard
        if let vc = SparkSetupMainController()
        {
            
            // check organization setup mode
            let c = SparkSetupCustomization.sharedInstance()
            c?.allowSkipAuthentication = true
            
            vc.delegate = self
            vc.modalPresentationStyle = .formSheet  // use that for iPad
            self.present(vc, animated: true, completion: nil)
        }

    }
    
    @IBAction func invokeCloudSDK(_ sender: AnyObject) {
        self.testCloudSDK()
    }
    
    func sparkDevice(_ device: SparkDevice, didReceive event: SparkDeviceSystemEvent) {
        print("Device "+device.name!+" received system event id "+String(event.rawValue))
    }
    
    func testCloudSDK()
    {
        let loginGroup : DispatchGroup = DispatchGroup()
        let deviceGroup : DispatchGroup = DispatchGroup()
        let functionName = "testFunc"
        let variableName = "testVar"
        var myPhoton : SparkDevice? = nil
        var myEventId : Any?

        
        // CHANGE THESE CONSANTS TO WHAT YOU NEED:
        let deviceName = "hobbit_wombat"
        let username = "testuser@particle.io"
        let password = "testpass"

        
        DispatchQueue(label: "example1", qos: DispatchQoS.default).async {
            // logging in
            loginGroup.enter();
            deviceGroup.enter();
            if SparkCloud.sharedInstance().isAuthenticated {
                print("logging out of old session")
                SparkCloud.sharedInstance().logout()
            }
            
            SparkCloud.sharedInstance().login(withUser: username, password: password, completion: { (error : Error?) in  // or possibly: .injectSessionAccessToken("ec05695c1b224a262f1a1e92d5fc2de912c467a1")
                if let _ = error {
                    print("Wrong credentials or no internet connectivity, please try again")
                }
                else
                {
                    print("Logged in with user "+username) // or with injected token
                    loginGroup.leave()
                }
            })
        }
        
        DispatchQueue(label: "example1", qos: DispatchQoS.default).async {
            // logging in
            _ = loginGroup.wait(timeout: DispatchTime.distantFuture)
            
            // get specific device by name:
            SparkCloud.sharedInstance().getDevices { (sparkDevices:[SparkDevice]?, error:Error?) -> Void in
                if let _=error
                {
                    print("Check your internet connectivity")
                }
                else
                {
                    if let devices = sparkDevices
                    {
                        for device in devices
                        {
                            if device.name == deviceName
                            {
                                print("found a device with name "+deviceName+" in your account")
                                myPhoton = device
                                deviceGroup.leave()
                            }
                            
                        }
                        if (myPhoton == nil)
                        {
                            print("device with name "+deviceName+" was not found in your account")
                        }
                    }
                }
            }
        }
        
        
        DispatchQueue(label: "example1", qos: DispatchQoS.default).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture)
            deviceGroup.enter();
            
            print("subscribing to event...");
            var gotFirstEvent : Bool = false
            myEventId = myPhoton!.subscribeToEvents(withPrefix: "some-test", handler: { (event: SparkEvent?, error:Error?) -> Void in
                if (!gotFirstEvent) {
                    print("Got first event: "+event!.event)
                    gotFirstEvent = true
                    deviceGroup.leave()
                } else {
                    print("Got event: "+event!.event)
                }
            });
        }
        
        
        // calling a function
        DispatchQueue(label: "example1", qos: DispatchQoS.default).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture) // 5
            deviceGroup.enter();
            
            let funcArgs = ["D7",1] as [Any]
            myPhoton!.callFunction(functionName, withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
                if (error == nil) {
                    print("Successfully called function "+functionName+" on device "+deviceName)
                    deviceGroup.leave()
                } else {
                    print("Failed to call function "+functionName+" on device "+deviceName)
                }
            }
        }
        
        
        // reading a variable
        DispatchQueue(label: "example1", qos: DispatchQoS.default).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture) // 5
            deviceGroup.enter();
            
            myPhoton!.getVariable(variableName, completion: { (result:Any?, error:Error?) -> Void in
                if let _=error
                {
                    print("Failed reading variable "+variableName+" from device")
                }
                else
                {
                    if let res = result as? Int
                    {
                        print("Variable "+variableName+" value is \(res)")
                        deviceGroup.leave()
                    }
                }
            })
        }
        
        
        // get device variables and functions
        DispatchQueue(label: "example1", qos: DispatchQoS.default).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture) // 5
            deviceGroup.enter();
            
            let myDeviceVariables : Dictionary? = myPhoton!.variables as Dictionary<String,String>
            print("MyDevice first Variable is called \(myDeviceVariables!.keys.first) and is from type \(myDeviceVariables?.values.first)")
            
            let myDeviceFunction = myPhoton!.functions
            print("MyDevice first function is called \(myDeviceFunction.first)")
            deviceGroup.leave()
        }
        
        // logout
        DispatchQueue(label: "example1", qos: DispatchQoS.default).async {
            // logging in
            _ = deviceGroup.wait(timeout: DispatchTime.distantFuture) // 5
            
            if let eId = myEventId {
                myPhoton!.unsubscribeFromEvent(withID: eId)
            }
            SparkCloud.sharedInstance().logout()
            
            print("logged out")
        }
        
    }
}

