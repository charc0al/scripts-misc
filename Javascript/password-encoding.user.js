// ==UserScript==
// @name           Password Encoding
// @include        *
// @description    Encodes passwords with a base password + domain name, and automatically fills in the password field.
// ==/UserScript==

var hilightColor = '#96E1FE';

var globalStyle = "			border-style:	solid;\
							border-color:	#000;\
							border-width:	1px;\
							border-radius:	5px;\
							height:			22px;\
							font:			11px \"lucida grande\",tahoma,verdana,arial,sans-serif;\
							font-size:		11px;\
							font-family:	\"lucida grande\",tahoma,verdana,arial,sans-serif;";

var mainDivStyle = "		background:		#555;\
							border: 		4px solid #555;\
							border-radius:	6px;\
							width:			370px";

var displayButtonStyle = "	background:		#AAAAAA;\
							width:			40px;\
							cursor:			pointer;\
							float:			left;" + globalStyle;
							
var closeButtonStyle = "	background:		#A55;\
							margin-left:	3px;\
							width:			14px;\
							cursor:			pointer;\
							float:			right;" + globalStyle;

var inputWrapperStyle = "	float:left;";
var inputDivStyle = 	"	box-sizing: content-box;\
							-webkit-box-sizing: content-box;";

var inputStyleTemplate = globalStyle + 
						"	box-sizing:		content-box;\
							width:			150px;\
							margin:			0px;\
							padding:		0px;\
							outline:		none;\
							background:";
							
var inputStyle = inputStyleTemplate+hilightColor+"; margin-right:	3px;";
var domainStyle = inputStyleTemplate+"#DDDDDD;";

HTMLDocument.prototype.getElementsByAttribute = function(val, attr_name){
	var docList = this.all || this.getElementsByTagName('*');
	var matchArray = new Array();
	var re = new RegExp('(?:^|\\s)'+attr_name+'(?:\\s|$)');
	for(var i=0;i<docList.length;i++){
		if(re.test(docList[i].getAttribute(val))){
			matchArray[matchArray.length] = docList[i];
		}
	}
	return matchArray;
}

passwordFields = document.getElementsByAttribute('type','password');

