import axios from "axios";

export const SubmitForm = (data, setResult, setDisplayModal) => {
	const apiUrl = 'http://localhost:5500/submit';
	axios.post(apiUrl, data, {
		headers: {
			'Content-Type': 'application/json',
		}
	}).then((res) => {
		setResult(res.data)
		setDisplayModal(true)
	});
}
