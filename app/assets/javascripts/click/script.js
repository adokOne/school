
$(function() {
  $('.click').click(function() {
    $('a#bingc-phone-button').trigger('click');
    return false;
});
  $('#menu').slicknav({
    label: 'МЕНЮ',
    prependTo:'body'
  });

  $('#wmyCarousel2').carousel({
      interval: 2000
  });
  $('#wmyCarousel').carousel({
      interval: 2000
  });

  $('#portfolio-slider').carousel({
      interval: 3000
  });
  $('#btn-close').click(function(){
    $("#menu-nav").toggle("slow");
    $("#c-menu").removeClass("is-active");
    return false;
  });

$('#portfolio-slider').on('slid.bs.carousel', function () {
  $('.preview').slick("setPosition", 0);
});



  $(document).click(function(e) {
    if($('#menu-nav').css('display') == "block"){
       if($(e.target).closest("#menu-nav").length==0 && e.target.className != 'menu-caption' && e.target.className != 'c-menu c-menu--htx is-active' && e.target.className != 'label-menu') {
        $("#menu-nav").hide("slow");
        $("#c-menu").removeClass("is-active");
      }

    }
  });

$( "#navbar" ).click(function() {
  if ($("#c-menu").hasClass("is-active") == true) 
  {
    $("#c-menu").removeClass("is-active");
  }
  else
  { $("#c-menu").addClass("is-active");  }

  $("#menu-nav").toggle("slow");
});

var $menu = $("nav#navbar");
$(window).scroll(function(){
  if ( $(this).scrollTop() > 270 ){
    $menu.addClass("fixed");
  } else if($(this).scrollTop() <= 270 ) {
    $menu.removeClass("fixed");
  }
});//scroll

$(window).load(function(){ 
  var fh = $('footer').height(); 
  var wh = $(window).height(); 
  var сh = wh-(fh*3); 
  $('.price-content').css('min-height', сh); 
});


$( ".btn-1" ).click(function() {
  $(".more-1").toggle("slow");
 
  return false;
});
$( ".btn-2" ).click(function() {
  $(".more-2").toggle("slow");
 
  return false;
});$( ".btn-3" ).click(function() {
  $(".more-3").toggle("slow");
 
  return false;
});$( ".btn-4" ).click(function() {
  $(".more-4").toggle("slow");
 
  return false;
});


$( "#sub-menu-link" ).click(function() {
    $("#sub-menu").toggle("fast", function () {

    });
    var height_arttr = $("#menu-nav").attr("style");
      if(height_arttr == "height: 600px;"){
        $("#menu-nav").animate({height: 400}, 450);
      }
      else{
        $("#menu-nav").animate({height: 600}, 450);
      }
  });


$window = $(window);
$(document).ready(function(){
    $('section[data-type="bg1"]').each(function(){
        var $bgobj = $(this); 
        $window.scroll(function() {
            var yPos = -($window.scrollTop() / $bgobj.data('speed')); 
            var coords = 'center '+ yPos + 'px';
            $bgobj.css({ backgroundPosition: coords });
        });
    });
    $('section[data-type="bg2"]').each(function(){
        var $bgobj = $(this); 
        $window.scroll(function() {
            var yPos = -($window.scrollTop() / $bgobj.data('speed'));
            var coords = 'center '+ yPos + 'px';
            $bgobj.css({ backgroundPosition: coords });
        });
    });
    $('section[data-type="bg-1"]').each(function(){
        var $bgobj = $(this); 
        $window.scroll(function() {
            var yPos = -($window.scrollTop() / $bgobj.data('speed'));
            var coords = 'center '+ yPos + 'px';
            $bgobj.css({ backgroundPosition: coords });
        });
    });
     $('section[data-type="bg-2"]').each(function(){
        var $bgobj = $(this); 
        $window.scroll(function() {
            var yPos = -($window.scrollTop() / $bgobj.data('speed'));
            var coords = 'center '+ yPos + 'px';
            $bgobj.css({ backgroundPosition: coords });
        });
    });
      $('section[data-type="bg-3"]').each(function(){
        var $bgobj = $(this); 
        $window.scroll(function() {
            var yPos = -($window.scrollTop() / $bgobj.data('speed'));
            var coords = 'center '+ yPos + 'px';
            $bgobj.css({ backgroundPosition: coords });
        });
    });
});


$('#modal-form').validate({
  rules: {
    name: {
      required: true,
    },
    phone: {
      required: true,
      digits: true
    }
  },
  messages: {
    name: {
      required: "Введите имя",
    },
    phone: {
      required: "Введите телефонный номер Напр: 380671234567",
      digits: "Только цыфры"
    }
  }
});
$('#contact-form').validate({
  rules: {
    name: {
      required: true,
    },
    email: {
      required: true,
      email: true,
    }
  },
  messages: {
    name: {
      required: "Введите имя",
    },
    email: {
      required: "Пример ввода: user@excemple.com"
    }
  }
});

});


