(function(){
  'use strict';

  var table = $('.coupons-table');
  var main = table.find('thead :checkbox');
  var checkboxes = table.find('tbody :checkbox');
  var howMany = checkboxes.length;
  var actions = $('.coupons-actions');

  function toggleActions() {
    var howManySelected = checkboxes.filter(':checked').length;

    if (howManySelected > 0) {
      actions.slideDown();
    } else {
      actions.slideUp();
    }

    actions.removeClass('hidden');
    actions.find('.selected').text(howManySelected + ' coupons selected');
  }

  main.on('change', function(event){
    checkboxes.prop('checked', this.checked);
    toggleActions();
  });

  table.on('change', 'tbody :checkbox', function(event){
    var selected = checkboxes.filter(':checked');
    var howManySelected = selected.length;
    main.prop('checked', howMany === howManySelected);

    toggleActions();
  });
})();
