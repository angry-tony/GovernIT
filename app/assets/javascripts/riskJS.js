$(function() 
{
 
  $( "#dialogRiskScale" ).dialog({
    autoOpen: false,
    resizable: false,
    modal: true,
    buttons: {
      "Aceptar": function() 
      {
        $( this ).dialog( "close" );
      }
    }
  });

  $("#showRiskScaleHTML").click(function(){
    var myPos = $("#showRiskScaleHTML");
  	$("#dialogRiskScale").dialog("option", "width", 700);
    $("#dialogRiskScale").dialog("option", "height", 540);
    $("#dialogRiskScale").dialog("option", "resizable", false);
    $("#dialogRiskScale").dialog("option", "position", { my: "top", at: "center", of: myPos });
    $("#dialogRiskScale").dialog("open");
  });


});




