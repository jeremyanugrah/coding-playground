from http.server import HTTPServer, SimpleHTTPRequestHandler

PORT = 8000
server = HTTPServer(('', PORT), SimpleHTTPRequestHandler)
print(f"Server running on port {PORT}...")
server.serve_forever()
