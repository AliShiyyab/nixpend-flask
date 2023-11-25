import './App.css';
import {useState} from "react";
import {SubmitForm} from "./service/submit-form";
import {Modal} from "./components/modal";

const dataInitialState = {
	fullName: "",
	email: "",
	phoneNumber: ""
}

const resultInitialState = {
	fullName: "",
	email: "",
	phoneNumber: "",
	qrCode: "",
}

function App() {
	const [data, setData] = useState(dataInitialState);
	const [result, setResult] = useState(resultInitialState);
	const [displayModal, setDisplayModal] = useState(false);

	const handleChange = (e) => {
		setData({
			...data,
			[e.target.name]: e.target.value
		});
	}

	const onSubmit = () => {
		if (Object.values(data).some(value => value === "")) {
			alert("Please fill all data to extract the QRCode.")
		} else
			SubmitForm(data, setResult, setDisplayModal);
	}

	const closeModal = () => {
		setDisplayModal(false);
	}

	return (
		<div className="App">
			<div className="form-for-submit">
				<h2 className={'title-for-form'}>Please fill your data to extract your QRCode</h2>
				<div style={{display: "flex", flexDirection: "row", justifyContent: "space-between"}}>
					<div className={"input-data-row label-size"}>
						<label htmlFor="fullName" style={{width: "100px"}}>Full Name:</label>
						<label htmlFor="email">Email:</label>
						<label htmlFor="phoneNumber">Phone Number:</label>

					</div>
					<div className={"input-data-row input-size"}>
						<input
							type="text"
							id="fullName"
							name="fullName"
							value={data.fullName}
							onChange={handleChange}
							style={{padding: "5px"}}
						/>
						<input
							type="email"
							id="email"
							name="email"
							value={data.email}
							onChange={handleChange}
							style={{padding: "5px"}}
						/>
						<input
							type="tel"
							id="phoneNumber"
							name="phoneNumber"
							value={data.phoneNumber}
							onChange={handleChange}
							style={{padding: "5px"}}
						/>
					</div>
				</div>
				<div className={"submit-button"}>
					<button onClick={onSubmit} style={{padding: "10px", width: "150px", fontSize: "16px"}}>Submit
					</button>
				</div>
			</div>

			{displayModal && (<Modal result={result} onClose={closeModal}/>)}
		</div>
	);
}

export default App;
