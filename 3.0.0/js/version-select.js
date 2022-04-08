function toggleVersionSelect() {
  // clear current version list
  var versionsList = document.getElementById("versions");
  versionsList.innerHTML = '';

  const length = Versions.length;
  for (var i = 0; i < length; i++) {
    var link = document.createElement('a');
    link.setAttribute('href',"../" + Versions[i] + "/index.html");
    link.innerText = Versions[i];
    versionsList.appendChild(link);
  }

  versionsList.classList.toggle("show");
}

// Close the dropdown menu if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.versionbtn')) {
    var dropdowns = document.getElementsByClassName("version-dropdown-content");
    for (var i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}