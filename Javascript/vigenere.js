//javascript:(function(){
function vigenere (input, key, forward){
	if (key == null)
		key = "";
	var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" 
	             + "abcdefghijklmnopqrstuvwxyz0123456789";
	key = key . toUpperCase ();
	var key_len = key . length;
	var i;
	var adjusted_key = "";
	for (i = 0; i < key_len; i ++){
		var key_char = alphabet . indexOf (key . charAt (i));
		if (key_char < 0)
			continue;
		adjusted_key += alphabet . charAt (key_char);
	}
	key = adjusted_key;
	key_len = key . length;
	if (key_len == 0){
		alert ('You forgot to supply a key!');
		key = "a";
		key_len = 1;
	}
	var input_len = input . length;
	var output = "";
	var key_index = 0;
	var in_tag = false;
	for (i = 0; i < input_len; i ++){
		var input_char = input . charAt (i);
		if (input_char == "<")
			in_tag = true;
		else if (input_char == ">")
			in_tag = false;
		if (in_tag){
			output += input_char;
			continue;
		}
		var input_char_value = alphabet . indexOf (input_char);
		if (input_char_value < 0){
			output += input_char;
			continue;
		}
		var lowercase = input_char_value >= 36 ? true : false;
		if (forward)
			input_char_value += alphabet . indexOf (key . charAt (key_index));
		else
			input_char_value -= alphabet . indexOf (key . charAt (key_index));
		input_char_value += 36;
		if (lowercase)
			input_char_value = input_char_value % 36 + 36;
		else
			input_char_value %= 36;
		output += alphabet . charAt (input_char_value);
		key_index = (key_index + 1) % key_len;

	}
	return output;
}

var basePass = prompt("Base password:","");
var domain = prompt("Name to encode with:", "");
alert(vigenere(basePass, domain, true));
//})();;