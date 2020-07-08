;(function(){if('scrollRestoration'in history)history.scrollRestoration='manual'
var SCROLL_POSITION='scroll-position'
var PAGE_INVALIDATED='page-invalidated'
Turbolinks.BrowserAdapter.prototype.reload=function(){sessionStorage.setItem(PAGE_INVALIDATED,'true')
location.reload()}
addEventListener('beforeunload',function(){sessionStorage.setItem(SCROLL_POSITION,JSON.stringify({scrollX:scrollX,scrollY:scrollY,sidescroll:document.getElementById("budnav-container").scrollTop,location:location.href}))})
addEventListener('DOMContentLoaded',function(event){var scrollPosition=JSON.parse(sessionStorage.getItem(SCROLL_POSITION))
if(shouldScroll(scrollPosition)){scrollTo(scrollPosition.scrollX,scrollPosition.scrollY)}
document.getElementById("budnav-container").scrollTop=scrollPosition.sidescroll
sessionStorage.removeItem(SCROLL_POSITION)
sessionStorage.removeItem(PAGE_INVALIDATED)})
function shouldScroll(scrollPosition){return(scrollPosition&&scrollPosition.location===location.href&&!JSON.parse(sessionStorage.getItem(PAGE_INVALIDATED)))}})()