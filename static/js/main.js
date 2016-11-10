var ajax = $.ajax;
$.extend({
    ajax: function(url, options) {
        if (typeof url === 'object') {
            options = url;
            url = undefined;
        }
        options = options || {};
        url = options.url;
        var xsrftoken = $('meta[name=_xsrf]').attr('content');
        var headers = options.headers || {};
        var domain = document.domain.replace(/\./ig, '\\.');
        if (!/^(http:|https:).*/.test(url) || eval('/^(http:|https:)\\/\\/(.+\\.)*' + domain + '.*/').test(url)) {
            headers = $.extend(headers, {'X-Xsrftoken':xsrftoken});
        }
        options.headers = headers;
        return ajax(url, options);
    }
});


function getFormData(formId){
  frm = document.getElementById(formId);
  var data = {};
  for (var i=0, ii = frm.length; i< ii; ++i) {
    var input = frm[i];
    if (input.name) {
      data[input.name] = input.value;
    }
  }
  return data;
}

function translate(result, ids) {
  returned_word = ""
  if (result["error"]) {
    returned_word = result["error"]
  } else if (result["success"]) {
    returned_word = result["success"]
  }
  $.ajax({
    url: "http://localhost:8080/translate/"+returned_word+"/-1",
    type: "GET",
    contentType: "application/json",
    success: function(another_result) {
      console.log(another_result);
      if (returned_word) {
        for (var i=0; i<ids.length; i++) {
          $(ids[i]).html(another_result["meaning"]);
        }
      }
    }
  });
}


//
$("#login-form").submit(function(e){
  e.preventDefault();

  $.ajax({
    url: this.action,
    type: this.method,
    data: JSON.stringify(getFormData("login-form")),
    contentType: "application/json",
    success: function(result) {
      //window.location.href = "http://localhost:8080";
      if (result["error"]) {
        $("#error").removeClass("hidden");
        //$("#success").addClass("hidden");
        //$("#error").html(message);
        console.log(result);
        translate(result, ["#error"]);
      } else if (result["success"]) {
        $("#login-form").html('');
        document.location.reload();
      }
    }
  })

  //return false;
});

$("#register-form").submit(function(e){

  e.preventDefault();

  $.ajax({
    url: this.action,
    type: this.method,
    data: JSON.stringify(getFormData("register-form")),
    contentType: "application/json",
    success: function(result) {
      if (result["error"]) {
        $("#error").removeClass("hidden");
        $("#success").addClass("hidden");
        //$("#error").html(message);
        translate(result, ["#error"]);
      } else if (result["success"]) {
        $("#register-form").html('');
        document.location.replace("/");
      }
    }
  });

  return false;
});



$("#question-form").submit(function(e){
  e.preventDefault();

  $.ajax({
    url: this.action,
    type: this.method,
    data: JSON.stringify(getFormData("question-form")),
    contentType: "application/json",
    success: function(result) {
      if (result["error"]) {
        $("#error").removeClass("hidden");
        $("#success").addClass("hidden");
        console.log(result);
        translate(result, ["#error"]);
      } else if (result["success"]) {
        $("#success").removeClass("hidden");
        $("#error").addClass("hidden");
        console.log(result);
        translate(result, ["#success"]);
        //document.location.reload();
        //$("#question-form").html('');
      }
    }
  })
});

$(".reaction-btn").on("click", function (e) {
  e.preventDefault();
  var reaction_type = $(this).data('rtype');
  var btn_type = $(this).data('btype');
  var item_id = $(this).data('oid');
  var item_type = $(this).data('irt');

  if (reaction_type != 'undefined' && item_id != undefined) {

    var url =   "/api/reaction/"+item_id+"/"+reaction_type+"/"+item_type;
    var likeCounterId = "#"+item_id+"-like-counter";
    var dislikeCounterId = "#"+item_id+"-dislike-counter";
    var mybtn = $(this);

    $.ajax({
      url: url,
      type: "POST",
      contentType: "application/json",
      success: function(result) {
        console.log(result);
        if (result["reactions"] != 'undefined') {
          var reactions = result["reactions"];
          if (reactions != 'undefined') {
            //$(this).prop("disabled",true);
            var opposite = "#"+mybtn.data('opposite');
            var current = "#"+mybtn.data('myid')

            if (mybtn.data('btype') == '-') {
              $(current).html(reactions["hate_count"]);
              $(opposite).html(reactions["love_count"]);

              console.log('type: "-"');
            } else if (mybtn.data('btype') == '+') {

              $(current).html(reactions["love_count"]);
              $(opposite).html(reactions["hate_count"]);

              console.log('type: "+"');
            }
          }
        }
      }
    })
  }
});

$("#new-answer-form").submit(function(e){
  e.preventDefault();

  $.ajax({
    url: this.action,
    type: this.method,
    data: JSON.stringify(getFormData("new-answer-form")),
    contentType: "application/json",
    success: function(result) {
      if (result["error"]) {
        $("#error").removeClass("hidden");
        console.log(result);
        translate(result, ["#error"]);
      } else if (result["success"]) {
        $("#success").removeClass("hidden");
        console.log(result);
        translate(result, ["#success"]);
        $("#new-answer-form").html('');
        //document.location.reload();
      }
    }
  })

  //return false;
});


// change locale and reload page
  $(document).on('click', '.lang-changed', function(){

    var $e = $(this);
    var lang = $e.data('lang');

    $.cookie('lang', lang, {path: '/', expires: 365});

    window.location.reload();
  });

  // change to current language
