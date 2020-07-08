;(function(){var dim={}
var budnav_scrollpos=0
var budnav_container={}
var cb={}
var breakpoint=1024
addEventListener('DOMContentLoaded',function(event){dim=budlabs_getWindowDims()
var vw=dim.width
cb=document.getElementById('cb__sidebar-toggle')
budnav_container=document.getElementById("budnav-container")
cb.checked=(vw<breakpoint?false:true)})
window.addEventListener('resize',function(event){var oldw=dim.width
dim=budlabs_getWindowDims()
var neww=dim.width
cb.checked=(((oldw>breakpoint)&&(neww<breakpoint))?false:((neww>breakpoint)&&(oldw<breakpoint))?true:cb.checked)})
addEventListener('turbolinks:click',function(event){var trg=document.querySelector('#budnav-container a div.budnav__active')
if(trg!==null){trg.classList.remove('budnav__active')}
event.target.querySelector('div').classList.add("budnav__active")
dim=budlabs_getWindowDims()
if(dim.width<breakpoint){cb.checked=false}})
addEventListener('turbolinks:before-visit',function(event){budnav_scrollpos=budnav_container.scrollTop})
addEventListener('turbolinks:render',function(event){budnav_container.scrollTop=budnav_scrollpos})})()