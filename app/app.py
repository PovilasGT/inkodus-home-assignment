from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/hello')
def hello():
    message = {'message': 'Hello, world!'}
    return jsonify(message)

if __name__ == '__main__':
    app.run()

#dummy comment to trigger the build
