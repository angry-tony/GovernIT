$(function() {

    $("#dialogFuncs").dialog({
      autoOpen: false,
      modal: true,
      buttons: {
        "Aceptar": function(){
          // Esconde el div mostrado:
          var onShow = $("#dialogFuncs").data('idEst');
          $("#divShow"+onShow).hide();

          $(this).dialog("close");
        }
      },
      close : function()
      {
        // Esconde el div mostrado:
        var onShow = $("#dialogFuncs").data('idEst');
        $("#divShow"+onShow).hide();
        $(this).dialog("close");
      },
    });

    $("#dialogArchReport").dialog({
      autoOpen: false,
      modal: true,
      buttons: {
        "Aceptar": function(){
          $(this).dialog("close");
        }
      },
      close : function()
      {
        $(this).dialog("close");
      },
    });

    $("#dialog_findings").dialog({
      autoOpen: false,
      modal: true,
      buttons: {
        "Aceptar": function(){
          // Esconde el contenido mostrado:
          var onShow = $("#dialog_findings").data('idDec');
          $("#infoFinding"+onShow).hide();
          $(this).dialog("close");
        }
      },
      close : function()
      {
        // Esconde el contenido mostrado:
        var onShow = $("#dialog_findings").data('idDec');
        $("#infoFinding"+onShow).hide();
        $(this).dialog("close");
      },
    });
 

    $(".showFuncs").click(function () {
      // Obtiene el id de la estructura, para mostrar su div en el dialogo:
      var idEst = this.id.split("_")[1];
      $("#divShow"+idEst).show();
      var idDec = this.id.split("_")[2];
      var idCol = this.id.split("_")[3];

      var myPos = $("#par_"+idEst+"_"+idDec+"_"+idCol);
      var title = myPos.text().substring(2, myPos.text().length);

      // Abre el dialogo:
      $("#dialogFuncs").dialog("option", "width", 400);
      // Asigna el titulo al dialogo:
      $("#dialogFuncs").dialog('option', 'title', title );
      $("#dialogFuncs").dialog("option", "height", 300);
      $("#dialogFuncs").dialog("option", "resizable", false);
      $("#dialogFuncs").data('idEst', idEst);
      $("#dialogFuncs").dialog("option", "position", { my: "center", at: "center", of: myPos });
      // Pasa el id de la implicacion, como parametro al dialogo:
      $("#dialogFuncs").dialog("open");
    });

    // Muestra el reporte de identificacion de arquetipos:
    $("#archReport").click(function(){
      var myPos = $(this);
      // Abre el dialogo:
      $("#dialogArchReport").dialog("option", "width", 880);
      // Asigna el titulo al dialogo:
      $("#dialogArchReport").dialog('option', 'title', 'Arquetipo de gobierno identificado' );
      $("#dialogArchReport").dialog("option", "height", 460);
      $("#dialogArchReport").dialog("option", "resizable", false);
      $("#dialogArchReport").dialog("option", "position", { my: "top", at: "bottom", of: myPos });
      $("#dialogArchReport").dialog("open");
    });


    // Muestra los hallazgos:
    $(".span_finding_static").click(function () {
      // span_[decision_id]
      var span = $("#"+this.id);
      var idSpan = this.id;
      var idDec = idSpan.replace("span_", "");
      idDec = idDec.trim();  // Decision
      var title = "Hallazgos documentados por decisión";

      // Muestra todos los contenidos de su decision:
      $("#infoFinding"+idDec).show();


      $("#dialog_findings").dialog("option", "width", 700);
      $("#dialog_findings").dialog('option', 'title', title );
      $("#dialog_findings").dialog("option", "height", 350);
      $("#dialog_findings").dialog("option", "resizable", false);
      // Pasa el id de la celda, como parametro al dialogo:
      $("#dialog_findings").data('idDec', idDec);
      $("#dialog_findings").dialog("option", "position", { my: "left top", at: "right top", of: span });
      $("#dialog_findings").dialog("open");    

    });

});




