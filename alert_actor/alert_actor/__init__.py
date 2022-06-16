import sys
import subprocess

from flask import Flask, request

app = Flask(__name__)
service_file_path = "k8s/services.yml"  # Default path


@app.route('/webhook', methods=['POST'])
def webhook():
    if request.method == 'POST':
        print("Data received from Webhook is: ", request.json)
        if request.json["status"] == "firing":
            with open(service_file_path) as f:
                lines = f.read()
                if "color: blue" in lines:
                    subprocess.call(['bash',
                                     './switch-traffic.sh',
                                     'green'])
                elif "color: green" in lines:
                    subprocess.call(['bash',
                                     './switch-traffic.sh',
                                     'blue'])
    return "Webhook received!"


def main():
    global service_file_path
    try:
        service_file_path = sys.argv[1]  # Override default path
    except IndexError:
        pass
    app.run(host='0.0.0.0', port=8081)
