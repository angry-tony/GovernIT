$( document ).ready(function() {

  // Click en alguna de las pestañas:
  // Objetivos de Negocio:
  $("#pill_b_generated").click(function(){
    // Obtiene la clase, si no está activo, la activa y desactiva la otra, de lo contrario no hace nada:
    var clase = $("#pill_b_generated").attr("class");
    if (clase == 'active') 
    {
      // No hace nada
    } 
    else
    {
      // Desactiva la anterior, modifica su cursor, y oculta su div:
      $("#pill_it_generated").css('cursor','pointer');
      $("#pill_it_generated").attr('class','');
      $("#it_goals").hide();

      // Activa esta opción, modifica su cursor, y muestra su div:
      $("#pill_b_generated").css('cursor','normal');
      $("#pill_b_generated").attr('class','active');
      $("#business_goals").show();

    };
  });

  // Objetivos de TI:
  $("#pill_it_generated").click(function(){
    // Obtiene la clase, si no está activo, la activa y desactiva la otra, de lo contrario no hace nada:
    var clase = $("#pill_it_generated").attr("class");
    if (clase == 'active') 
    {
      // No hace nada
    } 
    else
    {
      // Desactiva la anterior, modifica su cursor, y oculta su div:
      $("#pill_b_generated").css('cursor','pointer');
      $("#pill_b_generated").attr('class','');
      $("#business_goals").hide();

      // Activa esta opción, modifica su cursor, y muestra su div:
      $("#pill_it_generated").css('cursor','normal');
      $("#pill_it_generated").attr('class','active');
      $("#it_goals").show();


    };
  });

});