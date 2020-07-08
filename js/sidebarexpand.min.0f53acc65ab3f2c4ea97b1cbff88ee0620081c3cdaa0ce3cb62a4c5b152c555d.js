;(function(){addEventListener('DOMContentLoaded',function(event){trg=document.querySelector(`#budnav-container a[href='${window.location.href}']`)
if(trg){trg.querySelector('div').classList.add("budnav__active")
var exp=trg.parentNode.parentNode.previousElementSibling
exp=exp.getAttribute("for")
while(exp!="root"){var trgcb=document.getElementById(exp)
trgcb.checked=true
exp=trgcb.getAttribute("data-budnav-parent")}}})})()