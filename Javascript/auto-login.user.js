// ==UserScript==
// @name           Auto-login
// @include        *login.daptiv.com/*
// @description    Automatically submit login for several assurant sites.
// ==/UserScript==

document.forms["login-form"].submit();
//document.getElementsByTagName("form")[0].submit()