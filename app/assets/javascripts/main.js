//------------- переменные ----------------
// create
var embPlacemark, cord1 = 55.936952, cord2 = 37.343334;
var myMap, DTP, DTPx, DTPy;
var buildFlag, endBuildFlag, res = [], maxDTPQountConst = 100;
var victims=0, victims_matrix = [];
// self
var lpys1, lpys2, lpys3, lpys4, geoLpys = [], cars, resc=[], geoCars = [];
var lastCar = null, lastLPY = null, vict_cars = [], vict_lpys = [], last_vict_cars, last_vict_lpys, res1 = [], res2 = [], res3 = [], res4 = [];
var sstime = [0, 1000000000, 0, 1000000000, 0];
var qready;
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
  sstime = [0, 1000000000, 0, 1000000000, 0];
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
                var te = route.getJamsTime();
                sstime[0] += te
                if(sstime[1] > te) 
                  sstime[1] = te;
                if(sstime[2] < te)
                  sstime[2] = te;
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
                var te = route.getJamsTime();
                sstime[0] += te
                if(sstime[3] > te) 
                  sstime[3] = te;
                if(sstime[4] < te)
                  sstime[4] = te;
                geoLpys.remove(lastLPY);
                lastLPY = null;
             });
  
}

function showSurgery(){
  var htmlresp;

  var cords = myMap.getBounds();
  var minx = cords[0][0];
  var miny = cords[0][1];
  var maxx = cords[1][0];
  var maxy = cords[1][1];
        
  $.ajax({
    url: "ajax/get_lpy_with_surgery?lower_latitude="+minx+
              "&upper_latitude="+maxx+"&lower_longitude="+miny+"&upper_longitude="+maxy,
    cache: false, 
    success: function(htmlresp) {
    lpys1 = htmlresp;
    for(var i = 0; i < lpys1.length; ++i){
       var plmark = new ymaps.Placemark([lpys1[i].latitude, lpys1[i].longitude], {
        balloonContent: lpys1[i].name +
                        '<br/>Хирургия: ' + lpys1[i].surgery
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
    ++qready;
    if(qready == 4)
      myMap.geoObjects.add(geoLpys);
  } 
  });

}

function showBurn(){
  var htmlresp;

  var cords = myMap.getBounds();
  var minx = cords[0][0];
  var miny = cords[0][1];
  var maxx = cords[1][0];
  var maxy = cords[1][1];
        
  $.ajax({
    url: "ajax/get_lpy_with_burn?lower_latitude="+minx+
              "&upper_latitude="+maxx+"&lower_longitude="+miny+"&upper_longitude="+maxy,
    cache: false, 
    success: function(htmlresp) {
    lpys2 = htmlresp;
    for(var i = 0; i < lpys2.length; ++i){
       var plmark = new ymaps.Placemark([lpys2[i].latitude, lpys2[i].longitude], {
        balloonContent: lpys2[i].name +
                        '<br/>Ожоги: ' + lpys2[i].burn
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
    ++qready;
    if(qready == 4)
      myMap.geoObjects.add(geoLpys);
  } 
  });

}

function showNeuro(){
  var htmlresp;

  var cords = myMap.getBounds();
  var minx = cords[0][0];
  var miny = cords[0][1];
  var maxx = cords[1][0];
  var maxy = cords[1][1];
        
  $.ajax({
    url: "ajax/get_lpy_with_neuro?lower_latitude="+minx+
              "&upper_latitude="+maxx+"&lower_longitude="+miny+"&upper_longitude="+maxy,
    cache: false, 
    success: function(htmlresp) {
    lpys3 = htmlresp;
    for(var i = 0; i < lpys3.length; ++i){
       var plmark = new ymaps.Placemark([lpys3[i].latitude, lpys3[i].longitude], {
        balloonContent: lpys3[i].name +
                        '<br/>Нейрохирургия: ' + lpys3[i].surgery
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
    ++qready;
    if(qready == 4)
      myMap.geoObjects.add(geoLpys);
  } 
  });

}

function showReanimation(){
  var htmlresp;

  var cords = myMap.getBounds();
  var minx = cords[0][0];
  var miny = cords[0][1];
  var maxx = cords[1][0];
  var maxy = cords[1][1];
        
  $.ajax({
    url: "ajax/get_lpy_with_reanimation?lower_latitude="+minx+
              "&upper_latitude="+maxx+"&lower_longitude="+miny+"&upper_longitude="+maxy,
    cache: false, 
    success: function(htmlresp) {
    lpys4 = htmlresp;
    for(var i = 0; i < lpys4.length; ++i){
       var plmark = new ymaps.Placemark([lpys4[i].latitude, lpys4[i].longitude], {
        balloonContent: lpys4[i].name +
                        '<br/>Реанимация: ' + lpys4[i].reanimation
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
    ++qready;
    if(qready == 4)
      myMap.geoObjects.add(geoLpys);
  } 
  });

}
function showLPYs(){
  qready = 0;

  showSurgery();
  showBurn();
  showReanimation();
  showNeuro();
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
function showLPYsCars(){
  qready = 0;
  showCars();
  showSurgery();
  showBurn();
  showReanimation();
  showNeuro();
}
function set_new_progress(pers){
  var div = $('#progress-bar');
  var intPers = Math.round(pers)*5;
  div.css('width', intPers + '%');
  div.text(' ' + intPers + '%');
}

function makeResJson(){
  if(allq.length == 0 )
    return "none";  
  var resStr = "[[";
  for(var i = 0; i < resc.length; i++){
    resStr += resc[i].time;
    if(resc.length -1 != i)
      resStr += ",";
  }
  resStr+="],[";
  for(var i = 0; i < res1.length; i++){
    resStr += res1[i].time;
    if(res1.length -1 != i)
      resStr += ",";
  }
  resStr+='],[';
  for(var i = 0; i < res2.length; i++){
    resStr += res2[i].time;
    if(res2.length -1 != i)
      resStr += ",";
  }
  resStr+='],[';
  for(var i = 0; i < res3.length; i++){
    resStr += res3[i].time;
    if(res3.length -1 != i)
      resStr += ",";
  }
  resStr+='],[';
  for(var i = 0; i < res4.length; i++){
    resStr += res4[i].time;
    if(res4.length -1 != i)
      resStr += ",";
  }
  resStr+=']]';
  return resStr;
}

function get_sum_victs(j){
  var res = 0;

  for(var i = 1; i < 5; i++)
    res += victims_matrix[j][i];
  return res;
}

function sendDTPdata(){
  $('#finishprog').removeClass('nodisplay').addClass('yesdisplay');
  $('#progressd').removeClass('yesdisplay').addClass('nodisplay');

  $.post("planning/cap_solve", { 
    result : makeResJson(),
    total_victim : victims,
    surgery_victim: get_sum_victs(1),
    neuro_victim: get_sum_victs(2),
    reanimation_victim: get_sum_victs(3),
    burn_victim: get_sum_victs(4)
  }).done(function( data ) {
    set_auto_results(data)
  });
}

function getDTPData(){
  allq =  cars.length + lpys1.length + lpys2.length + lpys3.length + lpys4.length;
  if(DTPx == null || DTPy == null){
    alert("Поблизости нет ДТП!");
    return;
  }
  if (allq == null || allq == 0){
    alert("Поблизости нет ЛПУ!");
    return;
  }

  $('#finishprog').removeClass('yesdisplay').addClass('nodisplay'); 
  $('#progressd').removeClass('nodisplay').addClass('yesdisplay');

  

  iter = 0;
  qiter = 0;
  getRouteDataCars();
}

function getRouteDataCars(){
  
    ymaps.route([ { type: 'wayPoint', point: [cars[iter].x_coord, cars[iter].y_coord] }, 
                  { type: 'wayPoint', point: [DTPx, DTPy] } 
               ]).done(function (route) {
                  
                 resc[iter] = {};
                 resc[iter].time = route.getJamsTime();
                 resc[iter].dl = route.getLength();
                 ++iter;
                 ++qiter;
                 if(cars.length-1 == iter){
                   iter = 0;
                   getRouteData1();
                 }
                 else
                   getRouteDataCars();
               });

  set_new_progress(qiter/allq*20);
}

function getRouteData1(){
    ymaps.route([{ type: 'wayPoint', point: [DTPx, DTPy] }, 
                 { type: 'wayPoint', point: [lpys1[iter].latitude, lpys1[iter].longitude] } 
               ]).done(function (route) {

                 res1[iter] = {};
                 res1[iter].time = route.getJamsTime();
                 res1[iter].dl = route.getLength();
                 ++iter;
                 ++qiter;
                 if(lpys1.length == iter){
                   iter = 0;
                   getRouteData2();
                 }
                 else
                   getRouteData1();
               });

  set_new_progress(qiter/allq*20);
}
function getRouteData2(){
    ymaps.route([{ type: 'wayPoint', point: [DTPx, DTPy] }, 
                 { type: 'wayPoint', point: [lpys2[iter].latitude, lpys2[iter].longitude] }
               ]).done(function (route) {
                 res2[iter] = {};
                 res2[iter].time = route.getJamsTime();
                 res2[iter].dl = route.getLength();
                 ++iter;
                 ++qiter;
                 if(lpys2.length == iter){
                   iter = 0;
                   getRouteData3();
                 }
                 else
                   getRouteData2();
               });

  set_new_progress(qiter/allq*20);
}
function getRouteData3(){
    ymaps.route([{ type: 'wayPoint', point: [DTPx, DTPy] }, 
                 { type: 'wayPoint', point: [lpys3[iter].latitude, lpys3[iter].longitude] }
               ]).done(function (route) {
                 res3[iter] = {};
                 res3[iter].time = route.getJamsTime();
                 res3[iter].dl = route.getLength();
                 ++iter;
                 ++qiter;
                 if(lpys3.length == iter){
                   iter = 0;
                   getRouteData4();
                 }
                 else
                   getRouteData3();
               });

  set_new_progress(qiter/allq*20);
}
function getRouteData4(){
    ymaps.route([{ type: 'wayPoint', point: [DTPx, DTPy] }, 
                 { type: 'wayPoint', point: [lpys4[iter].latitude, lpys4[iter].longitude] }
               ]).done(function (route) {
                 res4[iter] = {};
                 res4[iter].time = route.getJamsTime();
                 res4[iter].dl = route.getLength();
                 ++iter;
                 ++qiter;
                 if(lpys4.length == iter){
                   iter = 0;
                   sendDTPdata();
                 }
                 else
                   getRouteData4();
               });

  set_new_progress(qiter/allq*20);
}

// results
function get_time_string(gtime){
  var temp = ' ' + Math.floor(gtime/3600) + ' часов ' + Math.floor((gtime - Math.floor(gtime/3600)*3600)/60) + ' минут ' + Math.floor(gtime - Math.floor(gtime/60) * 60) + ' секунд.';
  return temp;
}
function set_result(res, div_name){
  var string = 'Суммарное затраченное время на доставку пострадавших в ЛПУ: ' + get_time_string(res[0]) + '<br />';
  string +=  ' Минимальное время приезда машины(минут): ' + Math.floor(res[1]/60) + '; максимальное(минут): ' + Math.floor(res[2]/60) + '.<br />';
  string +=  ' Минимальное время доставки пострадавшего в ЛПУ(минут): ' + Math.floor(res[3]/60) + '; максимальное(минут): ' + Math.floor(res[4]/60) + '.';
   $(div_name).html(string);
}

function set_selfsolve_results(){
  if(last_vict_cars > 0 || last_vict_lpys > 0){
    alert('Вы еще не завершили решение.');
    return;
  }
  
  set_result(sstime, '#selfRes');
  alert('Ознакомиться с результатами можно на вкладке "Результаты".');

}

function set_auto_results(res){
  set_result(res, '#autoRes');
  alert('Ознакомиться с результатами можно на вкладке "Результаты".');

}


