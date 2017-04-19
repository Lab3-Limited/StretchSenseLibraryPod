/**
 - note: StretchSenseLibrary.swift
 
 - Important: This StretchSense library has been designed to enable the connection of one or more "StretchSense Fabric Evaluation Sensor" and "StretchSenset 10 Channels Sensors" to your iOS application
 
 - Author: Jeremy Labrado
 
 - Copyright:  2016 StretchSense
 
 - Date: 22/11/2016
 
 - Version:    2.0.0
 
 **Definitions:**
 - **Peripheral**: Bluetooth 4.0 enabled sensors
 - **Manager**: Bluetooth 4.0 enabled iOS device

 */


import UIKit
import Foundation
import CoreBluetooth // To use the bluetooth
import MessageUI
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



/*-------------------------------------------------------------------------------*/
// MARK: - CLASS STRETCHSENSEPERIPHERAL

/**
 This class defines a single Fabric Evaluation StretchSense sensor
 
 - note: Each sensor is defined by:
 - A universal unique identifier UUID
 - A unique number, based on the order when the sensor is connected
 - A unique color, choose with his unique number
 - A current capacitance value
 - An array of the previous capacitance raw values
 - An array of the previous capacitance averaged values
 
 
 ```swift
 // Example: Display the sensors connected in a table
 
 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 // Determine the total number of sensors connected (i.e. total number of elements within a table)
 return stretchsenseObject.getNumberOfPeripheralConnected()
 }
 
 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 // This function is called to populate each row in the table
 // The row number of the table is define with his indexPath.row
 
 // The current cell
 let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
 // The current peripheral
 let myPeripheral = listPeripheralsConnected[indexPath.row]
 
 // display the title: capactiance value of the sensor
 cell.textLabel?.text = myPeripheralConnected.value
 // display the subtitle: identifier color (text) of the sensor
 cell.detailTextLabel?.text = myPeripheral.colors[myPeripheral.uniqueNumber].colorName
 // change the background color of the cell: indentifier color of the sensor
 cell.backgroundColor = myPeripheral.colors[myPeripheral.uniqueNumber].valueRGB
 }
 
 */
class StretchSensePeripheral{
    // ----------------------------------------------------------------------------
    // MARK: VARIABLES
    // ----------------------------------------------------------------------------

    /// Universal Unique IDentifier
    var uuid = "";
    /// Current capacitance value of the sensor
    var value = CGFloat();
    /// A unique number for each sensor, based on the order when the sensor is connected
    var uniqueNumber = 0;
    /// The 30 previous samples averaged
    var previousValueAveraged = [CGFloat](repeating: 0, count: 30)
    /// The 30 previous samples raw
    var previousValueRawFromTheSensor = [CGFloat](repeating: 0, count: 30)
    /// Bool used to validate the display of the sensor in the graph
    var display = true
    /// Generation of the circuit, for the moment gen 2 or gen 3
    var gen = 3;
    
    /// Structure of Color: (name: String, valueRGB: UIColor)
    struct Color {
        /// The color name (Blue, Orange, Green, Red, Purple, Brown, Pink, Grey)
        var colorName: String = "colorName"
        /// The value (RGB) of the color (Blue, Orange, Green, Red, Purple, Brown, Pink, Grey)
        var colorValueRGB: UIColor = UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1)
    }
    
    /// Array of color already implemented (Blue, Orange, Green, Red, Purple, Brown...)
    /// The colors list is copy/paste a few time to avoid range issue
    /// Advice: use the variable uniqueNumber as reference of this array to have a unique color for each sensor
    var colors : [Color] = [
        Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
        Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
        Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
        Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
        Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
        Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
        Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
        Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
        Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
        Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
        Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
        
        Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
        Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
        Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
        Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
        Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
        Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
        Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
        Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
        Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
        Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
        Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
        
        Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
        Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
        Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
        Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
        Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
        Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
        Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
        Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
        Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
        Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
        Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
        
        Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
        Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
        Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
        Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
        Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
        Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
        Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
        Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
        Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
        Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
        Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
        
        Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
        Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
        Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
        Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
        Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
        Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
        Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
        Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
        Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
        Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
        Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
        
        Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
        Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
        Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
        Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
        Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
        Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
        Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
        Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
        Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
        Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
        Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1))
        ]
}



/*-------------------------------------------------------------------------------*/
// ----------------------------------------------------------------------------
// MARK: - CLASS STRETCHSENSEAPI
// ----------------------------------------------------------------------------

/**
 ## StretchSenseAPI ##
 
 The StretchSense API defines all functions required to connect to, and stream data from, the StretchSense Fabric Sensors linked to your iOS application
 
 - Author: StretchSense
 
 - Copyright:  2016 StretchSense
 
 - Date: 1/06/2016
 
 - Version:    1.0.0
 
 - note: Within the StretchSenseClass
	-	Peripherals lists (available, connected, saved)
	-	General settings  (number of samples to hold in memory, sampling time, average filtering value)
	-	Feedback information
 
 ```swift
 //Example 1: Connect to the available sensors
 
 class ViewController: UIViewController {
 
 var stretchsenseObject = StretchSenseAPI()
 
 override func viewDidLoad() {
 // This function is the first function called by the View Controller
 super.viewDidLoad()
 
 // Init the StretchSense API and Bluetooth
 stretchsenseObject.startBluetooth()
 // Start Scanning new peripheral
 stretchsenseObject.startScanning()
 }
 
 @IBAction func connect(sender: AnyObject) {
 // Get all available peripherals
 var listPeripheralAvailable = stretchsenseObject.getListPeripheralsAvailable()
 // Explore all the available peripherals
 for myPeripheralAvailable in listPeripheralAvailable{
 // Connect to all available, peripheral devices
 stretchsenseObject.connectToPeripheralWithCBPeripheral(myPeripheralAvailable)
 print(myPeripheralAvailable)
 }
 }
 
 @IBAction func printValue(sender: AnyObject) {
 // Get a list of all connect perihpheral devices
 var listPeripheralConnect = stretchsenseObject.getListPeripheralsConnected()
 // Print current capacitance value from all of the connected peripherals
 for myPeripheralConnected in listPeripheralConnect{
 // Print the value of all the peripheral connected
 print(myPeripheralConnected.value)
 }
 }
 }
 
 
 //Example 2: Use notifications to trigger continuous, real-time sampling of capacitance values from 3 sensors (already connected)
 
 class ViewController: UIViewController {
 
 override func viewDidLoad() {
 // This function is the first function called by the View Controller
 super.viewDidLoad()
 
 // Create the notifier
 let defaultCenter = NSNotificationCenter.defaultCenter()
 // Set the observers for each of the 3 sensors (just add lines and functions to add more sensors)
 defaultCenter.addObserver(self, selector: #selector(ViewController.newValueDetected0), name: "UpdateValueNotification0",object: nil)
 defaultCenter.addObserver(self, selector: #selector(ViewController.newValueDetected1), name: "UpdateValueNotification1",object: nil)
 defaultCenter.addObserver(self, selector: #selector(ViewController.newValueDetected2), name: "UpdateValueNotification2",object: nil)
 }
 
 func newValueDetected0() {
 // A notification has been detected from the sensor 0, the function newValueDetected0() is called
 if listPeripheralConnected.count > 0 {
 listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
 print("value sensor 0 updated, new value: (\listPeripheralsConnected[0].value) ")
 }
 }
 
 func newValueDetected1() {
 // A notification has been detected from the sensor 1, the function newValueDetected1() is called
 if listPeripheralConnected.count > 1 {
 listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
 print("value sensor 1 updated, new value: (\listPeripheralsConnected[1].value) ")
 }
 }
 
 func newValueDetected2() {
 // A notification has been detected from the sensor 2, the function newValueDetected2() is called
 if listPeripheralConnected.count > 2 {
 listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
 print("value sensor 2 updated, new value: (\listPeripheralsConnected[2].value) ")
 }
 }
 */
