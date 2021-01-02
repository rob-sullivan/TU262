//show and hide the mobile menu button. Also add responsive class to the class field to show up mobile menu.
function mobileMenu() {
    var x = document.getElementById("main-nav");
    if (x.className === "main-nav") {
      x.className += " responsive";
    } else {
      x.className = "main-nav";
    }
  }