var memberNo='';
var tableIndex=0;
var displayedDiv = displayedDiv = document.getElementById('worksiteMemberAdjustmentsDivId');
members = displayedDiv.getElementsByTagName('table')[0].getElementsByTagName('tbody')[0].childNodes;
headers = displayedDiv.getElementsByTagName('thead')[0].getElementsByTagName('th');
for(i=2;i<members.length-2;i++)
{
	var cols = members[i].childNodes.length;
	if((cols == headers.length) && (members[i].innerText != ''))
	{
		tables=members[i].childNodes[2].getElementsByTagName('table');
		for(m=0;m<tables.length;m++){if(tables[m].style.display!='none'){tableIndex = m;}}
		memberNo = members[i].getElementsByClassName('dr-subtable-cell')[0].innerText.split(/[\s]+/)[0];
		benefits = members[i].childNodes[1].getElementsByTagName('table')[tableIndex].getElementsByTagName('tr');
		members[i].getElementsByClassName('dr-subtable-cell')[0].getElementsByTagName('a')[0].setAttribute('id',memberNo+' Name');
		for(j=0;j<benefits.length;j++){
			covrName = benefits[j].innerText;
			for(k=1;k<members[i].childNodes.length;k++){
				members[i].childNodes[k].getElementsByTagName('table')[tableIndex].getElementsByTagName('tr')[j].setAttribute('id',memberNo+' '+benefits[j].innerText+' '+headers[k].innerText);
			}
		}
	}
	if(members[i].childNodes.length > 0){
		label=members[i].childNodes[0].innerText;
		if((label.indexOf('Total') == 0)||(label.indexOf('Subtotal') >= 0)){
			colspan = parseInt(members[i].childNodes[0].getAttribute('colspan')); 
			for(l=1;l<=headers.length-colspan;l++){
				members[i].childNodes[l].setAttribute('id',memberNo+' '+label+' '+headers[colspan+l-1].innerText);
			}
		}
	}
}