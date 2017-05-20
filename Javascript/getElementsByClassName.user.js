HTMLDocument.prototype.getElementsByClassName = function(class_name) {
    var docList = this.all || this.getElementsByTagName('*');
    var matchArray = new Array();

    /*Create a regular expression object for class*/
    var re = new RegExp("(?:^|\\s)"+class_name+"(?:\\s|$)");
    for (var i = 0; i < docList.length; i++) {
        if (re.test(docList[i].className) ) {
            matchArray[matchArray.length] = docList[i];
        }
    }

	return matchArray;
}//eof annonymous function

document.getElementsByClassName = function(class_name) {var docList = this.all || this.getElementsByTagName('*');var matchArray = new Array();var re = new RegExp("(?:^|\\s)"+class_name+"(?:\\s|$)");for (var i = 0; i < docList.length; i++) {if (re.test(docList[i].className) ) {matchArray[matchArray.length] = docList[i];}}return matchArray;}

