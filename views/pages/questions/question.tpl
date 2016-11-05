<div class="row">

  {{template "partials/left-sidebar.tpl"}}

  <div class="col-sm-7">
    <h1>{{i18n $.Lang .Question.Text}}</h1>
    <div class="one-item-container">
      <p><strong>{{i18n $.Lang "description"}}:</strong></p>
      <p>{{.Question.Description}}</p>
      <hr/>

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
        <a href="#">
          <img class='a-item-author-img{{if eq $.Lang "ar-SA"}}-arabic{{end}}' src="/static/img/author.jpg">
        </a>

          <div class="a-item-header">
            By: <a href="#">{{$val.Author }}</a>
          </div>
          <p>{{$val.Text | markdown}}</p>

          <span>{{i18n $.Lang "time_written" }}:  {{dateformat $val.CreatedAt "02-01-06 15:04:05"}} </span>

          <div class="btn-toolbar" role="group" aria-label="...">
            <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-default answer-btn' href='/question/{{$val.Id}}'>
              {{$val.LoveCount}}
              <span class='counter-text'>| {{i18n $.Lang "loved_this"}}</span>
            </a>
            <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-default answer-btn' href='/question/{{$val.Id}}'>
              {{$val.HateCount}}
              <span class="counter-text">| {{i18n $.Lang "hated_this"}}</span>
            </a>
            <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-default answer-btn' href='/question/{{$val.Id}}'>
              {{$val.CommentCount}}
              <span class="counter-text">| {{i18n $.Lang "commented_on_this"}}</span>
            </a>
          </div>


      </div>



      {{end}}


  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
