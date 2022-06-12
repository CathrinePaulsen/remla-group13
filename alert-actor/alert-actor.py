from flask import Flask, request
import subprocess

app = Flask(__name__)


@app.route('/webhook', methods=['POST'])
def webhook():
    if request.method == 'POST':
        print("Data received from Webhook is: ", request.json)
        if request.json["status"] == "firing":
            with open('k8s/services.yml') as f:
                lines = f.read()
                if "color: blue" in lines:
                    subprocess.call(['bash',
                                     './switch-traffic.sh',
                                     'green'])
    return "Webhook received!"


app.run(host='0.0.0.0', port=8081)
