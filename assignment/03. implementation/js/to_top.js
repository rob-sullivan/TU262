//Get the button
var top_button = document.getElementById("top-button");

// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function() {showScroll()};

function showScroll() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        top_button.style.display = "block";
    } else {
        top_button.style.display = "none";
    }
}

// When the user clicks on the button, scroll to the top of the document
function JumpToTop() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
}