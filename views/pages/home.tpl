<div class="row">

  {{template "partials/left-sidebar.tpl"}}



  <div class="col-sm-7">
    <h1>{{i18n $.Lang .Title}}</h1>
    <div class="list-item-container q-list">
    {{range $index, $val := .Feeds}}
      <p> {{$val.Doer}} {{$val.ActivityType}}</p>
      <div class="one-item-container q-item">
        <strong></strong> {{i18n $.Lang "answered_this" $val.doer}}<br/>

        <div class="a-item-header">
          <a href="#" class='{{if neq $.Lang "ar-SA"}}pull-right {{end}}{{if eq $.Lang "ar-SA"}}pull-left {{end}}'>
            <img class='a-item-author-img{{if eq .Lang "ar-SA"}}-arabic{{end}}' src="/static/img/author.jpg">
          </a>
          <p> About the writer: Programmer and political scientist </p>
          <h3><a href="/question/{{$val.q_id}}">{{$val.question_text}}</a></h3>
        </div>
        <p>
          {{shorten_makrdown $val.text 120 }}
          <a href="/answer/{{$val.id}}" class="short-btn read-more-btn">{{i18n $.Lang "read_more"}}</a>
        </p>

        <span> {{i18n $.Lang "time_written" }}:  <a href="/answer/{{$val.id}}">{{$val.created_at}}</a> </span>

        <div class="btn-toolbar" role="group" aria-label="reaction area">
          <a class='reaction-btn {{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-success short-btn'
            href='#' data-rtype="1" data-oid="{{$val.id}}"
            data-btype="+" data-irt="2" data-opposite="{{$val.id}}-dislike-counter"
            data-myid="{{$val.id}}-like-counter">
            <span id="{{$val.id}}-like-counter">
              {{$val.love_count}}
            </span>
            <i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i>
          </a>
          <a class='reaction-btn {{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-danger short-btn'
            href='#' data-rtype="0" data-oid="{{$val.id}}"
            data-btype="-" data-irt="2"
            data-myid="{{$val.id}}-dislike-counter"
            data-opposite="{{$val.id}}-like-counter">
            <span id="{{$val.id}}-dislike-counter">
              {{$val.hate_count}}
            </span>
            <i class="fa fa-thumbs-down fa-fw" aria-hidden="true"></i>
          </a>
          <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-info short-btn comment-counter-btn' data-parentType="2"  data-parentId="{{$val.id}}"
            data-targetForm="{{$val.id}}-comments-form" data-targetList="{{$val.id}}-comments-list" href='#'>
            <span>
              {{$val.comment_count}}
            </span>
            <i class="fa fa-comments fa-fw" aria-hidden="true"></i>
          </a>

          <a class='{{if neq $.Lang "ar-SA"}}pull-right {{end}}btn btn-info short-btn' style='margin-right:1em;margin-left:1em;' href='/question/{{$val.q_id}}'>
            {{ i18n $.Lang "answer_this"}} <i class="fa fa-reply fa-fw" aria-hidden="true"></i>
          </a>
        </div>
        <div class="comment-wrapper">
          <div id="{{$val.id}}-comments-form" class="hidden" data-itemType="1" data-parentId="{{$val.id}}">

          </div>
          <div id="{{$val.id}}-comments-list" class="comments-list">

          </div>
        </div>


      </div>

    {{end}}
    </div>

  </div>








  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
