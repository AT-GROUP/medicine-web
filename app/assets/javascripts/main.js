var embPlacemark, cord1 = 55.936952, cord2 = 37.343334;
var myMap, DTP, DTPx, DTPy;
var lpys, geoLpys = [], cars, geoCars = [];
var buildFlag, endBuildFlag, res = [], maxDTPQountConst = 100;
var lastCar = null, lastLPY = null, victims=0, sstime = 0, last_victims;

function set_new_progress(pers){
  var div = $('#progress-bar');
  var intPers = Math.round(pers)*5;
  div.css('width', intPers + '%');
  div.text(' ' + intPers + '%');
}

function update_last_victims_div(){
  $('#last_victims_div').html(last_victims);
  if(last_victims <= 0)
    $('#victims_button').attr('disabled', true);
  else
    $('#victims_button').attr('disabled',false);
}

function recalc_victims(){
}

function reserve_car(){
  if(DTPx == null || DTPy == null){
    alert("Поблизости нет ДТП!");
    return;
  }
  if (lastCar == null){
    alert("Выберите машину на карте.");
    return;
  }
  last_victims--;
  update_last_victims_div();
  ymaps.route([ { type: 'wayPoint', point: [DTPx, DTPy] }, 
                { type: 'wayPoint', point: lastCar.geometry.getCoordinates() } 
             ]).done(function (route) {
                sstime += route.getJamsTime();
                geoCars.remove(lastCar);
                lastCar = null;
             });
  
}

function generateDTP(){
  if (DTP != null)
    myMap.geoObjects.remove(DTP);
  victims = 0;
  for(var i = 1; i < 5; i++){
    var temp = parseInt($('#victim' + i).val(), 10);
    if(!isNaN(temp) && temp > 0)
      victims += temp;
  }
  last_victims = victims;
  update_last_victims_div();
  var address = $('#inputRegion').val() + ', ' + $('#inputAddress').val();

  ymaps.geocode(address, { results: 1 }).then(function (res) {
      var geo = res.geoObjects.get(0);
      var gcords = geo.geometry.getCoordinates();
      DTPx = gcords[0];
      DTPy = gcords[1];
      DTP = new ymaps.Placemark(gcords, {
        balloonContent: 'ДТП: ' + victims + ' пострадало',
        }, {
            iconLayout: 'default#image',
            iconImageHref: 'images/dtp.png',
            iconImageSize: [60, 60],
            iconImageOffset: [-30, -30],
            // Определим интерактивную область над картинкой.
            iconShape: {
                type: 'Circle',
                coordinates: [0, 0],
                radius: 40
        },
        balloonCloseButton: false,   
        hideIconOnBalloonOpen: false
      });
          
      myMap.geoObjects.add(DTP);

  });

    // При щелчк
}  

function showLPYs(){
  var htmlresp;

  var cords = myMap.getBounds();
  var minx = cords[0][0];
  var miny = cords[0][1];
  var maxx = cords[1][0];
  var maxy = cords[1][1];
        
  $.ajax({
    url: "ajax/get_lpys?startx="+minx+
              "&endx="+maxx+"&starty="+miny+"&endy="+maxy,
    cache: false, 
    success: function(htmlresp) {
    lpys = JSON.parse(htmlresp);
    
    for(var i = 0; i < lpys.length; ++i){
      geoLpys.add( new ymaps.Placemark([lpys[i].x_coord, lpys[i].y_coord], {
        balloonContent: lpys[i].LPYname,
        }, {
            iconLayout: 'default#image',
            iconImageHref: 'images/lpy.png',
            iconImageSize: [20, 20],
            iconImageOffset: [-10, -10],
            iconShape: {
                type: 'Circle',
                coordinates: [0, 0],
                radius: 40
            },
            balloonCloseButton: false,   
            hideIconOnBalloonOpen: false
      }))          
    }
    myMap.geoObjects.add(geoLpys);
  } 
  });
}

function hideLPYs(){
  geoLpys.removeAll();
}

function hideCars(){
  geoCars.removeAll();
}


