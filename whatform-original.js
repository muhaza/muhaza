///
//script start//
//1. get form value



function alamak() {
    alert("Minta tekan OK! Dulu")
}

var wasapLink = document.getElementById("wasapLink").href;
// alert(wasapLink)

function one(callback) {
    setTimeout(function() {
        var getPhone = document.getElementById("getPhone").value;
        localStorage.phoneUser = getPhone;
        var getUser = document.getElementById("getNama").value;
        localStorage.namaUser = getUser;
        var getAlamat = document.getElementById("getAlamat").value;
        localStorage.alamatUser = getAlamat;
        var buttonSaveBiru = document.getElementById("buttonSave").style.color = "grey";
        localStorage.buttonSaveBiru = buttonSaveBiru;
        if (localStorage.namaUser == "" || localStorage.phoneUser == "" || localStorage.alamatUser == "") {
            alert("Alamak Tuan/Puan awak lupa nak masukkan detail contact awak la. Nanti kami tak dapat nak proses penghantaran?");
            return false;
        }
        // location.reload();
        callback();
    }, 200);
}

function two() {
    location.reload();
    location.href = "#send";
    // alert(getPhone + getUser + getAlamat + " success");    
}

function sendButton() {
    if (localStorage.namaUser == "" || localStorage.phoneUser == "" || localStorage.alamatUser == "" || localStorage.namaUser == "undefined" || localStorage.phoneUser === 'undefined' || localStorage.alamatUser == "undefined") {
        alert("Alamak Tuan/Puan Kosong/Undefined tu. Isi dulu ye form")
        return false;
    }
    delete localStorage.buttonSaveBiru;
    location.href = wasapLink;
}


//2.remove data
function phoneRemove() {
    alert("reset simpanan data whatsapp berjaya");
    localStorage.showSend = "none";
    localStorage.hideSend = "block";
    localStorage.phoneNo = "";
    localStorage.phoneUser = "";
    localStorage.namaUser = "";
    localStorage.alamatUser = "";
    delete localStorage.buttonSaveBiru;
    location.reload();
}
//3 window.onload = alert(localStorage.qweStorage);
document.getElementById("iTitle").innerHTML = iTitle;
document.getElementById("iSub").innerHTML = iSub;
document.getElementById("iCta").innerHTML = iCta;
document.getElementById("iNote").innerHTML = iNote;
document.getElementById("iDesc").innerHTML = iDesc;
document.getElementById("tamat").innerHTML = tamat;
document.getElementById("isponsor").innerHTML = userID;
var getHarga = document.getElementsByClassName("harga");
for (var i = 0; i < getHarga.length; i++) {
    getHarga[i].innerHTML = iHarga;
};