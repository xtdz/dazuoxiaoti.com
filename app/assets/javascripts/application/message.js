(function() {
jQuery(function($) {
  setTimeout(function(){
  	$(".message_notice").html("")
  },3000)
  var img = $(".message_image").attr("alt")
  $('div.head_message').mouseenter(function() {
      $(".message_image").attr("src","/images/message/"+img+"_d.png");
  }).mouseleave(function() {
   $(".message_image").attr("src","/images/message/"+img+".png");
  });
  
});
}).call(this);
