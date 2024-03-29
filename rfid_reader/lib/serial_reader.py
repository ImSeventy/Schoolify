from typing import Optional
import serial

class SerialReader:
    def __init__(self, port: str, baudrate: int, timeout: Optional[int] = None):
        self.port = serial.Serial(port=port, baudrate=baudrate, timeout=timeout)

    def read_serial_data(self) -> int:
        data = self.port.readline()
        data =  str(data, encoding="utf-8")
        rfid_read = data.removesuffix("\n")
        return int(rfid_read)

    def values_generator(self):
        while True:
            value = self.read_serial_data()
            yield value