from flask import Flask

# Create a Flask app instance
app = Flask(__name__)

# Define a route for the root URL
@app.route('/')
def hello_world():
    return 'Hello, World! This Flask app is running on port 9877.'

if __name__ == '__main__':
    # Run the Flask app on port 9877
    app.run(host='0.0.0.0', port=9877)
