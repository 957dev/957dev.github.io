from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from functools import partial
from pathlib import Path
import argparse
parser = argparse.ArgumentParser()
parser.add_argument('--port', type=int, default=8000)
args = parser.parse_args()
class Handler(SimpleHTTPRequestHandler):
    extensions_map = {**SimpleHTTPRequestHandler.extensions_map, '.js': 'text/javascript', '.css': 'text/css', '.json': 'application/json'}
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()
root = Path(__file__).resolve().parent.parent / 'dist'
server = ThreadingHTTPServer(('127.0.0.1', args.port), partial(Handler, directory=str(root)))
print(f'Preview: http://127.0.0.1:{args.port}', flush=True)
try:
    server.serve_forever()
except KeyboardInterrupt:
    pass
finally:
    server.server_close()
