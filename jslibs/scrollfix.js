;(function () {
  // Tell the browser not to handle scrolling when restoring via the history or when reloading
  if ('scrollRestoration' in history) history.scrollRestoration = 'manual'

  var SCROLL_POSITION = 'scroll-position'
  var PAGE_INVALIDATED = 'page-invalidated'

  // Patch the reload method to flag that the following page load originated from the page being invalidated
  Turbolinks.BrowserAdapter.prototype.reload = function () {
    sessionStorage.setItem(PAGE_INVALIDATED, 'true')
    location.reload()
  }

  // Persist the scroll position when leaving a page
  addEventListener('beforeunload', function () {

    sessionStorage.setItem(
      SCROLL_POSITION,
      JSON.stringify({
        scrollX: scrollX,
        scrollY: scrollY,
        sidescroll: document.getElementById("urban").scrollTop,
        location: location.href
      })
    )
  })

  // When a page is fully loaded:
  // 1. Get the persisted scroll position
  // 2. If the locations match and the load did not originate from a page invalidation, scroll to the persisted position
  // 3. Remove the persisted information
  addEventListener('DOMContentLoaded', function (event) {
    var scrollPosition = JSON.parse(sessionStorage.getItem(SCROLL_POSITION))

    if (shouldScroll(scrollPosition)) {
      scrollTo(scrollPosition.scrollX, scrollPosition.scrollY)
    }

    document.getElementById("urban").scrollTop = scrollPosition.sidescroll
    sessionStorage.removeItem(SCROLL_POSITION)
    sessionStorage.removeItem(PAGE_INVALIDATED)
  })

  function shouldScroll (scrollPosition) {
    return (
      scrollPosition &&
      scrollPosition.location === location.href &&
      !JSON.parse(sessionStorage.getItem(PAGE_INVALIDATED))
    )
  }
})()
