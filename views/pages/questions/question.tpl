<div class="row">

  {{template "partials/left-sidebar.tpl"}}

  <div class="col-sm-7">
    <h1>{{i18n $.Lang .Question.Text}}</h1>
    <div class="one-item-container">
      <p><strong>{{i18n $.Lang "description"}}:</strong></p>
      <p>{{.Question.Description}}</p>

      {{if $.CanAnswer }}
      <div class="a-item one-item-container">
        <form method="POST" action="/api/answer/{{.Question.Id}}" id="new-answer-form">
          {{ .xsrfdata }}

            <!--<span class='input-group-addon form-control-arabic' id="basic-addon1">{{i18n .Lang "new_answer"}}</span>
            <input type="text" class="form-control form-control-arabic" name="text" placeholder='{{i18n .Lang "enter_answer_here"}}' id="answer-text-editor" aria-describedby="basic-addon1">
          -->
            <textarea class="textwrapper" name="text" placeholder='{{i18n .Lang "enter_answer_here"}}' rows="10" id="answer-text-editor"></textarea>

          <br>
          <button class="btn btn-primary" id="add-new-answer-btn">{{i18n .Lang "save"}}</button>

        </form>
      </div>
      {{end}}

      </div>

      <h1>{{i18n $.Lang "answers"}}</h1>

      {{range $index, $val := .Answers}}

      <div class="a-item one-item-container">

          <div class="a-item-header">
            <a href="#" class='{{if neq $.Lang "ar-SA"}}pull-right {{end}}{{if eq $.Lang "ar-SA"}}pull-left {{end}}'>
              <img class='a-item-author-img{{if eq $.Lang "ar-SA"}}-arabic{{end}}' src="/static/img/author.jpg">
            </a>
            <p>By: <a href="#">{{$val.Author }}</a><br/>
            <h3><a href="/question/{{$val.Question.Id}}">&nbsp;</a></h3>
          </div>

          <p></p>
          <p>
            {{$val.Text | markdown}}
          </p>


          <span>{{i18n $.Lang "time_written" }}:  <a href="/answer/{{$val.Id}}" class="short-btn read-more-btn">{{dateformat $val.CreatedAt "02-01-06 03:04 PM"}}</a> </span>


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
            <a id="{{$val.Id}}-1-comment-counter-btn" class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-info short-btn comment-counter-btn'  data-parentType="1"  data-parentId="{{$val.Id}}"
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
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
