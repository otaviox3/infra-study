from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello from DevOps lab – Otávio Azevedo!"

@app.route("/health")
def health():
    return "OK"

if __name__ == "__main__":
    # host=0.0.0.0 permite que o container receba conexão externa
    app.run(host="0.0.0.0", port=5000)
