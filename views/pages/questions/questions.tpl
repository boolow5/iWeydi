<div class="row">

  {{template "partials/left-sidebar.tpl"}}

  <div class="col-sm-7">
    <h1>{{i18n $.Lang .Title}}</h1>
    <div class="list-item-container q-list">
    {{range $index, $val := .Questions}}

      <div class="one-item-container q-item">

        <h3><a href="/question/{{$val.Id}}">{{$val.Text}}</a></h3>
        <p>{{$val.Description}}</p>


        <span> {{i18n $.Lang "time_written" }}:  <a href="/question/{{$val.Id}}">{{$val.CreatedAt}}</a> </span>

        <div class="btn-toolbar" role="group" aria-label="reaction area">
          <a class='reaction-btn {{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-success short-btn'
            href='#' data-rtype="1" data-oid="{{$val.Id}}"
            data-btype="+" data-irt="1" data-opposite="{{$val.Id}}-dislike-counter"
            data-myid="{{$val.Id}}-like-counter">
            <span id="{{$val.Id}}-like-counter">
              {{$val.LoveCount}}
            </span>
            <i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i>
          </a>
          <a class='reaction-btn {{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-danger short-btn'
            href='#' data-rtype="0" data-oid="{{$val.Id}}"
            data-btype="-" data-irt="1" id="negative-reaction-btn-{{$val.Id}}"
            data-opposite="{{$val.Id}}-like-counter"
            data-myid="{{$val.Id}}-dislike-counter">
            <span id="{{$val.Id}}-dislike-counter">
              {{$val.HateCount}}
            </span>
            <i class="fa fa-thumbs-down fa-fw" aria-hidden="true"></i>
          </a>
          <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-info short-btn comment-counter-btn'  data-parentType="1"  data-parentId="{{$val.Id}}"
            data-targetForm="{{$val.Id}}-comments-form" data-targetList="{{$val.Id}}-comments-list" href='#'>
            <span>
              {{$val.CommentCount}}
            </span>
            <i class="fa fa-comments fa-fw" aria-hidden="true"></i>
          </a>

          <a class='{{if neq $.Lang "ar-SA"}}pull-right {{end}}btn btn-info short-btn' style='margin-right:1em;margin-left:1em;' href='/question/{{$val.Id}}'>
            {{ i18n $.Lang "answer_this"}} <i class="fa fa-reply fa-fw" aria-hidden="true"></i>
          </a>
        </div>
        <div class="comment-wrapper">
          <div id="{{$val.Id}}-comments-form" class="hidden" data-itemType="1" data-parentId="{{$val.Id}}">

          </div>
          <div id="{{$val.Id}}-comments-list" class="comments-list">

          </div>
        </div>



      </div>

    {{end}}
    </div>

  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