@objc class StretchSenseAPI: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: - VARIABLES
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    // ----------------------------------------------------------------------------
    // MARK: - Variables : Manager & List Peripherals
    // ----------------------------------------------------------------------------

    /// The manager of all the discovered peripherals
    fileprivate var centralManager : CBCentralManager!
    
    /** The list of all the **peripherals available** detected nearby the user device (during a bluetooth scan event)
     - note:  Before being connected, the peripheral object is typed CBPeripheral (identifier.UUIDString, CBPeripheralState.Connected, CBPeripheralState.Disconnected)
     */
    fileprivate var listPeripheralAvailable : [CBPeripheral?] = []
    
    /** The list of **peripherals currently connected** to the centralManager
     - note: Once a sensor is connected, it becomes an object instance of the class StretchSensePeripheral (UUID, Value, Color)
     */
    fileprivate var listPeripheralsConnected = [StretchSensePeripheral]()
    
    /** The **saved peripherals** that where once connected to the centralManager
     - note: Once a sensor is connected, it becomes an object instance of the class StretchSensePeripheral (UUID, Value, Color)
     */
    fileprivate var listPeripheralsOnceConnected : [StretchSensePeripheral] = [StretchSensePeripheral()]
    
    
    
    
    // ----------------------------------------------------------------------------
    // MARK:  Variables : Services & Characteristics UUID
    // ----------------------------------------------------------------------------

    /// The **name** used to filter bluetooth scan results and find only the StretchSense Sensor
    fileprivate var deviceName = "StretchSense"
    
    /// The UUID used to filter bluetooth scan results and find the **services** from the StretchSense Sensor gen 3
    fileprivate var serviceUUID3 = CBUUID(string: "00001701-7374-7265-7563-6873656e7365")
    /// The UUID used to filter device characterisitics and find the **data characteristic** from the StretchSense Sensor gen 3
    fileprivate var dataUUID3 = CBUUID(string: "00001702-7374-7265-7563-6873656e7365")
    /// The UUID used to filter device characterisitics and find the **shutdown characteristic**from the StretchSense Sensor gen 3
    fileprivate var shutdownUUID3 = CBUUID(string: "00001704-7374-7265-7563-6873656e7365")
    /// The UUID used to filter device characterisitics and find the **samplingTime characteristic** from the StretchSense Sensor gen 3
    fileprivate var samplingTimeUUID3 = CBUUID(string: "00001705-7374-7265-7563-6873656e7365")
    /// The UUID used to filter device characterisitics and find the **average characteristic** from the StretchSense Sensor gen 3
    fileprivate var averageUUID3 = CBUUID(string: "00001706-7374-7265-7563-6873656e7365")
    
    /// The UUID used to filter bluetooth scan results and find the **services** from the StretchSense Sensor gen 2
    fileprivate var serviceUUID2 = CBUUID(string: "00001501-7374-7265-7563-6873656e7365")
    /// The UUID used to filter device characterisitics and find the **data characteristic** from the StretchSense Sensor gen 2
    fileprivate var dataUUID2 = CBUUID(string: "00001502-7374-7265-7563-6873656e7365")
    /// The UUID used to filter device characterisitics and find the **shutdown characteristic**from the StretchSense Sensor gen 2
    fileprivate var shutdownUUID2 = CBUUID(string: "00001504-7374-7265-7563-6873656e7365")
    /// The UUID used to filter device characterisitics and find the **samplingTime characteristic** from the StretchSense Sensor gen 2
    fileprivate var samplingTimeUUID2 = CBUUID(string: "00001505-7374-7265-7563-6873656e7365")
    /// The UUID used to filter device characterisitics and find the **average characteristic** from the StretchSense Sensor gen 2
    fileprivate var averageUUID2 = CBUUID(string: "00001506-7374-7265-7563-6873656e7365")
    
    
    
    // ----------------------------------------------------------------------------
    // MARK:  Variables : Set sensor & Info
    // ----------------------------------------------------------------------------
    
    /// Number of **data samples** within the filtering array
    var numberOfSample = 30
    /// Initialisation value of the **sampling time value**
    /// notes: SamplingTime = (value + 1) * 40ms
    var samplingTimeNumber : UInt8 = 0
    /// Size of the filter based on the **Number of samples**
    var filteringNumber : UInt8 = 0
    /// **Feedback** from the sensor
    fileprivate var informationFeedBack = ""
    
    
    
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: -  FUNCTIONS
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    // ----------------------------------------------------------------------------
    // MARK: - Function: Scan/Connect/Disconnect
    // ----------------------------------------------------------------------------

    
    /**
     Initialisation of the **Manager**
     
     - note: Must be the first function called, to check if bluetooth is enabled and initialise the manager
     
     - parameter: Nothing
     
     - returns: Nothing
     
     */
    func startBluetooth(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    } /* end of startBluetooth() */
    
    
    
    /**
     **Start scanning** for new peripheral
     
     - parameter  Nothing:
     
     - returns: Nothing
     
     */
    func startScanning() {
        print("startScanning()")

        centralManager.scanForPeripherals(withServices: nil, options: nil)
    } /* end of startScanning() */
    
    
    
    /**
     **Stop the bluetooth** scanning
     
     - parameter Nothing
     
     - returns: Nothing
     
     */
    func stopScanning(){
        print("stopScanning()")

        self.centralManager.stopScan()
    } /* end of stopScanning() */
    
    
    
    
    /**
     Function to **connect** the manager to an available peripheral
     
     - note: If the string UUID given does not refer to an available peripheral, do nothing
     - note: Variation of the function connectToPeripheralWithCBPeripheral
     
     - parameter uuid : the string UUID of the available peripheral you want to connect.
     
     - returns: Nothing
     
     */
    func connectToPeripheralWithUUID(_ uuid : String){
        print("connectToPeripheralWithUUID()")

        let listOfPeripheralAvailable = self.getListPeripheralsAvailable()
        
        if listOfPeripheralAvailable.count != 0 {
            for myPeripheralAvailable in listOfPeripheralAvailable{
                if (uuid == myPeripheralAvailable!.identifier.uuidString){
                    if (myPeripheralAvailable!.state == CBPeripheralState.disconnected){
                        self.centralManager.connect(myPeripheralAvailable!, options: nil)
                    }
                }
            }
        }
    } /* end of connectToPeripheralWithUUID() */
    
    
    
    
    /**
     Function to **connect** the manager to an available peripheral
     
     - parameter myPeripheral : the peripheral available (type: CBPeripheral) you want to connect
     
     - returns: Nothing
     
     */
    func connectToPeripheralWithCBPeripheral(_ myPeripheral : CBPeripheral?){
        print("connectToPeripheralWithCBPeripheral()")

        self.centralManager.connect(myPeripheral!, options: nil)
        myPeripheral!.discoverServices(nil)
    } /* end of connectToPeripheralWithCBPeripheral() */
    
    
    
    
    /**
     Function to **disconnect** from a connected peripheral
     
     - note: If the UUID given does not refer to a connected peripheral, do nothing
     
     - parameter uuid : the string UUID of the peripheral you want to disconnect.
     
     - returns: Nothing
     
     */
    func disconnectOnePeripheralWithUUID(_ uuid : String){
        print("disconnectOnePeripheralWithUUID()")

        let listOfPeripheralAvailable = self.getListPeripheralsAvailable()
        
        if listOfPeripheralAvailable.count != 0 {
            for myPeripheral in listOfPeripheralAvailable{
                if (uuid == myPeripheral!.identifier.uuidString){
                    if (myPeripheral!.state == CBPeripheralState.connected){
                        self.centralManager.cancelPeripheralConnection(myPeripheral!)
                    }
                }
            }
        }
    } /* end of disconnectOnePeripheralWithUUID() */
    
    
    
    
    /**
     Function to **disconnect** from a connected peripheral
     
     - note: Variation of the function connectToPeripheralWithUUID
     
     - parameter myPeripheral : the peripheral connected (type CBPeripheral) you want to disconnect.
     
     - returns: Nothing
     
     */
    func disconnectOnePeripheralWithCBPeripheral(_ myPeripheral : CBPeripheral){
        print("disconnectOnePeripheralWithCBPeripheral()")

        centralManager.cancelPeripheralConnection(myPeripheral)
    } /* end of disconnectOnePeripheralWithCBPeripheral() */
    
    
    
    /**
     Function to **disconnect all** peripherals
     
     - parameter Nothing
     
     - returns: Nothing
     
     */
    func disconnectAllPeripheral(){
        //print("disconnectAllPeripheral()")

        for myPeripheral in listPeripheralAvailable {
            centralManager.cancelPeripheralConnection(myPeripheral!)
        }
    } /* end of disconnectAllPeripheral() */
    
    
    
    // ----------------------------------------------------------------------------
    // MARK: Function: Lists of peripherals
    // ----------------------------------------------------------------------------
    
    
    /**
     Get the list of all the **available peripherals** with their information (Identifier, UUID, name, state)
     
     - parameter Nothing
     
     - returns: The available peripherals
     
     */
    func getListPeripheralsAvailable() -> [CBPeripheral?]   {
        //print("getListPeripheralsAvailable()")

        return listPeripheralAvailable
    } /* end of getListPeripheralsAvailable() */
    
    
    
    
    /**
     Return the list of the **UUID's of the available peripherals**
     
     - parameter Nothing
     
     - returns: The UUID of all the peripheral available
     
     */
    func getListUUIDPeripheralsAvailable() -> [String] {
        //print("getListUUIDPeripheralsAvailable()")

        var uuid : [String] = []
        let numberOfPeripheralAvailable = listPeripheralAvailable.count
        if numberOfPeripheralAvailable != 0 {
            for i in 0...numberOfPeripheralAvailable-1 {
                uuid += [(listPeripheralAvailable[i]!.identifier.uuidString)]
            }
        }
        return uuid
    } /* end of getListUUIDPeripheralsAvailable() */
    
    
    
    
    /**
     Get the list of all the **connected peripherals** with their information (UUID, values, color )
     
     - parameter Nothing
     
     - returns: The peripherals connected
     
     */
    func getListPeripheralsConnected() -> [StretchSensePeripheral]{
        //print("getListPeripheralsConnected()")

        return listPeripheralsConnected
    } /* end of getListPeripheralsConnected() */
    
    
    
    
    /**
     Get the list of all the **peripherals that have been or currently are connected** with their information (UUID, values, color )
     
     - parameter Nothing
     
     - returns: The peripherals that have been or currently are connected to the manager
     */
    func getListPeripheralsOnceConnected() -> [StretchSensePeripheral]{
        //print("getListPeripheralsOnceConnected()")

        return listPeripheralsOnceConnected
    } /* end of getListPeripheralsOnceConnected() */
    
    
    
    // ----------------------------------------------------------------------------
    // MARK: Function: samplingTime / Shutdown
    // ----------------------------------------------------------------------------


    
    /**
     Return the **samplingTime's value** of the peripheral
     
     - note: SamplingTime is the interval between two data packets (SamplingTime = (value + 1) * 40ms)
     
     - parameter myPeripheral: The peripheral you want the samplingTime value
     
     - returns: The value of the samplingTime, -1 in the event of failure
     
     */
    func getSamplingTimeValue(_ myPeripheral : CBPeripheral!) -> Int{
        //print("getSamplingTimeValue()")

        if myPeripheral!.state == CBPeripheralState.connected{
            for service in myPeripheral!.services! {
                let thisService = service as CBService
                if thisService.uuid == serviceUUID3 {
                    for charateristic in service.characteristics! {
                        let thisCharacteristic = charateristic as CBCharacteristic
                        // check for sampling time characteristic
                        if thisCharacteristic.uuid == samplingTimeUUID3 {
                            if thisCharacteristic.value != nil{
                                // the value is stored as NSData in the Class, we convert it to Int
                                let valueNSData = thisCharacteristic.value!
                                let valueInt:Int! = Int!(Int(valueNSData.hexadecimalString()!, radix: 16)!)
                                return valueInt
                            }
                            else {return -1}
                        }
                    }
                }
                else { return -1 }
            }
            return -1
        }
        else { return -1 }
    } /* end of getSamplingTimeValue() */
    
    
    
    /**
     Return the **shutdown's value** of the peripheral
     
     - parameter myPeripheral: The peripheral you want the shutdown value
     
     - returns: The value of the shutdown
     
     */
    func getShutdownValue(_ myPeripheral : CBPeripheral!) -> Int{
        //print("getShutdownValue()")

        if myPeripheral!.state == CBPeripheralState.connected{
            for service in myPeripheral!.services! {
                let thisService = service as CBService
                if thisService.uuid == serviceUUID3 {
                    for charateristic in service.characteristics! {
                        let thisCharacteristic = charateristic as CBCharacteristic
                        // check for data characteristic
                        if thisCharacteristic.uuid == shutdownUUID3 {
                            if thisCharacteristic.value != nil{
                                // the value is stored as NSData in the Class, we convert it to Int
                                let valueNSData = thisCharacteristic.value!
                                let valueInt:Int! = Int!(Int(valueNSData.hexadecimalString()!, radix: 16)!)
                                return valueInt
                            }
                            else {return -1}
                        }
                    }
                }
                else { return -1 }
            }
            return -1
        }
        else { return -1 }
    } /* end of getShutdownValue() */
    
    
    
    
    
    /**
     Update the **samplingTime** of a selected peripheral device
     
     - note: SamplingTime = (value + 1) * 40ms
     
     - parameter myPeripheral: The peripheral you want to update
     - parameter dataIn: The sampling time (data rate) value you want to set for this peripheral
     
     - returns: Nothing
     
     */
    func writeSamplingTime(_ dataIn: UInt8, myPeripheral : CBPeripheral?) {
        print("writeSamplingTime()")

        // The UInt8 need to be convert in NSData before be send
        let dataNSData = NSData(bytes: [dataIn] as [UInt8], length: 1)
        if (myPeripheral!.state == CBPeripheralState.connected){
            for service in myPeripheral!.services! {
                let thisService = service as CBService
                if thisService.uuid == serviceUUID3 {
                    for charateristic in service.characteristics! {
                        let thisCharacteristic = charateristic as CBCharacteristic
                        if thisCharacteristic.uuid == samplingTimeUUID3 {
                            // Once we have the correct Characteristic, we can send the data
                            print(dataIn)
                            myPeripheral!.writeValue(dataNSData as Data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
                        }
                    }
                }
            }
        }
    } /* end of writeSamplingTime() */
    
    
    
    /**
     Change the **value of the shutdown** from the peripheral
     
     - note: unused functions
     
     - parameter myPeripheral: The peripheral you want to update
     - parameter dataIn: The shutdown value you want to set for this peripheral [0 - Stay on, 1 - Shutdown]
     
     - returns: Nothing
     
     */
    func writeShutdown(_ dataIn: UInt8, myPeripheral : CBPeripheral?) {
        print("writeShutdown()")

        // The UInt8 need to be convert in NSData before be send
        
        /*var dataUint8: UInt8 = dataIn
        let dataNSData = Data(bytes: UnsafePointer<UInt8>(&dataUint8), count: 1)
        for service in myPeripheral!.services! {
            let thisService = service as CBService
            if thisService.uuid == serviceUUID {
                for charateristic in service.characteristics! {
                    let thisCharacteristic = charateristic as CBCharacteristic
                    if thisCharacteristic.uuid == shutdownUUID {
                        // Once we have the good Characteristic and Characteristic, we can send the data
                        myPeripheral!.writeValue(dataNSData, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
                    }
                }
            }
        }*/
    } /* end of writeShutdown() */
    
    
    
    /**
     Change the **value of the average** from the peripheral
     
     - parameter myPeripheral: The peripheral you want to update
     - parameter dataIn: The shutdown value you want to set for this peripheral [0 - Stay on, 1 - Shutdown]
     
     - returns: Nothing
     
     */
    func writeAverage(_ dataIn: UInt8, myPeripheral : CBPeripheral?) {
        // The UInt8 need to be convert in NSData before be send

        let dataNSData = NSData(bytes: [dataIn] as [UInt8], length: 1)
        
        for service in myPeripheral!.services! {
            let thisService = service as CBService
            if thisService.uuid == serviceUUID3 {
                for charateristic in service.characteristics! {
                    let thisCharacteristic = charateristic as CBCharacteristic
                    if thisCharacteristic.uuid == averageUUID3 {
                        // Once we have the good Characteristic and Characteristic, we can send the data
                        myPeripheral!.writeValue(dataNSData as Data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
                    }
                }
            }
        }
    } /* end of writeAverage() */

    
    
    
    // ----------------------------------------------------------------------------
    // MARK:  Function: Optional
    // ----------------------------------------------------------------------------

    
    /**
     **Average** Provides an averaged (FIR moving point) value of the capacitance feedback from a single peripheral
     
     - note: The filter is a moving average FIR filter
     - note: Unused functions
     
     - Example:
     Assuming a filter size of 4 points
     and an input set of values: 	[0 0 0 0 0 1.00 1.00 1.00 1 1 1 1 0.00 0.00 0.00 0 0 0 0]
     The output values will be : 	[0 0 0 0 0 0.25 0.50 0.75 1 1 1 1 0.75 0.50 0.25 0 0 0 0]
     
     - parameter myPeripheral:  The peripheral value you want to receive data from
     - parameter averageNumber: The size of the moving point average filter (points)
     
     - returns: The averaged value
     
     */
    /*func averageFIR(_ averageNumber: Int, mySensor: StretchSensePeripheral)-> CGFloat{
        print("averageFIR()")

        if averageNumber == 0 || averageNumber == 1 {
            return mySensor.value
        }
        else {
            // we add the lastvalue (mySensor.value) and the 'averageNumber' values from the sensor
            var sumValue = mySensor.value
            for i in 0 ... averageNumber-2 {
                sumValue += mySensor.previousValueRawFromTheSensor[mySensor.previousValueRawFromTheSensor.count-1 - i]
            }
            // Then we divide by the number of values added to get the average
            return CGFloat(sumValue/CGFloat(averageNumber))
        }
    }*/
    
    
    
    
    /**
     **Average** Provides an averaged (IIR moving point) value of the capacitance feedback from a single peripheral
     
     - note: The filter is a moving average IIR filter (The result of a previous calculation will effect this value)
     - note: Unused functions

     - Example:
     Assuming a filter size of 4 points
     and an input set of values: 	[0 0 0 0 0 1.00f 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00]
     The output values will be : 	[0 0 0 0 0 0.25 0.31 0.39 0.48 0.54 0.60 0.66 0.70 0.74 0.77 0.80 0.83 0.85 0.87]
     
     - parameter myPeripheral:  The peripheral value you want to receive data from
     - parameter averageNumber: The size of the moving point average filter (points)
     
     - returns: The value averaged
     
     */
    /*func averageIIR(_ averageNumber: Int, mySensor: StretchSensePeripheral)-> CGFloat{
        print("averageIIR()")

        if averageNumber == 0 || averageNumber == 1 {
            return mySensor.value
        }
        else {
            // we add the lastvalue (mySensor.value) and the 'averageNumber' values from the sensor
            var sumValue = mySensor.value
            for i in 0 ... averageNumber-2 {
                sumValue += mySensor.previousValueAveraged[mySensor.previousValueAveraged.count-1 - i]
            }
            // Then we divide by the number of values added to get the average
            return CGFloat(sumValue/CGFloat(averageNumber))
        }
    }*/
    
    
    
    
    
    /**
     **Convert** the Raw data from the sensor characterisitic to a capacitance value, units pF (picoFarads)
     
     - note: Capacitance(pF) = RawData * 0.10pF
     
     - parameter rawData: The raw data from the peripheral
     
     - returns: The real capacitace value in pF
     
     */
    func convertRawDataToCapacitance(_ rawDataInt: Int) -> Float{
        //print("convertRawDataToCapacitance()")

        // Capacitance(pF) = RawData * 0.10pF
        return Float(rawDataInt)*1
    } /* end of convertRawDataToCapacitance() */
    
    
    
    
    /**
     Returns the number available peripheral devices that are not connected
     
     - parameter Nothing
     
     - returns: The number of peripherals available
     
     */
    func getNumberOfPeripheralAvailable() -> Int {
        //print("getNumberOfPeripheralAvailable()")

        return listPeripheralAvailable.count
    } /* end of getNumberOfPeripheralAvailable() */
    
    
    
    
    /**
     Returns the number of connected peripheral
     
     - parameter Nothing
     
     - returns: The number of connected peripherals
     
     */
    func getNumberOfPeripheralConnected() -> Int {
        //print("getNumberOfPeripheralConnected()")

        return listPeripheralsConnected.count
    } /* end of getNumberOfPeripheralConnected() */
    
    
    
    
    
    /**
     Return the last **information** (event update) received from the sensor
     
     - parameter Nothing
     
     - returns: The last information from the sensor
     
     */
    func getLastInformation() -> String{
        //print("getLastInformation()")

        return informationFeedBack
    } /* end of getLastInformation() */
    
    
    
    
    // ----------------------------------------------------------------------------
    // MARK: - Background Function: Central & Peripheral Manager
    // ----------------------------------------------------------------------------
    
    
    /**
     Function to Check the state of the Bluetooth Low Energy
     
     - note:
     
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState()")
        
        switch (central.state){
        case .poweredOff:
            // Bluetooth on this device is currently powered off
            informationFeedBack = "BLE is powered off"
        case .poweredOn:
            // Bluetooth LE is turned on and ready for communication
            informationFeedBack = "Bluetooth is powered on"
        case .resetting:
            // The BLE Manager is resetting; a state update is pending
            informationFeedBack = "BLE is resetting"
        case .unauthorized:
            // This app is not authorized to use Bluetooth Low Energy
            informationFeedBack = "BLE is unauthorized"
        case .unknown:
            // The state of the BLE Manager is unknown, wait for another event
            informationFeedBack = "BLE is unknown"
        case .unsupported:
            // This device does not support Bluetooth Low Energy.
            informationFeedBack = "BLE is not supported"
        }
        
        // Notify the viewController when the state has updated, this can be used to prompt events
        let defaultCenter = NotificationCenter.default
        defaultCenter.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil)
    } /* end of centralManagerDidUpdateState() */
    
    
    
    
    /**
     Function to Scan and filter all Bluetooth Low energy devices to find any available StretchSense peripherals
     
     - note:
     
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral?, advertisementData: [String : Any], rssi RSSI: NSNumber){
        print("didDiscoverPeripheral()")
        
        // Update information
        informationFeedBack = "Searching for peripherals"
        // Notify the viewController that the state has updated, this can be used to prompt events
        //let defaultCenter = NotificationCenter.default//SWIFT2
        //defaultCenter.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil) //SWIFT2
        
        //if (central.state == CBCentralManagerState.poweredOn){ //SWIFT2
        if (central.state == CBManagerState.poweredOn){ //SWIFT3
            var inTheList = false
            let peripheralCurrent = peripheral
            
            for periphOnceConnected in self.listPeripheralsOnceConnected {
                if periphOnceConnected.uuid == peripheral?.identifier.uuidString{
                    //If the peripheral discovered was once connected, we connect directly
                    connectToPeripheralWithUUID((peripheral?.identifier.uuidString)!)
                }
                    
                else {
                    
                    // If the peripheral discovered was never connected to the app we identify it
                    let nameOfPeripheralFound = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString
                    if (nameOfPeripheralFound == deviceName as NSString?) {
                        // If it's a stretchsense device

                        // Update information
                        informationFeedBack = "New Sensor Detected, Click to Connect/Disconnect"
                        // Notify the viewController that the info has been updated and so has to be reload
                        //let defaultCenter1 = NotificationCenter.default//SWIFT2
                        //defaultCenter1.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil)//SWIFT2
                        
                        if (self.listPeripheralAvailable.count == 0) {
                            // If the list is empty, we add the new peripheral detected directly
                            self.listPeripheralAvailable.append(peripheralCurrent)
                        }
                        else{
                            // Else we have to look if it's not yet in the list
                            for periphInList in self.listPeripheralAvailable{
                                if peripheral!.identifier == periphInList?.identifier{
                                    inTheList = true
                                }
                            }
                            if inTheList == false{
                                // If the new peripheral detected is not in the list, we add it to the list
                                self.listPeripheralAvailable.append(peripheralCurrent)
                            }
                        }
                    }
                }
            }
        }
    } /* end of didDiscover() */
    
    
    
    /**
     Function to Establish a connection with a peripheral and initialise a StretchSensePeriph object
     
     - note:
     
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnectPeripheral()")
        
        // Update information
        informationFeedBack = "Peripheral connected"
        // Notify the viewController that the info has been updated and so has to be reload
        let defaultCenter = NotificationCenter.default
        defaultCenter.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil)
        peripheral.delegate = self
        // Stop scanning for new devices
        stopScanning()
        peripheral.discoverServices(nil)
    } /* end of didConnect() */
    
    
    
    /**
     Function to When a device is disconnected, we remove it from the value list and the peripheralListAvailable
     
     - note:
     
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral()")

        // Check errors
        if (error != nil) {
            print("didDisconnectPeripheral() ERROR")

            print("Error :  \(error?.localizedDescription)");
            //print(error ?? <#default value#>)
        }
        
        for myPeripheralAvailable in listPeripheralAvailable{
            if (peripheral.identifier.uuidString == myPeripheralAvailable?.identifier.uuidString){
                var indexPositionToDelete = listPeripheralAvailable.index(where: { $0?.identifier.uuidString == (myPeripheralAvailable?.identifier.uuidString)!  }) // looking for the index of the peripheral to delete in the list
                print(Int(indexPositionToDelete!));
                listPeripheralAvailable.remove(at: Int(indexPositionToDelete!))  // remove the peripheral from the list
            }
        }
        
        
        
        
        for myPeripheralConnected in listPeripheralsConnected{
            if (peripheral.identifier.uuidString == myPeripheralConnected.uuid){
                var indexPositionToDelete = listPeripheralsConnected.index(where: { $0.uuid == myPeripheralConnected.uuid  }) // looking for the index of the peripheral to delete in the list
                print(Int(indexPositionToDelete!));
                listPeripheralsConnected.remove(at: Int(indexPositionToDelete!))  // remove the peripheral from the list
            }
        }
        
        // Update information
        informationFeedBack = "Peripheral Disconnected"
        // Notify the viewController that the info has been updated and so has to be reloaded
        let defaultCenter0 = NotificationCenter.default
        defaultCenter0.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil)
        
        startScanning()
    } /* end of didDisconnectPeripheral() */
    
    
    
    /**
     When the specified services are discovered, the peripheral calls the peripheral:didDiscoverServices: method of its delegate object
     
     - note:
     
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("didDiscoverServices()")

        // Check errors
        if (error != nil) {
            print("Error :  \(error?.localizedDescription)");
        }
        
        // Update information
        informationFeedBack = "Discovering peripheral services"
        // Notify the viewController that the info has been updated and so has to be reload
        /*let defaultCenter = NotificationCenter.default
        defaultCenter.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil)*/
        
        // Expore each service to find characteristics
        if peripheral.services?.count < 2{
            print("OLD FIRMWARE")
            
            // Update information
            informationFeedBack = "Old firmware"
            // Notify the viewController that the info has been updated and so has to be reload
            let defaultCenter = NotificationCenter.default
            defaultCenter.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil)
        }
        
        for service in peripheral.services! {
            print(service.uuid)
            let thisService = service as CBService
            print("for service")
            print(service.uuid)
            if service.uuid == serviceUUID3 {
                generateGen3(peripheral: peripheral)
                print("in for service gen 3")
                peripheral.discoverCharacteristics(nil, for: thisService) //call the didDiscoverCharacteristicForService()
            }
            if service.uuid == serviceUUID2 {
                generateGen2(peripheral: peripheral)
                print("in for service gen 2")
                peripheral.discoverCharacteristics(nil, for: thisService) //call the didDiscoverCharacteristicForService()
            }
        }
    } /* end of didDiscoverServices() */
    
    
    
    /**
    Function to generate a generation 2 sensor
     
     - note: In the API, one sensor is added to the listOfPeripheralConnected
     
     */
    func generateGen2(peripheral: CBPeripheral){
        print("generateGen2()")

        // We create a newSensor with the UUID and set his unique color with his number of appearance in the listPeripheralOnceConnected
        let newSensor = StretchSensePeripheral()
        newSensor.uuid = peripheral.identifier.uuidString
        newSensor.value = 0
        newSensor.uniqueNumber = listPeripheralsOnceConnected.count-1
        newSensor.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
        newSensor.gen = 2
        
        listPeripheralsConnected.append(newSensor)
        
        var wasThePeriphOnceConnected = false
        for peripheralOnceConnected in listPeripheralsOnceConnected{
            if peripheralOnceConnected.uuid == peripheral.identifier.uuidString {
                // If the peripheral was once connected, we copy the color and previous values
                wasThePeriphOnceConnected = true
                newSensor.uniqueNumber = peripheralOnceConnected.uniqueNumber
                newSensor.previousValueAveraged = peripheralOnceConnected.previousValueAveraged
                newSensor.previousValueRawFromTheSensor = peripheralOnceConnected.previousValueRawFromTheSensor
            }
        }
        // Check if the peripheral has previously been connected
        if wasThePeriphOnceConnected == false {
            listPeripheralsOnceConnected.append(newSensor)
        }
    } /* end of generateGen2() */
    
    
    
    /**
     Function to generate a generation 3 sensor
     
     - note: In the API, ten sensors are added to the listOfPeripheralConnected
     
     */
    func generateGen3(peripheral: CBPeripheral){
        // We create a newSensor with the UUID and set his unique color with his number of appearance in the listPeripheralOnceConnected
        
        let newSensor1 = StretchSensePeripheral()
        newSensor1.uuid = peripheral.identifier.uuidString
        newSensor1.value = 0
        newSensor1.uniqueNumber = 1
        newSensor1.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
        
        let newSensor2 = StretchSensePeripheral()
        newSensor2.uuid = peripheral.identifier.uuidString
        newSensor2.value = 0
        newSensor2.uniqueNumber = 2
        newSensor2.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
        
        let newSensor3 = StretchSensePeripheral()
        newSensor3.uuid = peripheral.identifier.uuidString
        newSensor3.value = 0
        newSensor3.uniqueNumber = 3
        newSensor3.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
        
        let newSensor4 = StretchSensePeripheral()
        newSensor4.uuid = peripheral.identifier.uuidString
        newSensor4.value = 0
        newSensor4.uniqueNumber = 4
        newSensor4.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
        
        let newSensor5 = StretchSensePeripheral()
        newSensor5.uuid = peripheral.identifier.uuidString
        newSensor5.value = 0
        newSensor5.uniqueNumber = 5
        newSensor5.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
        
        let newSensor6 = StretchSensePeripheral()
        newSensor6.uuid = peripheral.identifier.uuidString
        newSensor6.value = 0
        newSensor6.uniqueNumber = 6
        newSensor6.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
        
        let newSensor7 = StretchSensePeripheral()
        newSensor7.uuid = peripheral.identifier.uuidString
        newSensor7.value = 0
        newSensor7.uniqueNumber = 7
        newSensor7.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
        
        let newSensor8 = StretchSensePeripheral()
        newSensor8.uuid = peripheral.identifier.uuidString
        newSensor8.value = 0
        newSensor8.uniqueNumber = 8
        newSensor8.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
        
        let newSensor9 = StretchSensePeripheral()
        newSensor9.uuid = peripheral.identifier.uuidString
        newSensor9.value = 0
        newSensor9.uniqueNumber = 9
        newSensor9.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
        
        let newSensor10 = StretchSensePeripheral()
        newSensor10.uuid = peripheral.identifier.uuidString
        newSensor10.value = 0
        newSensor10.uniqueNumber = 10
        newSensor10.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
        
        listPeripheralsConnected.append(newSensor1)//1
        listPeripheralsConnected.append(newSensor2)//2
        listPeripheralsConnected.append(newSensor3)//3
        listPeripheralsConnected.append(newSensor4)//4
        listPeripheralsConnected.append(newSensor5)//5
        listPeripheralsConnected.append(newSensor6)//6
        listPeripheralsConnected.append(newSensor7)//7
        listPeripheralsConnected.append(newSensor8)//8
        listPeripheralsConnected.append(newSensor9)//9
        listPeripheralsConnected.append(newSensor10)//10
        
        var wasThePeriphOnceConnected = false
        for peripheralOnceConnected in listPeripheralsOnceConnected{
            if peripheralOnceConnected.uuid == peripheral.identifier.uuidString {
                // If the peripheral was once connected, we copy the color and previous values
                wasThePeriphOnceConnected = true
                newSensor1.uniqueNumber = peripheralOnceConnected.uniqueNumber
                newSensor1.previousValueAveraged = peripheralOnceConnected.previousValueAveraged
                newSensor1.previousValueRawFromTheSensor = peripheralOnceConnected.previousValueRawFromTheSensor
            }
        }
        // Check if the peripheral has previously been connected
        if wasThePeriphOnceConnected == false {
            listPeripheralsOnceConnected.append(newSensor1)
        }
    } /* end of generateGen3() */


    
    
    /**
      Once connected to a peripheral, enable notifications on the Sensor characteristic
     
     - note:
     
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("didDiscoverCharacteristicsForService()")

    
        // Check the UUID of each characteristic to find config and data characteristics
        for charateristic in service.characteristics! {
            print(charateristic.uuid.uuidString)
            print(" " )
            let thisCharacteristic = charateristic as CBCharacteristic
            
            if thisCharacteristic.uuid == dataUUID3 {
                peripheral.setNotifyValue(true, for: thisCharacteristic)
            }
            
            if thisCharacteristic.uuid == dataUUID2 {
                peripheral.setNotifyValue(true, for: thisCharacteristic)
            }
            
        }
    } /* end of didDiscoverCharacteristicsFor() */
    
    
    
    /**
     Get/read capacitance data from the peripheral device when a notificiation is received
     
     - note:
     
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //print("didUpdateValueForCharacteristic()")

        // Check errors
        if (error != nil) {
            print("Error Upload :  \(error?.localizedDescription)");
        }
        if listPeripheralsConnected.count != 0 {

            if characteristic.uuid == dataUUID3 {
                didUpdateValueGen3(peripheral, characteristic: characteristic)
            }
            if characteristic.uuid == dataUUID2 {
                didUpdateValueGen2(peripheral, characteristic: characteristic)
            }
            
            // Notify the viewController that the value has been updated and so has to be reloaded
            let defaultCenter = NotificationCenter.default
            // We send a notification with the number of the sensor
            defaultCenter.post(name: Notification.Name(rawValue: "UpdateValueNotification"), object: nil, userInfo: nil)
        }

    } /* end of didUpdateValueFor() */

    
    
    /**
     Update the value of all the channel of the generation 3
     
     - note:
     
     */
    func didUpdateValueGen3(_ peripheral: CBPeripheral, characteristic: CBCharacteristic){
    
        let ValueData = characteristic.value!
    
        innerLoop: for myPeripheral in listPeripheralsConnected{
            if myPeripheral.uuid == peripheral.identifier.uuidString{
            
                let indexOfperipheral = listPeripheralsConnected.index(where: {$0.uuid == myPeripheral.uuid})

                let valueRawSensor1 = ValueData.subdata(in: Range(0...1))//SWIFT3
                let valueRawSensor2 = ValueData.subdata(in: Range(2...3))//SWIFT3
                let valueRawSensor3 = ValueData.subdata(in: Range(4...5))//SWIFT3
                let valueRawSensor4 = ValueData.subdata(in: Range(6...7))//SWIFT3
                let valueRawSensor5 = ValueData.subdata(in: Range(8...9))//SWIFT3
                let valueRawSensor6 = ValueData.subdata(in: Range(10...11))//SWIFT3
                let valueRawSensor7 = ValueData.subdata(in: Range(12...13))//SWIFT3
                let valueRawSensor8 = ValueData.subdata(in: Range(14...15))//SWIFT3
                let valueRawSensor9 = ValueData.subdata(in: Range(16...17))//SWIFT3
                let valueRawSensor10 = ValueData.subdata(in: Range(18...19))//SWIFT3
    
                let valueIntSense1:Int! = Int(valueRawSensor1.hexadecimalString()!, radix: 16)!
                let valueIntSense2:Int! = Int(valueRawSensor2.hexadecimalString()!, radix: 16)!
                let valueIntSense3:Int! = Int(valueRawSensor3.hexadecimalString()!, radix: 16)!
                let valueIntSense4:Int! = Int(valueRawSensor4.hexadecimalString()!, radix: 16)!
                let valueIntSense5:Int! = Int(valueRawSensor5.hexadecimalString()!, radix: 16)!
                let valueIntSense6:Int! = Int(valueRawSensor6.hexadecimalString()!, radix: 16)!
                let valueIntSense7:Int! = Int(valueRawSensor7.hexadecimalString()!, radix: 16)!
                let valueIntSense8:Int! = Int(valueRawSensor8.hexadecimalString()!, radix: 16)!
                let valueIntSense9:Int! = Int(valueRawSensor9.hexadecimalString()!, radix: 16)!
                let valueIntSense10:Int! = Int(valueRawSensor10.hexadecimalString()!, radix: 16)!
    
                let valueCapaSense1 = CGFloat(convertRawDataToCapacitance(valueIntSense1))
                let valueCapaSense2 = CGFloat(convertRawDataToCapacitance(valueIntSense2))
                let valueCapaSense3 = CGFloat(convertRawDataToCapacitance(valueIntSense3))
                let valueCapaSense4 = CGFloat(convertRawDataToCapacitance(valueIntSense4))
                let valueCapaSense5 = CGFloat(convertRawDataToCapacitance(valueIntSense5))
                let valueCapaSense6 = CGFloat(convertRawDataToCapacitance(valueIntSense6))
                let valueCapaSense7 = CGFloat(convertRawDataToCapacitance(valueIntSense7))
                let valueCapaSense8 = CGFloat(convertRawDataToCapacitance(valueIntSense8))
                let valueCapaSense9 = CGFloat(convertRawDataToCapacitance(valueIntSense9))
                let valueCapaSense10 = CGFloat(convertRawDataToCapacitance(valueIntSense10))
    
                if listPeripheralsConnected.count >= 10 {
                    listPeripheralsConnected[indexOfperipheral!+0].value = valueCapaSense1
                    listPeripheralsConnected[indexOfperipheral!+1].value = valueCapaSense2
                    listPeripheralsConnected[indexOfperipheral!+2].value = valueCapaSense3
                    listPeripheralsConnected[indexOfperipheral!+3].value = valueCapaSense4
                    listPeripheralsConnected[indexOfperipheral!+4].value = valueCapaSense5
                    listPeripheralsConnected[indexOfperipheral!+5].value = valueCapaSense6
                    listPeripheralsConnected[indexOfperipheral!+6].value = valueCapaSense7
                    listPeripheralsConnected[indexOfperipheral!+7].value = valueCapaSense8
                    listPeripheralsConnected[indexOfperipheral!+8].value = valueCapaSense9
                    listPeripheralsConnected[indexOfperipheral!+9].value = valueCapaSense10
                }
    
                for i in 0...9 {
                    var peripheralToShift = listPeripheralsConnected[indexOfperipheral!+i]

                    for j in 0 ... listPeripheralsConnected[indexOfperipheral!+0].previousValueAveraged.count-2{
                        peripheralToShift.previousValueAveraged[j] = peripheralToShift.previousValueAveraged[j+1]
                        peripheralToShift.previousValueRawFromTheSensor[j] = peripheralToShift.previousValueRawFromTheSensor[j+1]
                    }
                    peripheralToShift = listPeripheralsConnected[indexOfperipheral!+i]

                peripheralToShift.previousValueRawFromTheSensor[peripheralToShift.previousValueRawFromTheSensor.count-1] = peripheralToShift.value
                        peripheralToShift.previousValueAveraged[peripheralToShift.previousValueAveraged.count-1] = peripheralToShift.value
                }
            
            break innerLoop
            }
        }

    } /* end of didUpdateValueGen3() */

    
    
    
    /**
     Update the value of the generation 2 sensor
     
     - note:
     
     */
    func didUpdateValueGen2(_ peripheral: CBPeripheral, characteristic: CBCharacteristic){
        //print("did Gen2")
        innerLoop: for myPeripheral in listPeripheralsConnected{
            if myPeripheral.uuid == peripheral.identifier.uuidString{
            
                let ValueData = characteristic.value!
                // Convert NSData to array of signed 16 bit values
                let valueInt:Int! = Int!(Int(ValueData.hexadecimalString()!, radix: 16)!)
                myPeripheral.value = CGFloat(valueInt)
                // Shifting of the previous value
                for j in 0 ... myPeripheral.previousValueAveraged.count-2{
                    myPeripheral.previousValueAveraged[j] = myPeripheral.previousValueAveraged[j+1]
                    myPeripheral.previousValueRawFromTheSensor[j] = myPeripheral.previousValueRawFromTheSensor[j+1]
                }
            
                myPeripheral.previousValueRawFromTheSensor[myPeripheral.previousValueRawFromTheSensor.count-1] = myPeripheral.value
                myPeripheral.previousValueAveraged[myPeripheral.previousValueAveraged.count-1] = myPeripheral.value
            

                break innerLoop
            }
        }

    } /* end of didUpdateValueGen2() */
    
    
    
    
}/* end of the API */





// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// MARK: - EXTENSION
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

extension Data {
    
    /**
     Convert the hexadecimal value into a String
     
     - parameter Nothing
     
     - returns: The value converted
     
     */
    func hexadecimalString() -> String? {
        /* Used to convert NSData to String */
        //print("hexadecimalString()")
        if let buffer = Optional((self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count)) {
            var hexadecimalString = String()
            for i in 0..<self.count {
                hexadecimalString += String(format: "%02x", buffer.advanced(by: i).pointee)
            }
            return hexadecimalString
        }
        return nil
    }
    
    
    
}




