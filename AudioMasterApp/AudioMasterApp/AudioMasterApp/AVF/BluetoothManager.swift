//
//  BluetoothManager.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/05/08.
//

import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager!
    private var peripheralToConnect: CBPeripheral?
    var onDeviceDiscovered: ((CBPeripheral) -> Void)?


    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // Bluetoothの状態が更新された時に呼ばれるメソッド
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Bluetoothが有効ならスキャンを開始
            scanForDevices()
        } else {
            print("Bluetooth is not available.")
        }
    }

    // デバイスをスキャンするメソッド
    func scanForDevices() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    // デバイスを発見した時に呼ばれるメソッド
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "unknown device") at \(RSSI)")
        onDeviceDiscovered?(peripheral)

        // 特定のデバイスに接続する条件
        if let name = peripheral.name, name.contains("WH-1000XM5") {
            centralManager.stopScan()
            peripheralToConnect = peripheral
            centralManager.connect(peripheral, options: nil)
        }
    }

    // デバイスに接続できた時に呼ばれるメソッド
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "unknown device")")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    // 接続に失敗した時に呼ばれるメソッド
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect: \(error?.localizedDescription ?? "unknown error")")
    }

    // サービスを発見した時に呼ばれるメソッド
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered service \(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
}

