import logging
import websockets
import json
import socket
import asyncio
import threading

from lib.serial_reader import SerialReader
from lib.ws_server.handler import ServerHandler

# with open("config.json") as f:
#     config = json.load(f)


class Server:
    def __init__(self, url: str, port: int, serial_port: SerialReader) -> None:
        self.url = url
        self.port = port
        self.handler = ServerHandler(serial_port)

    async def handle_connections(self, websocket: websockets.WebSocketServerProtocol, _):
        logging.info("--- New Connection ---")
        logging.info(f"Remote: {websocket.remote_address}")
        logging.info(f"Local: {websocket.local_address}")
        websocket.transport._sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, True)
        self.handler.subscribe(websocket)
        while True:
            try:
                await websocket.recv()
            except websockets.exceptions.ConnectionClosed:
                self.handler.unsubscribe(websocket)
                break

    async def start(self):
        threading.Thread(target=self.handler.start, daemon=True).start()
        async with websockets.serve(self.handle_connections, self.url, self.port):
            logging.info(f"Serving to {self.url}:{self.port}")
            await asyncio.Future()