var sc;
function showCars(){
  var htmlresp;

  var cords = myMap.getBounds();
  var minx = cords[0][0];
  var miny = cords[0][1];
  var maxx = cords[1][0];
  var maxy = cords[1][1];
        
  $.ajax({
    url: "ajax/get_lpys?startx="+minx+
              "&endx="+maxx+"&starty="+miny+"&endy="+maxy,
    cache: false, 
    success: function(htmlresp) {
    cars = JSON.parse(htmlresp);
    
    for(var i = 0; i < cars.length; ++i){
       var plmark = new ymaps.Placemark([cars[i].x_coord, cars[i].y_coord], {
        balloonContent: cars[i].LPYname,
        }, {
            iconLayout: 'default#image',
            iconImageHref: 'images/car.png',
            iconImageSize: [20, 20],
            iconImageOffset: [-10, -10],
            iconShape: {
                type: 'Circle',
                coordinates: [0, 0],
                radius: 40
            },
            balloonCloseButton: false,   
            hideIconOnBalloonOpen: false
      });
      plmark.events.add("click", function (e) {
        lastCar = e._Jo.target;
      });
      sc = plmark;
      geoCars.add(plmark);      
    }
    myMap.geoObjects.add(geoCars);
  } 
  });
}

function show(){
	var shirv = document.getElementById("shir").value;
	var longv = document.getElementById("long").value;
	ymaps.route([
      { type: 'wayPoint', point: [shirv, longv] },
      { type: 'wayPoint', point: [55.811511, 37.312518] }
  ], {
      mapStateAutoApply: true
  }).then(function (route) {
    route.getPaths().options.set({
        // в балуне выводим только информацию о времени движения с учетом пробок
        balloonContentBodyLayout: ymaps.templateLayoutFactory.createClass('{{ properties.humanJamsTime }}'),
        // можно выставить настройки графики маршруту
        strokeColor: '008888ff',
        opacity: 0.9
    });
    document.getElementById("time").value = route.getJamsTime();
    document.getElementById("dlin").value = route.getLength();
    // добавляем маршрут на карту
    myMap.geoObjects.add(route);
  });
}



function makeResJson(){
  if(res.length == 0 )
    return "none";
  
  var resStr = "[";
  for(var i = 0; i < res.length; i++){
    resStr += JSON.stringify(res[i]);
    resStr += ",";
  }
  resStr+=']';
  
  return resStr;
}

function sendDTPdata(){
  $('#finishprog').removeClass('nodisplay').addClass('yesdisplay');
  $('#progressd').removeClass('yesdisplay').addClass('nodisplay');
  $.post("planning/senddtp", { result : makeResJson() }).done(function( data ) {
    $('#autoRes').html(data);
  });
}

function getDTPData(){
  if(DTPx == null || DTPy == null){
    alert("Поблизости нет ДТП!");
    return;
  }
  if (lpys == null || lpys.length == 0){
    alert("Поблизости нет ЛПУ!");
    return;
  }

  $('#finishprog').removeClass('yesdisplay').addClass('nodisplay'); 
  $('#progressd').removeClass('nodisplay').addClass('yesdisplay');

  if( lpys.length > maxDTPQountConst )
    endBuildFlag = maxDTPQountConst * 2;
  else
    endBuildFlag = (lpys.length - 1) * 2;

  buildFlag = 0;
  getRouteData();
}

function getRouteData(){
  var i = buildFlag/2>>0;
  //alert(i);
  if(buildFlag % 2 == 0){
    ymaps.route([ { type: 'wayPoint', point: [DTPx, DTPy] }, 
                  { type: 'wayPoint', point: [lpys[i].x_coord, lpys[i].y_coord] } 
               ]).done(function (route) {
                  var i = buildFlag/2;
                  if( res[i] == null )
                    res[i] = {};
                 res[i].from_time = route.getJamsTime();
                 res[i].from_length = route.getLength();
                 ++buildFlag;
                 getRouteData();
               });
  } else {  
    ymaps.route([ { type: 'wayPoint', point: [lpys[i].x_coord, lpys[i].y_coord] }, 
                  { type: 'wayPoint', point: [DTPx, DTPy] } 
               ]).done(function (route) {
                 if( res[i] == null )
                   res[i] = {};
                 res[i].to_time = route.getJamsTime();
                 res[i].to_length = route.getLength();
                 ++buildFlag;
                 if(buildFlag == endBuildFlag)
                   sendDTPdata();
                 else
                   getRouteData();
               });
  }
  set_new_progress(buildFlag/endBuildFlag*20);
}