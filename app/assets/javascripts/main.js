//------------- переменные ----------------
// create
var embPlacemark, cord1 = 55.936952, cord2 = 37.343334;
var myMap, DTP, DTPx, DTPy;
var buildFlag, endBuildFlag, res = [], maxDTPQountConst = 100;
var victims=0, victims_matrix = [];
// self
var lpys, geoLpys = [], cars, geoCars = [];
var lastCar = null, lastLPY = null, vict_cars = [], vict_lpys = [], sstime = 0, last_vict_cars, last_vict_lpys;
// auto

// results
var auto_res, self_res;



//------------- функции -------------------
// create
function recalc_victims(i, j){
  var temp = parseInt($('#victim' + i + j).val(), 10);
  if(isNaN(temp) || temp < 0)
    $('#victim' + i + j).val('0');
}

function generateDTP(){
  if (DTP != null)
    myMap.geoObjects.remove(DTP);
  victims = 0;
  for(var i = 1; i < 5; i++){
    victims_matrix[i] = [];
    for(var j = 1; j < 5; j++){
      victims_matrix[i][j] = 0;
      var temp = parseInt($('#victim' + i + j).val(), 10);
      if(!isNaN(temp) && temp > 0){
        victims_matrix[i][j] = temp;
        victims += temp;
      }
    }
  }
  update_selfsolve();

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


// self
function update_lpys_btn(i, j){
  var btn = $('#btn-lpy' + i + j);
  if(vict_lpys[i][j] <= 0){
    btn.val(0);
    btn.attr('disabled', true);
  }
  else
  {
    btn.val(vict_lpys[i][j]);
    btn.attr('disabled', false);
  }
}

function update_cars_btn(i, j){
  var btn = $('#btn-car' + i + j);
  if(vict_cars[i][j] <= 0){
    btn.val(0);
    btn.attr('disabled', true);
  }
  else
  {
    btn.val(vict_cars[i][j]);
    btn.attr('disabled', false);
  }
}

function update_selfsolve(){
  sstime = 0;
  last_vict_cars = victims;
  last_vict_lpys = victims;
  for(var i = 1; i < 5; i++){
    vict_cars[i] = [];
    vict_lpys[i] = [];
    for(var j = 1; j < 5; j++){
      vict_cars[i][j] = victims_matrix[i][j];
      vict_lpys[i][j] = victims_matrix[i][j];
      update_cars_btn(i, j);
      update_lpys_btn(i, j);
    }
  }

}

function reserve_car(i, j){
  if(DTPx == null || DTPy == null){
    alert("Поблизости нет ДТП!");
    return;
  }
  if (lastCar == null){
    alert("Выберите машину на карте.");
    return;
  }

  last_vict_cars--;
  vict_cars[i][j]--;
  update_cars_btn(i, j);

  ymaps.route([ { type: 'wayPoint', point: [DTPx, DTPy] }, 
                { type: 'wayPoint', point: lastCar.geometry.getCoordinates() } 
             ]).done(function (route) {
                sstime += route.getJamsTime();
                geoCars.remove(lastCar);
                lastCar = null;
             });
  
}

function reserve_lpy(i, j){
  if(DTPx == null || DTPy == null){
    alert("Поблизости нет ДТП!");
    return;
  }
  if (lastLPY == null){
    alert("Выберите ЛПУ на карте.");
    return;
  }

  last_vict_lpys--;
  vict_lpys[i][j]--;
  update_lpys_btn(i, j);

  ymaps.route([ { type: 'wayPoint', point: [DTPx, DTPy] }, 
                { type: 'wayPoint', point: lastLPY.geometry.getCoordinates() } 
             ]).done(function (route) {
                sstime += route.getJamsTime();
                geoLpys.remove(lastLPY);
                lastLPY = null;
             });
  
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
       var plmark = new ymaps.Placemark([lpys[i].x_coord, lpys[i].y_coord], {
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
      });
      plmark.events.add("click", function (e) {
        lastLPY = e._Jo.target;
      });
      geoLpys.add(plmark);      
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
      geoCars.add(plmark);      
    }
    myMap.geoObjects.add(geoCars);
  } 
  });
}

// auto
function set_new_progress(pers){
  var div = $('#progress-bar');
  var intPers = Math.round(pers)*5;
  div.css('width', intPers + '%');
  div.text(' ' + intPers + '%');
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
// results
function set_selfsolve_results(){
  if(last_vict_cars > 0 || last_vict_lpys > 0){
    alert('Вы еще не завершили решение.');
    return;
  }
  
  $('#selfRes').html('Затраченное время на доставку пострадавших в ЛПУ: ' + Math.floor(sstime/3600) + ' часов ' + Math.floor(sstime - Math.floor(sstime/60)*60) + ' минут ' + Math.floor(sstime - Math.floor(sstime/3600) * 3600) + ' секунд.');
  alert('Ознакомиться с результатами можно на вкладке "Результаты".);

}


