//validate on submit and don't submit if form validation errors exist.

function validateForm() {
    //check if input is not empty for name
    var x = document.forms["ContactForm"]["name"].value;
    if (x == "") {
      alert("Name must be filled out");
      return false;
    }

    //check if input is not empty for email
    var y = document.forms["ContactForm"]["email"].value;
    if (y == "") {
      alert("Email must be filled out");
      return false;
    }

    //check if input is not empty for message
    var z = document.forms["ContactForm"]["message"].value;
    if (z == "") {
      alert("Message must be filled out");
      return false;
    }
    
  }