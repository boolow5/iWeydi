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


          <span>{{i18n $.Lang "time_written" }}:  <a href="/answer/{{$val.Id}}" class="answer-btn read-more-btn">{{dateformat $val.CreatedAt "02-01-06 15:04:05"}}</a> </span>

          <div class="btn-toolbar" role="group" aria-label="...">
            <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-success answer-btn' href='/question/{{$val.Id}}'>
              <span>{{$val.LoveCount}} <i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i></span>
            </a>
            <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-danger answer-btn' href='/question/{{$val.Id}}'>
              <span>{{$val.HateCount}} <i class="fa fa-thumbs-down fa-fw" aria-hidden="true"></i></span>
            </a>
            <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-info answer-btn' href='/question/{{$val.Id}}'>
              <span>{{$val.CommentCount}} <i class="fa fa-comments fa-fw" aria-hidden="true"></i></span>
            </a>
          </div>


      </div>



      {{end}}


  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
