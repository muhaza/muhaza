///
//script start//
//1. get form value



function alamak() {
    alert("Minta tekan OK! Dulu")
}

var wasapLink = document.getElementById("wasapLink").href;
// alert(wasapLink)


function sendButton() {
    location.href = wasapLink;
}


//3 window.onload = alert(localStorage.qweStorage);
document.getElementById("iTitle").innerHTML = iTitle;
// document.getElementById("iSub").innerHTML = iSub;
document.getElementById("iCta").innerHTML = iCta;
document.getElementById("iNote").innerHTML = iNote;
document.getElementById("iDesc").innerHTML = iDesc;
document.getElementById("tamat").innerHTML = tamat;
document.getElementById("isponsor").innerHTML = userID;
var getHarga = document.getElementsByClassName("harga");
for (var i = 0; i < getHarga.length; i++) {
    getHarga[i].innerHTML = iHarga;
};