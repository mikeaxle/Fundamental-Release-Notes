$(function(){
  "use strict";
  initToggleShow();
  initCustomSelect();
});


function initToggleShow(){
  "use strict";
  $('[data-toggle]').each(function(){
    var $toggle = $(this);

    var toggleSpeed = '',
        toggleAnimate = '';

    toggleSpeed = $toggle.data('toggle-speed');
    toggleAnimate = $toggle.data('toggle-animate');

    // defaults if not specified
    if(toggleSpeed === '') {toggleSpeed = 350;}
    if(toggleAnimate === '') {toggleAnimate = false;}

    var $tar = $( $toggle.data('toggle') );
    if( !$tar.hasClass('is-open') && !$tar.hasClass('is-active') ){
      $tar.hide();
    }

    $toggle.click(function(e){
      e.preventDefault();
      $toggle.toggleClass('is-active');

       if(toggleAnimate){
          $tar.slideToggle( toggleSpeed, function() {
              $tar.toggleClass('is-open');
          });
        } else {
          $tar.toggle();
          $tar.toggleClass('is-open');
        }

    });

  });
}



function initCustomSelect(){
  "use strict";

  $('[data-widget="CustomSelect"]').each(function(){
    var $this = $(this);
    var $select = $this.find('select');

    $this
      .append('<div class="custom-select__value">')
      .append('<div class="custom-select__arrow"><span class="svg svg-arrow-down"></span></div>');

    var $val = $this.find('.custom-select__value');

    // set label
    $val.text( $select.find(':selected').text() );
    $select.change(function(){
      $val.text( $select.find(':selected').text() );
    });


  });

}

