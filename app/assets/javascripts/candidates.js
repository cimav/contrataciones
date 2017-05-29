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

    $("#candidate_level_id").change(function(){
       // $('#desagree_level1').hide();
        $('#desagree_level2').hide();
        $('#desagree_level3').hide();
        $('#desagree_level4').hide();
        $('#desagree_level5').hide();
        $('#desagree_level6').hide();
        $('#desagree_level7').hide();
        $('#desagree_level8').hide();
        $('#desagree_level9').hide();
        $('#desagree_level10').hide();
        $('#desagree_level11').hide();
        $('#desagree_level'+this.value).show();

    });

    $("#close_votation").click(function(){
        $.post("close_votation",
            {
                name: "Donald Duck",
                city: "Duckburg"
            },
            function(data,status){
                alert("Data: " + data + "\nStatus: " + status);
            });
    });

})