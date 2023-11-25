import "./style.css"

export function Modal({result, onClose}) {

	return (
		<div className="modal">
			<div className="modal-content">
				<h2>QR Result</h2>
				<p>Full Name: {result.fullName}</p>
				<p>Email: {result.email}</p>
				<p>Phone Number: {result.phoneNumber}</p>
				<p>Congrats, Your QR Code is available.</p>
				<p>You can click on it to download it.</p>
				<p><a href={result.qrCode} download="qr_code_image.png">
					<img src={result.qrCode}
					     alt={"Image Not Found"}/>
				</a></p>
				<button onClick={onClose}>Close</button>
			</div>
		</div>
	);
}