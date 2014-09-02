$(document).ready(function(){
  $(document).on('click', '.star-post', function(e){

    var a = $(e.currentTarget),
        url = a.attr('href'),
        span = s.siblings('post-stars')[0];



    $.ajax({
      url: url,
      method:'GET',
      success: function(d){
      
      },
      error: function(e){

      }
    });

    // $.get(href, function(d){
    //   if(success)
    //   // { success: true, stars: 5 }
    //   // span.text(parseInt(span.text()) + 1);
    //   span.text(d.stars);
    // }).error(function(e));

    e.preventDefault();
  })  
});

$('.star-post').click()