if(passwordFields.length >= 1){
	passwordInput = passwordFields[0];
	window.location.assign("javascript:\
	function vigenere (input, key, forward){\
		if (key == null){key = '';}\
		var alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'+'abcdefghijklmnopqrstuvwxyz0123456789';\
		key = key . toUpperCase();\
		var key_len = key . length;\
		var i;\
		var adjusted_key = '';\
		for (i = 0; i < key_len; i ++){\
			var key_char = alphabet . indexOf (key . charAt (i));\
			if (key_char < 0){continue;}\
			adjusted_key += alphabet . charAt (key_char);\
		}\
		key = adjusted_key;\
		key_len = key . length;\
		if (key_len == 0){\
			key = 'a';\
			key_len = 1;\
		}\
		var input_len = input . length;\
		var output = '';\
		var key_index = 0;\
		var in_tag = false;\
		for (i = 0; i < input_len; i ++){\
			var input_char = input . charAt (i);\
			if (input_char == '<'){\
				in_tag = true;}\
			else if (input_char == '>'){\
				in_tag = false;}\
			if (in_tag){\
				output += input_char;\
				continue;\
			}\
			var input_char_value = alphabet . indexOf (input_char);\
			if (input_char_value < 0){\
				output += input_char;\
				continue;\
			}\
			var lowercase = input_char_value >= 36 ? true : false;\
			if (forward){\
				input_char_value += alphabet . indexOf (key . charAt (key_index));}\
			else{\
				input_char_value -= alphabet . indexOf (key . charAt (key_index));}\
			input_char_value += 36;\
			if (lowercase){\
				input_char_value = input_char_value % 36 + 36;}\
			else{\
				input_char_value %= 36;}\
			output += alphabet . charAt (input_char_value);\
			key_index = (key_index + 1) % key_len;\
		}\
		return output;\
	}\
	function generatePass(flag){\
		if(event.keyCode==27){\
			hidePassKey();\
			return;\
		}\
		if (event.keyCode==13){\
			hidePassKey();\
			focusPassword();\
		}\
		else{\
			var vigenerePassKey = document.getElementById('vigenerePassKey').value;\
			var domain = document.getElementById('passkeyDomain').value;\
			encodedPass = vigenere(vigenerePassKey,domain,true);\
			if(flag){\
				if(domain.indexOf('assurant') >= 0)\
					encodedPass = encodedPass.replace(/[^a-zA-Z0-9]/g,'').substring(0,8);\
				if((domain.indexOf('kcpl') >= 0) || (domain.indexOf('timewarnercable') >= 0))\
					encodedPass = encodedPass.replace(/[^a-zA-Z0-9]/g,'');\
				passwordInput.value = encodedPass;}\
			else{\
				prompt('Encoded Password:',encodedPass);}\
		}\
	}\
	function focusPassword(){\
		passwordInput.setAttribute('onfocus','');\
		passwordInput.focus();\
		passwordInput.setAttribute('onclick','');\
		passwordInput.setAttribute('onblur','resetPasswordFieldAction()');\
	}\
	function showPasswordBar(elem){\
		passwordInput = elem;\
		var wrapperDiv = document.getElementById('passwordEncodeWrapper');\
		wrapperDiv.style.display='block';\
		var url = window.location.hostname.split('.');\
		var domain = url[url.length-2];\
		document.getElementById('passkeyDomain').value=domain;\
		document.getElementById('vigenerePassKey').value='';\
		document.getElementById('vigenerePassKey').focus();\
	}\
	function hidePassKey(){\
		var wrapperDiv = document.getElementById('passwordEncodeWrapper');\
		wrapperDiv.style.display='none';\
	}\
	function closeToolBar(){\
		hidePassKey();\
		focusPassword();\
	}\
	function resetPasswordFieldAction(){\
		passwordInput.setAttribute('onblur','');\
		passwordInput.setAttribute('onclick','showPasswordBar(this)');\
		passwordInput.setAttribute('onfocus','showPasswordBar(this)');\
	}\
	");

	for(i=0;i<passwordFields.length;i++){
		passwordFields[i].style.background=hilightColor;
		passwordFields[i].setAttribute('onfocus','showPasswordBar(this)');
		passwordFields[i].setAttribute('onclick','showPasswordBar(this)');
	}
	wrapperDiv = document.createElement('div');
	wrapperDiv.id="passwordEncodeWrapper";
	wrapperDiv.align="center";
	wrapperDiv.style.width = "100%";
	wrapperDiv.style.top = "0";
	wrapperDiv.style.zIndex="1000000"
	wrapperDiv.style.position = "fixed";
	wrapperDiv.style.display = "none";

	wrapperDiv.innerHTML = "<div style='"+mainDivStyle+"'>\
									<div style='padding:0px; height:24px; width: 370px'>\
										<div id='passwordBarInputWrapper' style='"+inputWrapperStyle+"'>\
											<div style='float:left;"+inputDivStyle+"'>\
												<input type='password' id='vigenerePassKey' style='"+inputStyle+"' onkeyup='generatePass(1)'></input>\
											</div>\
											<div style='float:right;"+inputDivStyle+"'>\
												<input type='text' id='passkeyDomain' style='"+domainStyle+"' onkeyup='generatePass(1)'></input>\
											</div>\
										</div>\
										<div style='float:right;"+inputDivStyle+"'>\
											<div style='"+displayButtonStyle+"' onclick='generatePass(0)'>\
												<div style='height: 20px; margin:4px'>\
													<strong>Show</strong>\
												</div>\
											</div>\
											<div style='"+closeButtonStyle+"' onclick='closeToolBar()'>\
												<div style='height: 20px; margin:4px'>\
													<strong>X</strong>\
												</div>\
											</div>\
										</div>\
									</div>\
							</div>" 
	document.body.appendChild(wrapperDiv);
}