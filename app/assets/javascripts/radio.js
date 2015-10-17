function radio(hijos)
{
  var idsHide = hijos.split("#");
  var checks =  document.getElementsByName("rd2[]");
  var ok = false;

  for (var i = 0; i < checks.length; i++) 
  {
    ok = false;
    for (var j = 0; j < idsHide.length; j++) 
    {
      if (checks[i].value == idsHide[j]) 
        {
            ok = true;
            break;
        };
    };

    if (ok) 
      {
         checks[i].disabled = false;
      } 
    else
      {
         checks[i].checked = false;
         checks[i].disabled = true;
      };
  };

}
