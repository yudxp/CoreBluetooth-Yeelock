# Yeelock

Credit : https://github.com/aso824/yeehack
Port it from python to swift

There is 2 feature that working : 
- Request BLE_Sign throughout URLSession, you can put your phone number, password and Country zone number
- After get the device name and BLE sign, you can scan and command the lock 

Not implement yet :
- Need to sync time when device request it 0x09 code before send command (lock/unlock) ? if not used long time
- Register ID and Device
