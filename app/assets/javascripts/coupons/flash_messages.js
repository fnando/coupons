(function(){
  'use strict';

  $('.flash-message-close').on('click', function(){
    $(this).closest('.flash-message').slideUp();
  });
})();
