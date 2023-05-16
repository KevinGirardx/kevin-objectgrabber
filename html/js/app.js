let uiElm = document.getElementById('ui-el')
let nameElm = document.getElementById('name-el')
let hashElm = document.getElementById('hash-el')
let netIdElm = document.getElementById('netid-el')
let headingElm = document.getElementById('heading-el')
let coords3Elm = document.getElementById('coords3-el')
let coords4Elm = document.getElementById('coords4-el')
let saveElm = document.getElementById('save-btn')
let alertElm = document.getElementById('alert-el')

let alertTxt = 'Object data have been saved to resources root folder'
let saveTxt = 'object saved'


function copyToClipboard(text) {
    let textElm = document.createElement('textarea');
    textElm.value = text;
    document.body.appendChild(textElm);
    textElm.select();
    document.execCommand('copy');
    document.body.removeChild(textElm);
    fetch(`https://${GetParentResourceName()}/copy`);
}

function copyData(id) {
    if (id === 'name-el') {
        copyToClipboard(nameElm.textContent);
    } else if (id === 'hash-el') {
        copyToClipboard(hashElm.textContent);
    } else if (id === 'netid-el') {
        copyToClipboard(netIdElm.textContent);
    } else if (id === 'heading-el') {
        copyToClipboard(headingElm.textContent);
    } else if (id === 'coords3-el') {
        copyToClipboard(coords3Elm.textContent);
    } else if (id === 'coords4-el') {
        copyToClipboard(coords4Elm.textContent);
    }
}

function saveData() {
    saveElm.textContent = saveTxt
    alertElm.textContent = alertTxt
    fetch(`https://${GetParentResourceName()}/saveobject`);
}

window.addEventListener('message', (event) => {
    let data = event.data
    if (event.data.type === 'show') {
        uiElm.style.display = 'block'
        nameElm.textContent = ' ' + data.name
        hashElm.textContent = data.hash
        netIdElm.textContent = data.netId
        headingElm.textContent = data.heading
        coords3Elm.textContent = data.coords3
        coords4Elm.textContent = data.coords4
    }
});


document.addEventListener('keydown', function(event) {
    var key = event.key || event.keyCode;
    if (key === 'Escape' || key === 27) {
        closeNUI();
    }
});

function closeNUI() {
    uiElm.style.display = 'none'
    alertElm.textContent = ''
    saveElm.textContent = 'save object'
    fetch(`https://${GetParentResourceName()}/release`);
}
