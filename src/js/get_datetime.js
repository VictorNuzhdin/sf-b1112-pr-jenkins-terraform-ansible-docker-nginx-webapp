/**
 =Get the Date and Time of the web client given the Time Zone
 
*/

// find DOM element by id "clientTime" (current Date and Time of client)
const timeElem = document.getElementById("clientTime");

var dt_now = new Date().toLocaleString('ru-RU', { timeZone: 'Asia/Almaty'});

timeElem.textContent = dt_now;
