// ==UserScript==
// @name            Gmail Ad-remover
// @include         *mail.google.com/mail/*
// @description		Removes advertisement bar from gmail.
// ==/UserScript==

advert = window.frames[3].document.getElementsByClassName('mq')[0];
advert.parentNode.removeChild(advert);
adFrame = window.frames[3].document.getElementsByClassName('Bu y3')[0];
adFrame.parentNode.removeChild(adFrame);