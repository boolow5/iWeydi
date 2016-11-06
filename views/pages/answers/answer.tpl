<div class="row">

  {{template "partials/left-sidebar.tpl"}}

  <div class="col-sm-7">
    <h1>{{.Question.Text}}</h1>
    <div class="one-item-container">
      <p><strong>{{i18n $.Lang "description"}}:</strong></p>
      <p>{{.Question.Description}}</p>
    </div>


      <div class="a-item one-item-container">

          <div class="a-item-header">
            <a href="#" class='{{if neq $.Lang "ar-SA"}}pull-right {{end}}{{if eq $.Lang "ar-SA"}}pull-left {{end}}'>
              <img class='a-item-author-img{{if eq $.Lang "ar-SA"}}-arabic{{end}}' src="/static/img/author.jpg">
            </a>
            <p>By: <a href="/user/{{.Answer.Author.Id}}">{{.Answer.Author.Profile.FullName }}</a><br/>
            <h3><a href="/answer/{{.Answer.Question.Id}}">&nbsp;</a></h3>
          </div>

          <p></p>
          <p>
            {{.Answer.Text | markdown}}
          </p>


          <span>{{i18n $.Lang "time_written" }}:  <a href="/answer/{{.Answer.Id}}" class="answer-btn read-more-btn">{{dateformat .Answer.CreatedAt "02-01-06 15:04:05"}}</a> </span>

          <div class="btn-toolbar" role="group" aria-label="...">
            <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-success answer-btn' href='/question/{{.Answer.Question.Id}}'>
              <span>{{.Answer.LoveCount}}  <i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i></span>
            </a>

            <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-danger answer-btn' href='/answer/{{.Answer.Id}}'>
              <span>{{.Answer.HateCount}} <i class="fa fa-thumbs-down fa-fw" aria-hidden="true"></i></span>
            </a>
            <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn  btn-info answer-btn' href='/answer/{{.Answer.Id}}'>
              <span>{{.Answer.CommentCount}} <i class="fa fa-comments fa-fw" aria-hidden="true"></i> </span>
            </a>
          </div>


      </div>


  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
