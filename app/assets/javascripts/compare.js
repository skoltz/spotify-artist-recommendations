$(function prepareList() {
	$('#exp-list').find('li:has(ul)').unbind('click').click(function(event) {
		if(this == event.target) {
			$(this).toggleClass('expanded');
			$(this).children('ul').toggle('medium');
		}
		return false;
	}).addClass('collapsed').removeClass('expanded').children('ul').hide();
	 
	//links inside the cv
	$('#exp-list a').unbind('click').click(function() {
		window.open($(this).attr('href'));
		return false;
	});

	$('#expand-list').unbind('click').click(function() {
		$('.collapsed').addClass('expanded');
		$('.collapsed').children().show('medium');
	})
	$('#collapse-list').unbind('click').click(function() {
		$('.collapsed').removeClass('expanded');
		$('.collapsed').children().hide('medium');
	})
});

