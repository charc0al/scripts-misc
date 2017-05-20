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