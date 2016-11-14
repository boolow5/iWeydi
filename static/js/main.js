var ajax = $.ajax;
$.extend({
    ajax: function(url, options) {
        if (typeof url === 'object') {
            options = url;
            url = undefined;
        }
        options = options || {};
        url = options.url;
        //var xsrftoken = $('meta[name=_xsrf]').attr('content');
        var xsrftoken   = $('input[name=_xsrf]').attr('value');

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
    url: "/translate/"+returned_word+"/-1",
    type: "GET",
    contentType: "application/json",
    success: function(another_result) {

      if (returned_word) {
        for (var i=0; i<ids.length; i++) {
          $(ids[i]).html(another_result["meaning"]);
        }
      }
    }
  });
}

$(".comment-counter-btn").on("click", function(e){
  e.preventDefault();
  var targetForm = $(this).data('targetform');
  var targetList = $(this).data('targetlist')
  var parentType = $(this).data('parenttype');
  var parentId = $(this).data('parentid');
  if ($("#"+targetForm).hasClass('hidden')) {
    $("#"+targetForm).removeClass('hidden');
    $("#"+targetList).removeClass('hidden');

    fetchCommentsList(targetList, parentType, parentId);
    fetchCommentsForm(targetForm, parentType, parentId);

  } else {
    $("#"+targetForm).addClass('hidden');
    $("#"+targetList).addClass('hidden');
  }
});

function fetchCommentsList(targetList, parentType, parentId){
  $.ajax({
    url: "/comments/"+parentType+"/"+parentId,
    type: "GET",
    success: function(result) {
      $("#"+targetList).html(result);
    }
  });
}

function fetchCommentsForm(targetForm, parentType, parentId){
  $.ajax({
    url: "/comment?parent_type="+parentType+"&parent_id="+parentId,
    type: "GET",
    success: function(result) {
      $("#"+targetForm).html(result);
    }
  });
}

function submitComment(formId) {

  var form = document.getElementById(formId);
  var url = form.action;
  var method = form.method;

  var parts = url.split("/")
  var parent_id = parts[parts.length-1];
  var parent_type = parts[parts.length-2];

  var targetList = parent_id+"-comments-list";
  var targetForm = parent_id+"-comments-form";

  $.ajax({
    url: url,
    type: method,
    data: JSON.stringify(getFormData(formId)), /*'{"text":"'+ form["text"].value +'"}',*/
    contentType: "application/json",
    success: function(result) {

      if (result["success"]) {
        counter_id = "#"+ parent_id +"-"+ parent_type +"-comment-counter-btn";

        current_counter = parseInt($(counter_id).children().first().html());

        $(counter_id).children().first().html(current_counter+1);

        fetchCommentsList(targetList, parent_type, parent_id);
        fetchCommentsForm(targetForm, parent_type, parent_id);
      }
    }
  })

  return false;
}

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

        translate(result, ["#error"]);
      } else if (result["success"]) {
        $("#success").removeClass("hidden");
        $("#error").addClass("hidden");

        translate(result, ["#success"]);
        $("#question-form").empty();
        document.location.replace("/questions");
      }
    }
  })
});

$(".comment-btn").on("click", function (e) {
  e.preventDefault();
  var comments = {};
  var loading = true;

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

        if (result["reactions"] != 'undefined') {
          var reactions = result["reactions"];
          if (reactions != 'undefined') {
            //$(this).prop("disabled",true);
            var opposite = "#"+mybtn.data('opposite');
            var current = "#"+mybtn.data('myid')

            if (mybtn.data('btype') == '-') {
              $(current).html(reactions["hate_count"]);
              $(opposite).html(reactions["love_count"]);


            } else if (mybtn.data('btype') == '+') {

              $(current).html(reactions["love_count"]);
              $(opposite).html(reactions["hate_count"]);


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

        translate(result, ["#error"]);
      } else if (result["success"]) {
        $("#success").removeClass("hidden");

        translate(result, ["#success"]);
        $("#new-answer-form").html('');
        //document.location.reload();
      }
    }
  });
});

$("#search-form").submit(function(e){
  //e.preventDefault();

   //document.getElementById('fade').style.display='block';
  $.ajax({
    url: this.action,
    type: this.method,
    data: JSON.stringify(getFormData("search-form")),
    contentType: "application/json",
    success: function(result) {
      $("#search-results").empty();
      console.log(result);
      var questions = result["questions"];
      if (!questions) {
        document.getElementById("search-results").style.display='none';
        return
      }

      var q = "<ul class='list-unstyled'>";
      for (var i = 0; i < questions.length; i++) {
        q += "<li>";
        q += "<a href='/question/"+questions[i]["id"]+"'>";
        q += questions[i]["text"] + "</a>";
        q += "</li>";
      }
      q += "</ul>";
      document.getElementById("search-results").style.display='block';
      $("#search-results").html(q);
    }
  })
  return false;
});


// change locale and reload page
  $(document).on('click', '.lang-changed', function(){

    var $e = $(this);
    var lang = $e.data('lang');

    $.cookie('lang', lang, {path: '/', expires: 365});

    window.location.reload();
  });
