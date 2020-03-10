//
//  Exchange.swift
//  ArduinoClockIn
//
//  Created by Maria Eduarda Casanova Nascimento on 06/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation
import CoreBluetooth

let human_interface_deviceCBUUID = CBUUID(string: "0x1812")

/// This class abstracts communication with the Arduino Bluetooth Module.
/// It has methods for reading and writing data to Arduino.
class ExchangePresenter: NSObject {
    /// Set this to handle callbacks
    var delegate: ExchangeDelegate?
    
    // MARK: - Private Properties
    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var characterist: CBCharacteristic?
    
    private let expectedPeripheralName = "MARIA"
    private let expectedCharacteristicUUIDString = "DFB1"
    private(set) var isReady: Bool = false
    
    
    init(delegate: ExchangeDelegate? = nil) {
        super.init()
        self.delegate = delegate
        
        // Begin looking for elements
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /// Sends the bytes provided to Arduino using Bluetooth
    func send<T: DataConvertible>(value: T) {
        if( self.isReady ) {
            guard let characterist = self.characterist else { return }
            self.peripheral?.writeValue(value.data, for: characterist, type: .withResponse)
        }
    }
    /// Read data from Arduino Module, if possible
    func read() {
        if( self.isReady ) {
            guard let characterist = self.characterist else { return }
            self.peripheral?.readValue(for: characterist)
            
        }
    }
}

extension ExchangePresenter: CBCentralManagerDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("WARNING - Bluetooth is Disabled. Switch it on and try again")
        case .poweredOn:
            print("Began Scanning...")
            guard let centralManager = centralManager else { return }
            centralManager.scanForPeripherals(withServices: [human_interface_deviceCBUUID])
        @unknown default:
            print("WARNING: - state not supported \(String.init(describing: central.state))")
        }
    }
    
    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if( peripheral.name == self.expectedPeripheralName ) {
            print("Discovered \(self.expectedPeripheralName)")
            self.peripheral = peripheral
            
            print("Attemping Connection...")
            // Attemp connection
            central.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        // Allow delegate to update status
        self.delegate?.communicatorDidConnect(self)
        
        // Once connection is stabilished, we can begin discovering services
        peripheral.delegate = self
        
        print("Discovering Services...")
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.peripheral {
            print("Disconnected")
            self.peripheral = nil
            
            // Start scanning again
            print("Central scanning again ...");
            guard let centralManager = centralManager else { return }
            centralManager.scanForPeripherals(withServices: [human_interface_deviceCBUUID])
        }
    }

}

extension ExchangePresenter : CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if( characteristic.uuid.uuidString == self.expectedCharacteristicUUIDString ) {
                print("Discovered Characteristic \(characteristic), for Service \(service)")
                self.characterist = characteristic
                self.isReady = true
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let characteristOfInterest = self.characterist, let data = characteristOfInterest.value  else { return }
        if( characteristic.uuid.uuidString == characteristOfInterest.uuid.uuidString ) {
            // Allows the delegate to handle data exchange (read)
            self.delegate?.communicator(self, didRead: data)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let characteristOfInterest = self.characterist, let data = characteristOfInterest.value else { return }
        if( characteristic.uuid.uuidString == characteristOfInterest.uuid.uuidString ) {
            
            // Allows the delegate to handle data exchange (write)
            self.delegate?.communicator(self, didWrite: data)
        }
        
    }
    
}
