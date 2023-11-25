from io import BytesIO
import base64

from flask import Flask, request, jsonify
import requests
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


@app.route('/submit', methods=['POST'])
def submit():
    full_name = request.json.get('fullName')
    email = request.json.get('email')
    phone_number = request.json.get('phoneNumber')

    # Generate QR Code using an external API ( I git this API FROM CHATGPT )
    qr_data = f"Name: {full_name}\nEmail: {email}\nPhone: {phone_number}"
    qr_url = f"https://api.qrserver.com/v1/create-qr-code/?data={qr_data}&size=200x200"
    qr_response = requests.get(qr_url)
    qr_img = BytesIO(qr_response.content)

    qr_base64 = base64.b64encode(qr_img.getvalue()).decode('utf-8')

    # I know if a add a dto make the code better than this way, but it's a small application
    response_data = {
        "fullName": full_name,
        "email": email,
        "phoneNumber": phone_number,
        "qrCode": "data:image/png;base64," + qr_base64
    }

    return jsonify(response_data)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5500, debug=True)
