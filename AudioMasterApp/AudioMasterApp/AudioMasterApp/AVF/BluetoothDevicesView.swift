//
//  BluetoothDevicesView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/05/08.
//

import SwiftUI
import CoreBluetooth

struct BluetoothDevicesView: View {
    @State private var devices: [CBPeripheral] = []
    private var bluetoothManager = BluetoothManager()

    var body: some View {
        NavigationView {
            List(devices, id: \.identifier) { device in
                Text(device.name ?? "Unknown Device")
            }
            .navigationBarTitle("Bluetooth Devices")
            .onAppear {
                bluetoothManager.onDeviceDiscovered = { device in
                    if !self.devices.contains(where: { $0.identifier == device.identifier }) {
                        self.devices.append(device)
                    }
                }
                bluetoothManager.scanForDevices()
            }
        }
    }
}

struct BluetoothDevicesView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothDevicesView()
    }
}

