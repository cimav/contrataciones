document.addEventListener("turbolinks:load", function() {
    $(".thumbnail").hover(function(){$(this).toggleClass("animated pulse");});
})