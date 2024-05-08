//
//  BluetoothManager.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/05/08.
//

import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager!
    var onDeviceDiscovered: ((CBPeripheral) -> Void)?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func scanForDevices() {
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not available.")
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("Bluetooth is not powered on.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.identifier)
        onDeviceDiscovered?(peripheral)
    }
}


