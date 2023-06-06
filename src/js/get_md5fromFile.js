/**
 =How to generate an MD5 file hash in JavaScript
  https://stackoverflow.com/questions/768268/how-to-calculate-md5-hash-of-a-file-using-javascript
  https://stackoverflow.com/questions/14733374/how-to-generate-an-md5-file-hash-in-javascript-node-js
  https://stackoverflow.com/questions/3582671/how-to-open-a-local-disk-file-with-javascript

*/

// find DOM element by id "md5summ" (calculated md5 hash element)
const md5elem = document.getElementById("md5summ");

// find DOM element by id "holder" (placeholder for drop files)
var holder = document.getElementById('holder');

console.log("Last calculated md5 file hashes:");

// File placeholder logic
holder.ondragover = function() {
  return false;
};

holder.ondragend = function() {
  return false;
};

holder.ondrop = function(event) {
  event.preventDefault();

  var file = event.dataTransfer.files[0];
  var reader = new FileReader();

  reader.onload = function(event) {
	var binary = event.target.result;
	var file_md5 = CryptoJS.MD5(binary).toString();
	
	// Write result md5 hash to Console
	console.log(file_md5);

	// Write result md5 hash to Element
	//md5elem.textContent = file_md5;
	md5elem.innerHTML = file_md5;
  };

  reader.readAsBinaryString(file);
};