document.addEventListener("turbolinks:load", function() {
    $("#response_level_id").change(function(){
        $('#level1').hide();
        $('#level2').hide();
        $('#level3').hide();
        $('#level4').hide();
        $('#level5').hide();
        $('#level6').hide();
        $('#level7').hide();
        $('#level8').hide();
        $('#level9').hide();
        $('#level10').hide();
        $('#level11').hide();
        $('#level'+this.value).show();

    });

    $("#response_level_id-desagree").change(function(){
        $('#level1').hide();
        $('#level2').hide();
        $('#level3').hide();
        $('#level4').hide();
        $('#level5').hide();
        $('#level6').hide();
        $('#level7').hide();
        $('#level8').hide();
        $('#level9').hide();
        $('#level10').hide();
        $('#level11').hide();
        $('#level'+this.value).show();

    });


})