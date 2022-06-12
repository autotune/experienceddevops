#!/usr/bin/python
from flask import Flask
from flask import request
from pprint import pprint
from rocketchat_API.rocketchat import RocketChat
from prometheus_flask_exporter import PrometheusMetrics
import prometheus_client
from prometheus_client import Counter
from prometheus_client.core import CollectorRegistry
from flask import Response, Flask

# These should really be used as encrypted environment variables in production

rocket = RocketChat('badams', 'SuperSecurePassword', server_url='http://chat.badams.ninja:33000')

app = Flask(__name__)

requests_total = Counter("request_count", "Total request cout of the host")

@app.route('/', methods = ['POST','GET'])
def JsonHandler():
    if request.is_json:
        content = request.get_json()
        print("Just got {0} event!".format(content['checkout_sha']))
        print(content)
        pprint(rocket.chat_post_message(content['checkout_sha'], channel='#general').json())
        requests_total.inc()
        return 'OK'
    else:
        return 'OK'

@app.route('/metrics', methods = ['GET'])
def Metrics():
    return Response(prometheus_client.generate_latest(requests_total),
                    mimetype="text/plain")

# nginx would be used as an alternative in prod
app.run(host='0.0.0.0', port=80)
