from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def hello():
    message = {'message': 'Hello, world from new revision!'}
    return jsonify(message)

if __name__ == '__main__':
    app.run()
