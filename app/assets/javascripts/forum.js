$(document).ready(function(){
  $(document).on('click', '.star-post', function(e){

    e.preventDefault();

    var a = $(e.currentTarget),
        url = a.attr('href'),
        span = a.siblings('.plazapost-stars').first(),
        ustars = $('#user_stars');

    $.ajax({
      url: url,
      method:'GET',
      success: function(d){
        span.text('x' + d.post_stars);
        ustars.text(d.user_stars + ' Stars');
      },
      error: function(e){
        // console.error(e.responseText);
        alert(e.responseJSON.error_message);
      }
    });
    
  })  
});

// $('.star-post').click()

// $.get(href, function(d){
//   if(success)
//   // { success: true, stars: 5 }
//   // span.text(parseInt(span.text()) + 1);
//   span.text(d.stars);
// }).error(function(e));