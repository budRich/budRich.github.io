;(function () {
    var budnav_scrollpos = 0

    function myFunction(e) {
      if (document.querySelector('#urban a div.budnav__active') !== null) {
        document.querySelector('#urban a div.budnav__active').classList.remove('budnav__active');
      }
      e.target.querySelector('div').classList.add("budnav__active");
    }

    addEventListener('turbolinks:click', function (event) {
        myFunction(event)
    })
    // Persist the scroll position when leaving a page
    addEventListener('turbolinks:before-visit', function (event) {
        budnav_scrollpos = document.getElementById("urban").scrollTop
    })

    addEventListener('turbolinks:render', function (event) {
        document.getElementById("urban").scrollTop = budnav_scrollpos
    })

})()

