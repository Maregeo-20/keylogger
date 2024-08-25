# server.py
from flask import Flask, request, jsonify
import os

app = Flask(__name__)

# Directory per salvare i file caricati
UPLOAD_FOLDER = 'uploaded_logs'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    file_path = os.path.join(UPLOAD_FOLDER, 'log.txt')
    file.save(file_path)
    return jsonify({'message': 'File successfully uploaded'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
