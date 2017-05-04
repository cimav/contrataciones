
$(document).ready(function(){
    $("#response_level_id").change(function(){
        $.get("/levels/"+this.value, function(data, status){
            document.getElementById("level-requirements").innerHTML =  data;
        });

    });
});