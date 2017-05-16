document.addEventListener("turbolinks:load", function() {
    $("#response_level_id").change(function(){
        $('#level:not('+this.value+')').hide();
        $('#level'+this.value).show();

    });
})